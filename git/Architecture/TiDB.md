https://pingcap.com/



## tidb的排序和分页的两个bug
数据库 tidb
之前tidb就遇到过一个问题，在没有指定排序的情况下，每次查询语句顺序都是不同的，更不用说分页了。

加上排序后每次查询的数据倒是相同的，于是就不管了，但是最近又发现了问题。

运维反馈同一个产品在不同的分页中重复出现，多次尝试执行语句后发现是因为排序的字段有重复。在tidb中，如果排序的字段有重复，那么在固定分页的情况下，比如limit 0,30，返回的数据是固定排序的，但是你改变分页，比如改成limit 30,30，你会发现之前limit 0,30中的数据可能会出现在limit 30,30页面中。不仅如此，使用分页limit 0,10,limit 10,10，limit 20,10查询出来的数据和limit 0,30的数据也不一样，不过令人意外的是查出来的数据不会像无排序那样一直改变，不知道是怎样的算法。总而言之，如果排序的字段中有重复的数据，比如时间，那么分页查询出来的数据拼起来不等于整体的数据。这是很不合理的，我认为这算是个bug，给人极大地误导，要避免这种情况只能加上不会重复的第二排序，比如主键。让人头疼，为此我得审视之前所有的查询语句了


# 一 关于tidb的排序
     1. 按照字节序的顺序扫描的效率是比较高的；
     2. 连续的行大概率会存储在同一台机器的邻近位置，每次批量的读取和写入的效率会高；
     3. 索引是有序的（主键也是一种索引），一行的每一列的索引都会占用一个 KV Pair，比如，某个表除了主键有 3 个索引，那么在这个表中插入一行，对应在底层存储就是 4 个 KV Pairs 的写入：数据行以及 3 个索引行；
     4. 一行的数据都是存在一个 KV Pair 中，不会被切分，这点和类 BigTable 的列式存储很不一样。
    表的数据在 TiDB 内部会被底层存储 TiKV 切分成很多 64M 的 Region（对应 Spanner 的 Splits 的概念），每个 Region 里面存储的都是连续的行，Region 是 TiDB 进行数据调 度的单位，随着一个 Region 的数据量越来越大和时间的推移，Region 会分裂/合并，或者移动到集群中不同的物理机上，使得整个集群能够水平扩展。
建议：
     1. 尽可能批量写入，但是一次写入总大小不要超过 Region 的分裂阈值（64M），另外 TiDB 也对单个事务有大小的限制；
     2. 存储超宽表是比较不合适的，特别是一行的列非常多，同时不是太稀疏，一个经验是最好单行的总数据大小不要超过 64K，越小越好。大的数据最好拆到多张表中；
     3. 对于高并发且访问频繁的数据，尽可能一次访问只命中一个 Region，这个也很好理解，比如一个模糊查询或者一个没有索引的表扫描操作，可能会发生在多个物理节点上，一来会有更大的 网络开销，二来访问的 Region 越多，遇到 stale region 然后重试的概率也越大（可以理解为 TiDB 会经常做 Region 的移动，客户端的路由信息可能更新不那么及时），这些可能会影响 延迟；另一方面，小事务（在一个 Region 的范围内）的写入的延迟会更低，TiDB 针对同一个 Region 内的跨行事务是有优化的。另外 TiDB 对通过主键精准的点查询（结果集只有一条）效率更高。
二 关于索引
     除了使用主键查询外，TiDB 允许用户创建二级索引以加速访问，就像上面提到过的，在 TiKV 的层面，TiDB 这边的表里面的行数据和索引的数据看起来都是 TiKV 中的 KV Pair，所以很多适用于表数据的原则也适用于索引。和 Spanner 有点不一样的是，TiDB 只支持全局索引，也就是 Spanner 中默认的 Non-interleaved indexes。全局索引的好处是对使用者没有限制，可以 scale 到任意大小，不过这意味着，索引信息*不一定*和实际的数据在一个 Region 内。
建议：
     1. 对于大海捞针式的查询来说 (海量数据中精准定位某条或者某几条)，务必通过索引；
     2. 当然也不要盲目的创建索引，创建太多索引会影响写入的性能。
