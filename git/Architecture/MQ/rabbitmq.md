
## 学习资源
- [RabbitMQ能为你做些什么](http://rabbitmq.mr-ping.com/description.html)
- [windows-常见问题](https://www.rabbitmq.com/windows-quirks.html)
- [RabbitMQ集群方案的原理](https://www.cnblogs.com/xishuai/p/rabbitmq-cluster.html)
- [clustering](https://www.rabbitmq.com/clustering.html)
- [消息队列RabbitMQ从入门安装到精通原理](https://www.jianshu.com/p/637192a049f1)  资料非常全部
- [非常强悍的 RabbitMQ 总结](https://www.jianshu.com/p/a1837c61d42f)
- [vipstone](https://www.cnblogs.com/vipstone/p/9295625.html) RabbitMQ系列（三）RabbitMQ交换器Exchange介绍与实践

### 集群脑裂问题
- [Login was refused using authentication mechanism PLAIN. For details see the](https://stackoverflow.com/questions/26811924/spring-amqp-rabbitmq-3-3-5-access-refused-login-was-refused-using-authentica)
rabbitmqctl add_user admin admin
 rabbitmqctl set_user_tags admin administrator
 rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"



## 安全和端口

SELinux和类似机制或许会通过绑定端口的方式阻止RabbitMQ。当这种情况发生时，RabbitMQ会启动失败。请确认以下的端口是可以被打开的：http://rabbitmq.mr-ping.com/installation/Installing_on_Debian_Ubuntu.html

    4369 (epmd), 25672 (Erlang distribution)
    5672, 5671 (启用了 或者 未启用 TLS 的 AMQP 0-9-1)
    15672 (如果管理插件被启用)
    61613, 61614 (如果 STOMP 被启用)
    1883, 8883 (如果 MQTT 被启用)
    
    https://www.rabbitmq.com/clustering.html
    4369: epmd, a helper discovery daemon used by RabbitMQ nodes and CLI tools
    5672, 5671: used by AMQP 0-9-1 and 1.0 clients without and with TLS
    25672: used for inter-node and CLI tools communication (Erlang distribution server port) and is allocated from a dynamic range (limited to a single port by default, computed as AMQP port + 20000). Unless external connections on these ports are really necessary (e.g. the cluster uses federation or CLI tools are used on machines outside the subnet), these ports should not be publicly exposed. See networking guide for details.
    35672-35682: used by CLI tools (Erlang distribution client ports) for communication with nodes and is allocated from a dynamic range (computed as server distribution port + 10000 through server distribution port + 10010). See networking guide for details.
    15672: HTTP API clients, management UI and rabbitmqadmin (only if the management plugin is enabled)
    61613, 61614: STOMP clients without and with TLS (only if the STOMP plugin is enabled)
    1883, 8883: MQTT clients without and with TLS, if the MQTT plugin is enabled
    15674: STOMP-over-WebSockets clients (only if the Web STOMP plugin is enabled)
    15675: MQTT-over-WebSockets clients (only if the Web MQTT plugin is enabled)
    15692: Prometheus metrics (only if the Prometheus plugin is enabled)


## 存储位置
    Generic UNIX - $RABBITMQ_HOME/etc/rabbitmq/
    Debian - /etc/rabbitmq/
    RPM - /etc/rabbitmq/
    Mac OS X (Homebrew) - ${install_prefix}/etc/rabbitmq/, the Homebrew prefix is usually /usr/local
    Windows - %APPDATA%\RabbitMQ\
RABBITMQ_BASE	%APPDATA%\RabbitMQ
RABBITMQ_CONFIG_FILE	%RABBITMQ_BASE%\rabbitmq
RABBITMQ_MNESIA_BASE	%RABBITMQ_BASE%\db
RABBITMQ_MNESIA_DIR	%RABBITMQ_MNESIA_BASE%\%RABBITMQ_NODENAME%
RABBITMQ_LOG_BASE	%RABBITMQ_BASE%\log
RABBITMQ_LOGS	%RABBITMQ_LOG_BASE%\%RABBITMQ_NODENAME%.log
RABBITMQ_SASL_LOGS	%RABBITMQ_LOG_BASE%\%RABBITMQ_NODENAME%-sasl.log
RABBITMQ_PLUGINS_DIR	Installation-directory/plugins
RABBITMQ_PLUGINS_EXPAND_DIR	%RABBITMQ_MNESIA_BASE%\%RABBITMQ_NODENAME%-plugins-expand
RABBITMQ_ENABLED_PLUGINS_FILE	%RABBITMQ_BASE%\enabled_plugins

- [Windows系统默认位置](https://blog.csdn.net/u011973222/article/details/86614312)
- [RabbitMQ Environment Variables](http://previous.rabbitmq.com/v3_6_x/configure.html#means-of-configuration)
 ## 集群
 节点增加：
1. rabbitmq-server -detached   --- .erlang.cooike的权限，400 属主rabbitmq
2. rabbitmqctl stop_app
3. rabbitmqctl join_cluster --ram rabbit@rabbitmq1
4. rabbitmqctl start_app
5. rabbitmqctl  cluster_status

 

节点删除
1.  rabbitmq-server -detached
以上为基础，正常运行的mq节点直接进行2、3两步；4可省略或更改为rabbitmqctl stop
2. rabbitmqctl stop_app
3. rabbitmqctl reset 
4. rabbitmqctl start_app

 

## 如何将rabbitmq集群中的某个节点移除.
首先将要移除的节点停机.
root@rabbitmq-03:~# rabbitmqctl stop
Stopping and halting node 'rabbit@rabbitmq-03' ...
然后执行如下操作.
在主节点,也就是发起进群的主机上进行节点的移除.
root@rabbitmq-01:/var/lib/rabbitmq# rabbitmqctl  -n rabbit@rabbitmq-01 forget_cluster_node rabbit@rabbitmq-03
Removing node 'rabbit@rabbitmq-03' from cluster ...
 
下面是范例
rabbitmqctl -n hare @ mcnulty forget_cluster_node rabbit @ stringer
 
然后查看集群状态信息.
 
root@rabbitmq-01:/var/lib/rabbitmq# rabbitmqctl cluster_status
Cluster status of node 'rabbit@rabbitmq-01' ...
[{nodes,[{disc,['rabbit@rabbitmq-01','rabbit@rabbitmq-02']}]},
{running_nodes,['rabbit@rabbitmq-02','rabbit@rabbitmq-01']},
{cluster_name,<<"rabbit@rabbitmq-01">>},
{partitions,[]}]
 
发现rabbitmq3节点已经被移除.
- [](https://www.cnblogs.com/zhengchunyuan/p/11730832.html)
- [rabbitmq从集群中拆除节点并初始化](https://jpuyy.com/?p=8105)


node3 上删除 /var/lib/rabbitmq/mnesia 数据库下所有文件， 重启
之后 node3 初始化
rabbitmqctl add_user admin admin
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"


## 更改集群节点类型：
 rabbitmqctl stop_app
 rabbitmqctl change_cluster_node_type ram
 rabbitmqctl change_cluster_node_type disc
 rabbitmqctl start_app
 rabbitmqctl cluster_status

如果出现错误：
Error: unable to connect to node rabbit@manager1: nodedown
解决方式：
 /sbin/service rabbitmq-server stop
 /sbin/service rabbitmq-server start
 rabbitmqctl status



##  RabbitMQ Performance Testing Tool 性能测试工具
RabbitMQ Performance Testing Tool 介绍:
https://www.rabbitmq.com/java-tools.html


RabbitMQ Performance Testing Tool 下载:
https://github.com/rabbitmq/rabbitmq-perf-test/releases

解压文件(放到 RabbitMQ 安装目录下)
rabbitmq-perf-test-1.1.0.zip

测试（命令行执行）：
> cd D:\Program Files\RabbitMQ Server\rabbitmq-perf-test-1.1.0\bin
> runjava.bat com.rabbitmq.perf.PerfTest -a

更多帮助：
> runjava com.rabbitmq.perf.PerfTest --help
usage: <program>
 -?,--help                         show usage
 -A,--multiAckEvery <arg>          multi ack every
 -a,--autoack                      auto ack
 -b,--heartbeat <arg>              heartbeat interval
 -C,--pmessages <arg>              producer message count
 -c,--confirm <arg>                max unconfirmed publishes
 -D,--cmessages <arg>              consumer message count
 -d,--id <arg>                     test ID
 -e,--exchange <arg>               exchange name
 -f,--flag <arg>                   message flag
 -h,--uri <arg>                    connection URI
 -i,--interval <arg>               sampling interval in seconds
 -K,--randomRoutingKey             use random routing key per message
 -k,--routingKey <arg>             routing key
 -M,--framemax <arg>               frame max
 -m,--ptxsize <arg>                producer tx size
 -n,--ctxsize <arg>                consumer tx size
 -p,--predeclared                  allow use of predeclared objects
 -Q,--globalQos <arg>              channel prefetch count
 -q,--qos <arg>                    consumer prefetch count
 -R,--consumerRate <arg>           consumer rate limit
 -r,--rate <arg>                   producer rate limit
 -s,--size <arg>                   message size in bytes
 -t,--type <arg>                   exchange type
 -u,--queue <arg>                  queue name
 -X,--producerChannelCount <arg>   channels per producer
 -x,--producers <arg>              producer count
 -Y,--consumerChannelCount <arg>   channels per consumer
 -y,--consumers <arg>              consumer count
 -z,--time <arg>                   run duration in seconds (unlimited by default)

示例：100个生产者；100个消费者；echange名称为testex；转发类型为fanout；queue名称为testque；bingding为kk01;
runjava.bat com.rabbitmq.perf.PerfTest -x100 -y100 -e"testex" -t"fanout" -u"testque" -k"kk01"


## 界面
Ready：待消费的消息总数。
Unacked：待应答（待确认）的消息总数。
Total：总数 Ready+Unacked。


## RabbitMQ队列中大量unacked消息的问题定位
https://www.jianshu.com/p/5413766fa9c5
最近在使用RabbitMQ时发现总有一些消息队列中存在大量的处于unacked状态的消息，一般来说，如果队列中ready状态的消息数比较多，可以认为是消费者的处理能力不足，可以通过增加消费者来解决，而unacked消息存在基本是有以下两点原因：

消费者取走消息后没有及时做消息确认，对于开启手动确认机制的，不进行ack则消息会一直以unacked状态留在队列中。
消费者处理能力不足。生产者投放消息的速度较快，当消费者按照prefetch_count设置的值取走相应数量的消息时，这些消息都会暂时处于unacked状态。
我司目前对RabbitMQ的使用是基于Celery的，Celery对消息确认采用的是early ack，即在消费者执行task之前，就已经向RabbitMQ发送确认消息了，哪怕task产生异常也不会受到任何影响。所以队列中unacked的消息不是自定义task异常产生的。若是消费者处理能力不足，则ready状态的消息应该会有一定的堆积，但是也没有观察到这点，所以不能判定为消费者能力的限制。

有没有可能是消费者挂掉导致的呢？消费者挂掉后，unacked的消息会变成ready状态的消息重新放在队列中，待下次消费者启动后可以直接读取，所以也不会是这个原因。

通过以上分析，并没有发现消费者有何问题，只能尝试从生产者来分析了。Celery有两种生产消息的方式，delay和apply_async。

delay直接向队列中投递消息，消费者立时可取，任务立即可执行
apply_async投递的定时消息，消费者立时可取，任务定时执行
任务定时执行是Celery的功能，原理是amqp消息的header中存放了任务的执行时间，Celery会根据这个时间来执行任务，哪怕消费者挂掉了，当再次启动时，定时任务仍然能够正常执行。

但是，定时任务的ack消息并不是在消费者取走消息后就发送的，只有在任务真正执行前才会发送。这也是为什么clock_queue中存在这么多unacked消息的原因，不是真的除了什么问题，而是有这么多任务等待被执行呢