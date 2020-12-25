







/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383 -a 123456 -r 100 -i 1 info | grep used_memory_human:
# redis外部命令查看info信息
# -a指定密码，-h指定主机，-p指定端口，-r运行这个命令多少次，-i运行这个命令的间隔，

/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383  config get "maxmemory"
/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383  config get "maxmemory" | sed -n '2p'
# 查看配置文件中maxmemory的值，查看第二行

/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383 info | grep used_memory_rss: | awk -F ":" '{print $2}'
# 查看redis使用的物理内存,相除就可以计算出比例

 /usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383  set "aaa2d2df2" "bbb"
# 设置key value

 /usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383  get "aaa2d2df2"
# 查看key

/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383 keys "aaa2d2df2"     
/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383 exists "aaa2d2df2"
# 查看某个key是否存在

/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383  config get "*"
# 查看redis运行期间可以临时修改的参数

/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383  config set "maxmemory" "8000000000"
# 修改redis的最大支持内存

/usr/local/redis/bin/redis-cli -h 127.0.0.1 -p 26383 info | grep config_file
# 查看redis的配置文件在哪

select 0
select 3
select 15
# 默认进入redis时就是db 0，一般写入到redis都是写入到db 0

KEYS *
# redis查看当前当前库所有的key
# 在shell命令行下查看，要用转义符/data/mxw/tools/redis1/bin/redis-cli -p 6579 keys \*

CONFIG GET *
# 查看当前redis的配置信息

config set stop-writes-on-bgsave-error no
# 强制停止redis快照导致，redis运行用户没有权限写rdb文件或者磁盘空间满了，解决办法：


# 清redis缓存中所有数据
./redis-cli
# 进入
dbsize
# 默认显示当前db里面的key的数量
flushall
# Remove all keys from all databases

# 删除redis当前数据库中的所有Key
flushdb

# 删除redis所有数据库中的key
flushall


redis-cli -n 0 keys “account*” | xargs redis-cli -n 0 del
redis-cli -n 1 keys “*” | xargs redis-cli -n 0 del
# 批量删除多个key，前提是该类型的key可以用正则匹配出来
# -n 0是切换到db 0，删除db 0 里面所有的key

redis-cli keys “*” | xargs redis-cli del
# 默认的所有操作都是针对db 0 的，不论读写

keys *
# 返回满足给定pattern的所有key，*代表取出多有key ，xiaojun* ，代表xiaojun大头的keys

exists
# 确认一个key是否存在

exists name 
# 没有返回0，有返回1

del age
# 删除一个key

expire
# 设置一个key过期时间

expir name 10 
# 设置一个存在一个存在的键的过期时间

ttl name 
# 查看key的存活时间，-1表示过期

select 0
# 表示进入到0数据库 ，(进入redis的时候，默认是0数据库)

select 0
set age 30
get age
move age 1
# (0到15的值，表示将age移动到1数据库)
select 1
get age

persist
# 移除给定key的过期时间
expir age 300
ttl age
persist age
ttl age 
# 值为-1 表示取消了过期时间


randomkey 
# 随机返回key空间的一个key （就是随机返回一个存在的key）,可以随机取出一个值，然后删除该值，可能非常有用

rename 
# 重命名key  

rename set2 set200 
# 将key set2重命名为set200

type
# 返回值的类型 
type set2 
# （返回值none表示空，set是集合 ，zset有序集合）


二、服务器的相关命令
ping ：测试连接是否存活
echo : 在命令行打印一些内容
select ： 选择数据库。Redis的数据库编码从0到15， select 1
quit : 退出连接 ，或者用exit命令
dbsize : 返回当前数据库中key的数目
info ： 获取服务器的信息或统计
config get : 实时传储收到的请求 config get * (可以返回相关配置的参数值)
--------------------
flushdb : 删除当前选择数据库中的所有key
dbsize （显示当前选择数据库中key的数量）
flushdb
dbsize (结果为0)
-------------------
flushall ： 删除所有数据库中的所有key


# 手动持久化redis数据

SAVE 命令执行一个同步保存操作，将当前 Redis 实例的所有数据快照(snapshot)以 RDB 文件的形式保存到硬盘。 
一般来说，在生产环境很少执行 SAVE 操作，因为它会阻塞所有客户端，保存数据库的任务通常由 BGSAVE 命令异步地执行。然而，如果负责保存数据的后台子进程不幸出现问题时， SAVE 可以作为保存数据的最后手段来使用。

保存成功时返回 OK 。
redis> SAVE
OK

在后台异步(Asynchronously)保存当前数据库的数据到磁盘。
BGSAVE 命令执行之后立即返回 OK ，然后 Redis fork 出一个新子进程，原来的 Redis 进程(父进程)继续处理客户端请求，而子进程则负责将数据保存到磁盘，然后退出。
客户端可以通过 LASTSAVE 命令查看相关信息，判断 BGSAVE 命令是否执行成功。
redis> BGSAVE
Background saving started

1.基本用法
SET connections 10
GET connections => 10
DEL connections
2 特殊命令（INCR防止多client读写冲突）
INCR connections => 11
INCR connections => 12
INCR connections => 13
3 redis存储list数据
RPUSH puts the new value at the end of the list.
RPUSH friends "Alice"
RPUSH friends "Bob"
LPUSH puts the new value at the start of the list.
LPUSH friends "Sam"

LRANGE gives a subset of the list. It takes the index of the first element you want to retrieve as its first parameter and the index of the last element you want    to retrieve as its second parameter. A value of -1 for the second parameter means to retrieve elements until the end of the list.
LRANGE friends 0 -1 => 1) "Sam", 2) "Alice", 3) "Bob"
LRANGE friends 0 1 => 1) "Sam", 2) "Alice"
LRANGE friends 1 2 => 1) "Alice", 2) "Bob"
LLEN friends => 3（获取list长度）
LPOP friends => "Sam" （删除第list第一个参数）
RPOP friends => "Bob"（删除第list最后一个参数）

RPUSH redis:log 1
# 在list尾部追加一个value
 
LRANGE redis:log 0 0
# 取出list的第一个value
 
LPOP redis:log
# 删除list的第一个value
 
LRANGE redis:log 0 -1
# 显示所有list value

/opt/logstash/bin/logstash agent -f /etc/logstash2/conf.d -l /var/log/logstash2/logstash.log &

# # 以上是手动操作redis消息队列方法
 
redis set ( each element may only appear once)
redis set原来没有sort，后来新增带score的set支持ZRANGE
ZADD hackers 1953 "Richard Stallman"
5 redis hash ( perfect data type to represent objects)
HSET user:1000 name "John Smith"
HSET user:1000 email "john.smith@example.com"
HSET user:1000 password "s3cret"
HMSET user:1001 name "Mary Jones" password "hidden" email "mjones@example.com"

HGETALL user:1000
HGET user:1001 name => "Mary Jones"
数值类型原子操作
HSET user:1000 visits 10
HINCRBY user:1000 visits 1 => 11
HINCRBY user:1000 visits 10 => 21
HDEL user:1000 visits
HINCRBY user:1000 visits 1 => 1