三 热点问题:
     热点可以理解为热点数据，或者说热点 region，TiDB 自带的 grafana 监控指标中也有 hot region write / read 的 metrics。但是我的理解热点问题更准确的表现形式，其实是 某（几）个tikv 节点的 corprocessor / scheduler （负责读/写模块的线程）消耗资源过高，而剩下的 kv 节点资源白白闲置。对于分布式系统来说，优点突出但是可能存在木桶效应，某一个组件/服务器资源瓶颈，会影响到整个集群的表现。判断热点现象也很简单，查看 tikv 监控页面的 thread CPU 监控项，如果发现 corprocessor 或 scheduler 中各 kv 实例的 CPU 消耗十分不均匀，那大概率就是碰到热点现象了。 产生热点现象的原因有多种，大致总结可分为以下：
     1 部分小表例如配置表的频繁访问引起热点
     2 MySQL 中自增主键的高并发写入
     3 非自增，但时间相关的顺序插入
     4 无主键，或主键为非 int 类型
     5 时间相关字段的索引
     6 业务逻辑/数据分布产生的热点读写
     7 执行计划不合理引起的非必要全表/错误的索引扫描
如何规避
     热点的解决思路有两种，一是加快单次处理的速度，二是将频繁请求的数据分散到不同的 region，然后通过 pd 调度或手工的方式，将 region 的 leader 调度到多个kv 实例中。针对上面的情况，逐一分析。
     1 第一种是小表频繁访问的场景，因为数据量少，而 TiKV 默认的 region 大小为64M，基本上这些数据都会分在一个 region，如果业务高并发访问，势必会引起热点。这种主要是通过业务手段来规避，比较常见的做法是将配置表数据放到缓存中。从数据库角度优化，可以通过 pd-ctl 找到热点 region，确认对应的配置表后，可以手动将热点 region split 为多个，后续 pd 就可以通
过调度算法将这几个不同的 region leader 调度到不同的 kv 节点，缓解热点情况。
     2 第二~四种场景也是比较常见的，一般 MySQL 中都会建议采用 auto_increment 字段作为主键，或者有些业务例如订单系统虽然没有用自增主键，但是基于时间戳来生成一个业务 ID 作为主键，这种对于TiDB 来说跟自增的场景也比较类似。另外还有些时候，客户会选择非 int 类型的字段作为主键，例如手机号码存为 varchar 等。对于这种非 int 类型的主键，TiDB 内部会做一个转换，添加一个自增的 bigint 类型作为主键。所以这几个场景如果出现高并发的大量写入，目前2.0/2.1版本中，基本上单表 TPS 超过1W 就有可能会产生明显的热点效应了。如果想解决可以对 表结构做一些改造，将原主键设为 Unique Key，这样 TiDB 内部会添加一个自增的伪列 _tidb_rowid。我们可以通过 alter table t shard_row_id_bits = 4; 的语句来将数据打散。此语法只对没有显示指定 PK 或 PK 为非整数类型时才有效，打散后插入效率可以大大提升，但是会带来一定的副作用就是进行范围 scan 的时候，打散前可能只需要扫一个 region，打散后可能需要扫多个 region。从 TiDB 4.0 开始， TiDB 提供了一种扩展语(AutoRandom)，用于解决整数类型主键通过 AutoIncrement 属性隐式分配 ID 时的写热点问题。可以利用 AUTO_RANDOM 列属性，将 AUTO_INCREMENT 改为 AUTO_RANDOM，插入数据时让 TiDB 自动为整型主键列分配一个值，消除行 ID 的连续性，从而达到打散热点的目的。
     3 第五种时间字段的索引，在目前2.0版本中，并没有太好的解决办法。未来版本中即将开放的 partition table 这个新的特性，对于这种场景会有一定的缓解。但是在范围分区表中，就不能以时间作为分区键了，可能需要找另外一个字段作为分区键，这样才能够将基于时间的顺序写入切分为多张表来操作以缓解热点情况。
     4 但是这可能会有两个问题，一是这样就不能利用到时间范围分区的最大便利之一的快速归档功能，二是如果基于时间的范围查找，需要将所有分表都通过索引 scan 一遍再 union 之后返回结果。
     5 其实可以考虑类似 Oracle 的组合分区功能，先按照时间范围 partition，在每个 partition 里再 hash partition 一下，这样基于时间的范围查找仍然能够定位到大的分区，大分区下面的所有 hash 子分区必须是要全部 scan 了。
      6 第六种需要结合具体的业务场景来分析，例如某些交易系统中对公账户可能会成为热点账户，这时在业务侧进行拆分，将一个对公账户拆分为10个账户。业务访问热点账户时，可以随机选其中一个账户进行操作，这样可以有效避免热点情况的产生，但是统计的时候需要将所有账户进行归并。另外在对热点数据进行操作的时候，可以考虑在业务层进行排序/合并，降低对热点数据的访问频率。
      7 对于第七种场景，就是上面所提到的要通过提升单次请求的效率来缓解热点问题，主要还是通过优化慢 SQL 的手段。
