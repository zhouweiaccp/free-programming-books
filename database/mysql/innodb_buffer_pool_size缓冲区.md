线程栈信息使用内存(thread_stack)
主要用来存放每一个线程自身的标识信息，如线程id，线程运行时基本信息等等，我们可以通过 thread_stack 参数来设置为每一个线程栈分配多大的内存。 
 

排序使用内存(sort_buffer_size)
MySQL 用此内存区域进行排序操作（filesort），完成客户端的排序请求。当我们设置的排序区缓存大小无法满足排序实际所需内存的时候，MySQL 会将数据写入磁盘文件来完成排序。由于磁盘和内存的读写性能完全不在一个数量级，所以sort_buffer_size参数对排序操作的性能影响绝对不可小视。经常使用索引来完成排序操作。

 

Join操作使用内存(join_buffer_size)
应用程序经常会出现一些两表（或多表）Join的操作需求，MySQL在完成某些 Join 需求的时候（all/index join），为了减少参与Join的“被驱动表”的读取次数以提高性能，需要使用到 Join Buffer 来协助完成 Join操作。当 Join Buffer 太小，MySQL 不会将该 Buffer 存入磁盘文件，而是先将Join Buffer中的结果集与需要 Join 的表进行 Join 操作，然后清空 Join Buffer 中的数据，继续将剩余的结果集写入此 Buffer 中，如此往复。这势必会造成被驱动表需要被多次读取，成倍增加 IO 访问，降低效率。 所以连表时小表驱动大表。
 

顺序读取数据缓冲区使用内存(read_buffer_size)
这部分内存主要用于当需要顺序读取数据的时候，如无法使用索引的情况下的全表扫描，全索引扫描等。在这种时候，MySQL 按照数据的存储顺序依次读取数据块，每次读取的数据快首先会暂存在read_buffer_size中，当 buffer 空间被写满或者全部数据读取结束后，再将buffer中的数据返回给上层调用者，以提高效率。 
 

随机读取数据缓冲区使用内存(read_rnd_buffer_size)
和顺序读取相对应，当 MySQL 进行非顺序读取（随机读取）数据块的时候，会利用这个缓冲区暂存读取的数据。如根据索引信息读取表数据，根据排序后的结果集与表进行Join等等。总的来说，就是当数据块的读取需要满足一定的顺序的情况下，MySQL 就需要产生随机读取，进而使用到 read_rnd_buffer_size 参数所设置的内存缓冲区。 

 

连接信息及返回客户端前结果集暂存使用内存(net_buffer_size)
这部分用来存放客户端连接线程的连接信息和返回客户端的结果集。当 MySQL 开始产生可以返回的结果集，会在通过网络返回给客户端请求线程之前，会先暂存在通过 net_buffer_size 所设置的缓冲区中，等满足一定大小的时候才开始向客户端发送，以提高网络传输效率。不过，net_buffer_size 参数所设置的仅仅只是该缓存区的初始化大小，MySQL 会根据实际需要自行申请更多的内存以满足需求，但最大不会超过 max_allowed_packet 参数大小。 
 

批量插入暂存使用内存(bulk_insert_buffer_size)
当我们使用如 insert … values(…),(…),(…)… 的方式进行批量插入的时候，MySQL 会先将提交的数据放如一个缓存空间中，当该缓存空间被写满或者提交完所有数据之后，MySQL 才会一次性将该缓存空间中的数据写入数据库并清空缓存。此外，当我们进行 LOAD DATA INFILE 操作来将文本文件中的数据 Load 进数据库的时候，同样会使用到此缓冲区。 
 

临时表使用内存(tmp_table_size)
当我们进行一些特殊操作如需要使用临时表才能完成的 Order By，Group By 等等，MySQL 可能需要使用到临时表。当我们的临时表较小（小于 tmp_table_size 参数所设置的大小）的时候，MySQL 会将临时表创建成内存临时表，只有当 tmp_table_size 所设置的大小无法装下整个临时表的时候，MySQL 才会将该表创建成 MyISAM 存储引擎的表存放在磁盘上。不过，当另一个系统参数 max_heap_table_size 的大小还小于 tmp_table_size 的时候，MySQL 将使用 max_heap_table_size 参数所设置大小作为最大的内存临时表大小，而忽略 tmp_table_size 所设置的值。而且 tmp_table_size 参数从 MySQL 5.1.2 才开始有，之前一直使用 max_heap_table_size。 

innodb_buffer_pool_size
 用于缓存 索引 和 数据的内存大小, 这个当然是越多越好, 数据读写在内存中非常快, 减少了对磁盘的读写。 当数据提交或满足检查点条件后才一次性将内存数据刷新到磁盘中。然而内存还有操作系统或数据库其他进程使用, 一般设置 buffer pool 大小为总内存的  3/4 至 4/5。 若设置不当, 内存使用可能浪费或者使用过多。 对于繁忙的服务器, buffer pool 将划分为多个实例以提高系统并发性, 减少线程间读写缓存的争用。buffer pool 的大小首先受 innodb_buffer_pool_instances 影响, 当然影响较小。

innodb_buffer_pool_instances
buffer pool 被划分为多个缓存实例的数量, 为固定值,不动态变更。当较多数据加载到内存时, 使用多缓存实例能减少缓存争用情况。当 innodb_buffer_pool_size 大于 1GB 时, innodb_buffer_pool_instances 默认为 8。如有更多buffer pool, 平均每个instances 至少1GB。

innodb_buffer_pool_chunk_size
innodb_buffer_pool_chunk_size 默认 128MB (更改不需重启),增加单位为 1MB 。 
innodb_buffer_pool_chunk_size 的最大值估算如下：
MAX(innodb_buffer_pool_chunk_size) = innodb_buffer_pool_size / innodb_buffer_pool_instances

假设系统内存 = 128 GB, buffer pool 大小预计100GB(128GB*80%)
innodb_buffer_pool_instances = 8 #默认值,或者逻辑CPU数量
innodb_buffer_pool_chunk_size = 128MB #默认值
innodb_buffer_pool_size = 100 GB # N*8*128MG = N GB ,N 刚好为正整数。设 N=100使得 buffer pool 为总内存的 3/4 至 4/5。

innodb_page_size
innodb_page_size 默认 16kb, 数据存储页, 应与操作系统块大小一致(同 innodb_log_write_ahead_size)。 对于 SSD 更小的页可能更好。innodb_page_size 为32k and 64k 时, 行长度最大为 16000 bytes, 且不支持 ROW_FORMAT=COMPRESSED。

一个 innodb_buffer_pool_chunk_size 中包含的页数量取决于 innodb_page_size。

默认地： chunk可存储的页数量= innodb_buffer_pool_chunk_size / innodb_page_size = 128*1024/16 = 8192