四 关于TIDB的数据备份和恢复

     TiDB 数据备份和恢复 ，详细介绍可tidb的各种数据备份和数据的恢复操作

五 TiDB 乐观事务模型  TiDB 乐观事务模型    tidb乐观锁事务
优点：
    1 简单，好理解。
    2 基于单实例事务实现了跨节点事务。
    3 去中心化的锁管理。
缺点如下：
    1 两阶段提交，网络交互多。
    2 需要一个中心化的版本管理服务。
    3 事务在 commit 之前，数据写在内存里，数据过大内存就会暴涨。
基于以上缺点的分析，有两点建议
    1. 小事务为了降低网络交互对于小事务的影响，我们建议小事务打包来做 。如在 auto commit 模式下，下面每条语句成为了一个事务：

# 事务auto_commit
UPDATE my_table SET a='new_value' WHERE id = 1;UPDATE my_table SET a='newer_value' WHERE id = 2;
UPDATE my_table SET a='newest_value' WHERE id = 3;
以上每一条语句，都需要经过两阶段提交，网络交互就直接 *3， 如果我们能够打包成一个事务提交，性能上会有一个显著的提升，如下：

# 事务非 auto_commit，手动提交
START TRANSACTION;UPDATE my_table SET a='new_value' WHERE id = 1;UPDATE my_table SET a='newer_value' WHERE id = 2;UPDATE my_table SET a='newest_value' WHERE id = 3;COMMIT;
同理，对于 insert 语句也建议打包成事务来处理。
   2. 大事务两阶段提交的过程当事务过大时，会有以下问题：
   1) 客户端 commit 之前写入数据都在内存里面，TiDB 内存暴涨，一不小心就会 OOM。
   2)  第一阶段写入与其他事务出现冲突的概率就会指数级上升，事务之间相互阻塞影响。
   3)  事务的提交完成会变得很长很长 ～～～
为了解决这个问题，我们对事务的大小做了一些限制：
    1 单个事务包含的 SQL 语句不超过 5000 条（默认）
    2 每个键值对不超过 6MB
    3 键值对的总数不超过 300,000
    4 键值对的总大小不超过 100MB
    因此，对于 TiDB 乐观事务而言，事务太大或者太小，都会出现性能上的问题。我们建议每 100～500 行写入一个事务，可以达到一个比较优的性能。
六 事务限制
    1 单个事务包含的SQL语句不超过5000条
    2 操作的单条记录不超过 6MB
    3 事务操作的总keys不超过 30w
    4 事务操作的所有记录总大小不超过 100MB
    当事务提交发生写入冲突时，乐观锁可以进行事务的重试。需要重试的语句在重试前都要保存在 TiDB server 中，如果事务语句太多，会对 TiDB server 造成很大负担，所以，tidb设置了 5000 这个语句条数限制。 开启悲观锁后，因为事务不会出现写入冲突错误，提交几乎必定成功。所以，我们对于它去掉了事务中语句条数的限制。 关于大事务限制，我们将会在 4.0 中，去掉 30 万 kv 的限制，并将事务大小限制从 100 MB 提升至 10 GB。对于没有开启重试的乐观事务，也将去掉 5000 行语句的限制。4.0 大概在年底发布。 这就导致如果我们要删除一个表中的某个特定条件的行数特别多时删除失败，从而我们不得不一段一段的例如

while True:
    delete table where {$condition} limit n
    if affectrows==0:
        break
    这个场景的现象是delete语句会越来越慢。 因为扫描范围{$condition}是固定不变的，delete删除语句在TiDB处理方式是标记删除，删除本身实际上也是插入一条kv记录，只不过value变成了delete，最后通过逻辑GC和compaction来删除真实数据。所以，循环执行delete 语句，每次删除n条记录，下一次delete语句要扫描的key就会+n，执行时间越来越长(大家可以去做个实验，观察慢日志文件，同样的delete语句total keys会不断增加)。      
    怎么解决呢 
      1 尽量缩小范围删除的粒度，比如提前按分钟将数据分段，打开tidb_batch_delete，提高并发去删除。注意使用开闭区间，分段之间不要出现冲突，TiDB解决事务冲突的代价比较大。

set @@session.tidb_batch_delete=1;
delete from table where create_time > '$start_step' and create_time <= '$end_step';
    如果分段内的数据超出事务大小限制，TiDB会自动将delete操作拆分成多个batch。 个人亲测，这种方式删除数据的速度还是比较快的。
    2 按照日期分表，删除过期的表即可。TiDB删表是秒级的，后续空间回收也比较快，缺点是侵入业务。 两种方式各有利弊，大家可以各取所需。
六 事务冲突，读写冲突和写写冲突
    读写冲突(读写冲突，读请求碰到还未提交的数据，需要等待其提交之后才能读)
   1 开启内存锁,作为一个分布式系统，TiDB 在内存中的冲突检测主要在两个模块进行：TiDB 层。如果发现 TiDB 实例本身就存在写写冲突，那么第一个写入发出后，后面的写入已经清楚地知道自己冲突了，无需再往下层 TiKV 发送请求去检测冲突。TiKV 层。主要发生在 prewrite 阶段。因为 TiDB 集群是一个分布式系统，TiDB 实例本身无状态，实例之间无法感知到彼此的存在，也就无法确认自己的写入与别的 TiDB 实例是否存在冲突，所以会在 TiKV 这一层检测具体的数据是否有冲突。其中 TiDB 层的冲突检测可以根据场景需要选择打开或关闭，具体配置项如下：

# 事务内存锁相关配置，当本地事务冲突比较多时建议开启。
[txn-local-latches]
# 是否开启内存锁，默认为 false，即不开启。
enabled = false
2 开启显示事务
   例如

Insert IGNORE INTO table_name (biz_id,type,field) values(185654,'oaa','oaa_SerializeEndPage') ; Update table_name SET value='2' WHERE biz_id=185654 AND type='oaa' AND  field='oaa_SerializeEndPage';
    数据刚刚 insert，立刻 update，因为 insert 和 update 不在同一个事务里面，事务之间存在读写冲突，并发量越大，读写冲突越明显。我们将这 2 个 SQL 放在一个事务里来避免读写冲突，再进行测试。 将sql 改为

begin;  
Insert IGNORE INTO table_name (biz_id,type,field) values(185654,'oaa','oaa_SerializeEndPage') ; Update table_name SET value='2' WHERE biz_id=185654 AND type='oaa' AND  field='oaa_SerializeEndPage';
commit;  
     写写冲突(：乐观事务中的写写冲突，同时多个事务对相同的 key 进行修改，只有一个事务会成功，其他事务会自动重取 timestamp 然后进行重试)
1 尝试悲观锁

开启悲观锁的命令如下
set @@global.tidb_txn_mode = 'pessimistic';
    不过悲观锁执行时加锁，慢，耗时长，乐观锁在验证时加锁，快，耗时短。悲观锁在 TiDB 中有等待锁的逻辑，所以增加了执行事务的排队等待时间（从官方获知，4.0 版本的悲观锁有了大幅度的改进，目前已经有 50% 以上的性能提升。），如果没有大量的写写冲突不建议开启
七 关于联合索引
    联合索引可以这样理解，比如（a,b,c），abc都是排好序的，在任意一段a的下面b都是排好序的，任何一段b下面c都是排好序的，联合索引的生效原则是 从前往后依次使用生效，如果中间某个索引没有使用，那么断点前面的索引部分起作用，断点后面的索引没有起作用,查询的顺序是指 索引中的顺序 index:a, b, c, 而不是WHERE条件的顺序TiDB 的联合索引只占用一个名额，例如: table_1 有 唯一索引,联合索引 计算方式是30W / (1+1+1) = 10W
例如 表有如下联合索引

CREATE TABLE table_1 ( a BIGINT, b VARCHAR ( 255 ), c INT );ALTER TABLE table_1 ADD INDEX m_index ( a, b, c );
     1 WHERE a = 1 AND b = '2' AND c = 3，这种三个索引顺序使用中间没有断点，全部发挥作用
     2 WHERE a = 1 AND c = 3; 这种情况下b就是断点，a发挥了效果，c没有效果，导致遍历 a = 1的所有结果 
     3 WHERE b = '2' AND c = 3;这种情况下a就是断点，在a后面的索引都没有发挥作用，这种写法联合索引没有发挥任何效果，遍历整个表
     4 WHERE b = '2' AND c = 3 AND a = 1;这个跟第一个一样，全部发挥作用，abc只要用上了就行，跟写的顺序无关
     5 WHERE a = 1 AND b IN ( '2', '4') AND c = 3; 在TiDB中 除了 =等号 和 IN 以外都是范围查询 b 是等值查询
     6 WHERE a = 1 AND b > '2' AND c = 3; b是范围查询, 区间是左开右闭，导致c不起作用
     7 WHERE a = 1 AND b < '2' AND c = 3; b是范围查询, 区间是左闭右开，导致c不起作用
     8 WHERE a = 1 AND b like '2%' AND c = 3; b是范围查询, like的区间是左闭右开 使用的是前缀范围查询，导致c不起作用
     9 WHERE a = 1 AND b like '%2' AND c = 3; b是范围查询, 使用的是非前缀范围查询，TiDB目前是不能够使用非前缀范围查询索引的，导致b,c都不起作用
    10 WHERE a IS NULL AND b = '2' AND c = 3;在TiDB中 除了 =等号 和 IN 以外都是范围查询

最后一些可以优化的参数
1 store-pool-size
     处理 raft 的线程池线程数。默认值：2最小值：大于 0[raftstore]的 store-pool-size 2改成4 完成
2 开启静默region 完成
     用于减少 raftstore CPU 的消耗，将 raftstore.hibernate-regions 配置为 true
3 开启region merge
     Region merge 指的是为了避免删除数据后大量小甚至空的 Region 消耗系统资源，通过调度把相邻的小 Region 合并的过程。 在后台遍历，发现连续的小 Region 后发起调度。
4 开启 Hibernate Region
     在实际情况下，读写请求并不会均匀的打在每个 Region 上，而是主要集中在少数的 Region 上，那么对于暂时空闲的 Region 我们是不是可以尽量减少它们的消息数量。这也就是 Hibernate Region 的主要思想，在无必要的时候不进行 raft-base-tick ，也就是不去驱动那些空闲 Region 的 Raft 状态机，那么就不会触发这些 Region 的 Raft 心跳信息的产生，
极大得减小了 Raftstore 的工作负担。

友情链接

1 官方的问题解答平台  里面有很多使用过程中遇到问题的人的帖子可以逛逛

2 TIDB常见问题处理   tidb官方整理的常见问题的解决方案
————————————————
版权声明：本文为CSDN博主「D_Guco」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/D_Guco/article/details/106313357


## 如何阅读扫表的执行计划
https://docs.pingcap.com/zh/tidb/dev/explain-overview

真正执行扫表（读盘或者读 TiKV Block Cache）操作的算子有如下几类：
TableFullScan：这是大家所熟知的 “全表扫” 操作
TableRangeScan：带有范围的表数据扫描操作
TableRowIDScan：根据上层传递下来的 RowID 精确地扫描表数据
IndexFullScan：另一种“全表扫”，只不过这里扫的是索引数据，不是表数据
IndexRangeScan：带有范围的索引数据扫描操作
TiDB 会汇聚 TiKV/TiFlash 上扫描的数据或者计算结果，这种“数据汇聚”算子目前有如下几类：

TableReader：将 TiKV 上底层扫表算子 TableFullScan 或 TableRangeScan 得到的数据进行汇总。
IndexReader：将 TiKV 上底层扫表算子 IndexFullScan 或 IndexRangeScan 得到的数据进行汇总。
IndexLookUp：先汇总 Build 端 TiKV 扫描上来的 RowID，再去 Probe 端上根据这些 RowID 精确地读取 TiKV 上的数据。Build 端是 IndexFullScan 或 IndexRangeScan 类型的算子，Probe 端是 TableRowIDScan 类型的算子。
IndexMerge：和 IndexLookupReader 类似，可以看做是它的扩展，可以同时读取多个索引的数据，有多个 Build 端，一个 Probe 端。执行过程也很类似，先汇总所有 Build 端 TiKV 扫描上来的 RowID，再去 Probe 端上根据这些 RowID 精确地读取 TiKV 上的数据。Build 端是 IndexFullScan 或 IndexRangeScan 类型的算子，Probe 端是 TableRowIDScan 类型的算