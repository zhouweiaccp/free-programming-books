一般来说，如果只是为了学习RabbitMQ或者验证业务工程的正确性那么在本地环境或者测试环境上使用其单实例部署就可以了，但是出于MQ中间件本身的可靠性、并发性、吞吐量和消息堆积能力等问题的考虑，在生产环境上一般都会考虑使用RabbitMQ的集群方案。


对于RabbitMQ这么成熟的消息队列产品来说，搭建它并不难并且也有不少童鞋写过如何搭建RabbitMQ消息队列集群的博文，但可能仍然有童鞋并不了解其背后的原理，这会导致其遇到性能问题时无法对集群进行进一步的调优。


本篇主要介绍RabbitMQ集群方案的原理，如何搭建具备负载均衡能力的中小规模RabbitMQ集群，并最后给出生产环境构建一个能够具备高可用、高可靠和高吞吐量的中小规模RabbitMQ集群设计方案。


一、RabbitMQ集群方案的原理


RabbitMQ这款消息队列中间件产品本身是基于Erlang编写，Erlang语言天生具备分布式特性（通过同步Erlang集群各节点的magic cookie来实现）。


因此，RabbitMQ天然支持Clustering。这使得RabbitMQ本身不需要像ActiveMQ、Kafka那样通过ZooKeeper分别来实现HA方案和保存集群的元数据。集群是保证可靠性的一种方式，同时可以通过水平扩展以达到增加消息吞吐量能力的目的。下面先来看下RabbitMQ集群的整体方案：


图片


上面图中采用三个节点组成了一个RabbitMQ的集群，Exchange A（交换器，对于RabbitMQ基础概念不太明白的童鞋可以看下基础概念）的元数据信息在所有节点上是一致的，而Queue（存放消息的队列）的完整数据则只会存在于它所创建的那个节点上。，其他节点只知道这个queue的metadata信息和一个指向queue的owner node的指针。


（1）RabbitMQ集群元数据的同步


RabbitMQ集群会始终同步四种类型的内部元数据（类似索引）： a.队列元数据：队列名称和它的属性； b.交换器元数据：交换器名称、类型和属性； c.绑定元数据：一张简单的表格展示了如何将消息路由到队列； d.vhost元数据：为vhost内的队列、交换器和绑定提供命名空间和安全属性； 因此，当用户访问其中任何一个RabbitMQ节点时，通过rabbitmqctl查询到的queue／user／exchange/vhost等信息都是相同的。


（2）为何RabbitMQ集群仅采用元数据同步的方式


我想肯定有不少同学会问，想要实现HA方案，那将RabbitMQ集群中的所有Queue的完整数据在所有节点上都保存一份不就可以了么？（可以类似MySQL的主主模式嘛）这样子，任何一个节点出现故障或者宕机不可用时，那么使用者的客户端只要能连接至其他节点能够照常完成消息的发布和订阅嘛。 


我想RabbitMQ的作者这么设计主要还是基于集群本身的性能和存储空间上来考虑。

    第一，存储空间，如果每个集群节点都拥有所有Queue的完全数据拷贝，那么每个节点的存储空间会非常大，集群的消息积压能力会非常弱（无法通过集群节点的扩容提高消息积压能力）；


    第二，性能，消息的发布者需要将消息复制到每一个集群节点，对于持久化消息，网络和磁盘同步复制的开销都会明显增加。


（3）RabbitMQ集群发送/订阅消息的基本原理


RabbitMQ集群的工作原理图如下：


图片

场景1：客户端直接连接队列所在节点


如果有一个消息生产者或者消息消费者通过amqp-client的客户端连接至节点1进行消息的发布或者订阅，那么此时的集群中的消息收发只与节点1相关，这个没有任何问题；如果客户端相连的是节点2或者节点3（队列1数据不在该节点上），那么情况又会是怎么样呢？


场景2：客户端连接的是非队列数据所在节点


如果消息生产者所连接的是节点2或者节点3，此时队列1的完整数据不在该两个节点上，那么在发送消息过程中这两个节点主要起了一个路由转发作用，根据这两个节点上的元数据（也就是上文提到的：指向queue的owner node的指针）转发至节点1上，最终发送的消息还是会存储至节点1的队列1上。 


同样，如果消息消费者所连接的节点2或者节点3，那这两个节点也会作为路由节点起到转发作用，将会从节点1的队列1中拉取消息进行消费。


二、RabbitMQ集群的搭建


（1）搭建RabbitMQ集群所需要安装的组件


在搭建RabbitMQ集群之前有必要在每台虚拟机上安装如下的组件包，分别如下：

    a.Jdk 1.8

    b.Erlang运行时环境，这里用的是otpsrc19.3.tar.gz (200MB+)

    c.RabbitMq的Server组件，这里用的rabbitmq-server-generic-unix-3.6.10.tar.gz


关于如何安装上述三个组件的具体步骤，已经有不少博文对此进行了非常详细的描述，那么本文就不再赘述了。有需要的同学可以具体参考这些步骤来完成安装。


（2）搭建10节点组成的RabbitMQ集群


该节中主要展示的是集群搭建，需要确保每台机器上正确安装了上述三种组件，并且每台虚拟机上的RabbitMQ的实例能够正常启动起来。 


a.编辑每台RabbitMQ的cookie文件，以确保各个节点的cookie文件使用的是同一个值,可以scp其中一台机器上的cookie至其他各个节点，cookie的默认路径为/var/lib/rabbitmq/.erlang.cookie或者$HOME/.erlang.cookie，节点之间通过cookie确定相互是否可通信。 


b.配置各节点的hosts文件( vim /etc/hosts)

    xxx.xxx.xxx.xxx rmq-broker-test-1

    xxx.xxx.xxx.xxx rmq-broker-test-2

    xxx.xxx.xxx.xxx rmq-broker-test-3

    ......

    xxx.xxx.xxx.xxx rmq-broker-test-10


c.逐个节点启动RabbitMQ服务

    rabbitmq-server -detached


d.查看各个节点和集群的工作运行状态

    rabbitmqctl status, rabbitmqctl cluster_status


e.以rmq-broker-test-1为主节点，在rmq-broker-test-2上：


    rabbitmqctl stop_app 

    rabbitmqctl reset 

    rabbitmqctl join_cluster rabbit@rmq-broker-test-2 

    rabbitmqctl start_app 


在其余的节点上的操作步骤与rmq-broker-test-2虚拟机上的一样。 


f.在RabbitMQ集群中的节点只有两种类型：内存节点/磁盘节点，单节点系统只运行磁盘类型的节点。而在集群中，可以选择配置部分节点为内存节点。


内存节点将所有的队列，交换器，绑定关系，用户，权限，和vhost的元数据信息保存在内存中。而磁盘节点将这些信息保存在磁盘中，但是内存节点的性能更高，为了保证集群的高可用性，必须保证集群中有两个以上的磁盘节点，来保证当有一个磁盘节点崩溃了，集群还能对外提供访问服务。


在上面的操作中，可以通过如下的方式，设置新加入的节点为内存节点还是磁盘节点：

    #加入时候设置节点为内存节点（默认加入的为磁盘节点）

    [root@mq-testvm1 ~]# rabbitmqctl join_cluster rabbit@rmq-broker-test-1 --ram

    #也通过下面方式修改的节点的类型

    [root@mq-testvm1 ~]# rabbitmqctl changeclusternode_type disc | ram


g.最后可以通过“rabbitmqctl cluster_status”的方式来查看集群的状态，上面搭建的10个节点的RabbitMQ集群状态。


（3个节点为磁盘节点，7个节点为内存节点）如下：

    Cluster status of node 'rabbit@rmq-broker-test-1'

    [{nodes,[{disc,['rabbit@rmq-broker-test-1','rabbit@rmq-broker-test-2',

                    'rabbit@rmq-broker-test-3']},

             {ram,['rabbit@rmq-broker-test-9','rabbit@rmq-broker-test-8',

                   'rabbit@rmq-broker-test-7','rabbit@rmq-broker-test-6',

                   'rabbit@rmq-broker-test-5','rabbit@rmq-broker-test-4',

                   'rabbit@rmq-broker-test-10']}]},

     {running_nodes,['rabbit@rmq-broker-test-10','rabbit@rmq-broker-test-5',

                     'rabbit@rmq-broker-test-9','rabbit@rmq-broker-test-2',

                     'rabbit@rmq-broker-test-8','rabbit@rmq-broker-test-7',

                     'rabbit@rmq-broker-test-6','rabbit@rmq-broker-test-3',

                     'rabbit@rmq-broker-test-4','rabbit@rmq-broker-test-1']},

     {cluster_name,<<"rabbit@mq-testvm1">>},

     {partitions,[]},

     {alarms,[{'rabbit@rmq-broker-test-10',[]},

              {'rabbit@rmq-broker-test-5',[]},

              {'rabbit@rmq-broker-test-9',[]},

              {'rabbit@rmq-broker-test-2',[]},

              {'rabbit@rmq-broker-test-8',[]},

              {'rabbit@rmq-broker-test-7',[]},

              {'rabbit@rmq-broker-test-6',[]},

              {'rabbit@rmq-broker-test-3',[]},

              {'rabbit@rmq-broker-test-4',[]},

              {'rabbit@rmq-broker-test-1',[]}]}]



（3）配置HAProxy


HAProxy提供高可用性、负载均衡以及基于TCP和HTTP应用的代理，支持虚拟主机，它是免费、快速并且可靠的一种解决方案。根据官方数据，其最高极限支持10G的并发。HAProxy支持从4层至7层的网络交换，即覆盖所有的TCP协议。就是说，Haproxy 甚至还支持 Mysql 的均衡负载。


为了实现RabbitMQ集群的软负载均衡，这里可以选择HAProxy。 关于HAProxy如何安装的文章之前也有很多同学写过，这里就不再赘述了，有需要的同学可以参考下网上的做法。这里主要说下安装完HAProxy组件后的具体配置。 HAProxy使用单一配置文件来定义所有属性，包括从前端IP到后端服务器。下面展示了用于7个RabbitMQ节点组成集群的负载均衡配置（另外3个磁盘节点用于保存集群的配置和元数据，不做负载）。同时，HAProxy运行在另外一台机器上。


HAProxy的具体配置如下：

    #全局配置

    global

            #日志输出配置，所有日志都记录在本机，通过local0输出

            log 127.0.0.1 local0 info

            #最大连接数

            maxconn 4096

            #改变当前的工作目录

            chroot /apps/svr/haproxy

            #以指定的UID运行haproxy进程

            uid 99

            #以指定的GID运行haproxy进程

            gid 99

            #以守护进程方式运行haproxy #debug #quiet

            daemon

            #debug

            #当前进程pid文件

            pidfile /apps/svr/haproxy/haproxy.pid

    #默认配置

    defaults

            #应用全局的日志配置

            log global

            #默认的模式mode{tcp|http|health}

            #tcp是4层，http是7层，health只返回OK

            mode tcp

            #日志类别tcplog

            option tcplog

            #不记录健康检查日志信息

            option dontlognull

            #3次失败则认为服务不可用

            retries 3

            #每个进程可用的最大连接数

            maxconn 2000

            #连接超时

            timeout connect 5s

            #客户端超时

            timeout client 120s

            #服务端超时

            timeout server 120s

            maxconn 2000

            #连接超时

            timeout connect 5s

            #客户端超时

            timeout client 120s

            #服务端超时

            timeout server 120s

    #绑定配置

    listen rabbitmq_cluster

            bind 0.0.0.0:5672

            #配置TCP模式

            mode tcp

            #加权轮询

            balance roundrobin

            #RabbitMQ集群节点配置,其中ip1~ip7为RabbitMQ集群节点ip地址

            server rmq_node1 ip1:5672 check inter 5000 rise 2 fall 3 weight 1

            server rmq_node2 ip2:5672 check inter 5000 rise 2 fall 3 weight 1

            server rmq_node3 ip3:5672 check inter 5000 rise 2 fall 3 weight 1

            server rmq_node4 ip4:5672 check inter 5000 rise 2 fall 3 weight 1

            server rmq_node5 ip5:5672 check inter 5000 rise 2 fall 3 weight 1

            server rmq_node6 ip6:5672 check inter 5000 rise 2 fall 3 weight 1

            server rmq_node7 ip7:5672 check inter 5000 rise 2 fall 3 weight 1

    #haproxy监控页面地址

    listen monitor

            bind 0.0.0.0:8100

            mode http

            option httplog

            stats enable

            stats uri /stats

            stats refresh 5s


在上面的配置中“listen rabbitmqcluster bind 0.0.0.0：5671”这里定义了客户端连接IP地址和端口号。这里配置的负载均衡算法是roundrobin—加权轮询。与配置RabbitMQ集群负载均衡最为相关的是“ server rmqnode1 ip1:5672 check inter 5000 rise 2 fall 3 weight 1”这种，它标识并且定义了后端RabbitMQ的服务。


主要含义如下:

(a)“server”部分：定义HAProxy内RabbitMQ服务的标识； 

(b)“ip1:5672”部分：标识了后端RabbitMQ的服务地址； 

(c)“check inter”部分：表示每隔多少毫秒检查RabbitMQ服务是否可用； (d)“rise”部分：表示RabbitMQ服务在发生故障之后，需要多少次健康检查才能被再次确认可用； 

(e)“fall”部分：表示需要经历多少次失败的健康检查之后，HAProxy才会停止使用此RabbitMQ服务。


    #启用HAProxy服务

    [root@mq-testvm12 conf]# haproxy -f haproxy.cfg



启动后，即可看到如下的HAproxy的界面图：图片

（4）RabbitMQ的集群架构设计图


经过上面的RabbitMQ10个节点集群搭建和HAProxy软弹性负载均衡配置后即可组建一个中小规模的RabbitMQ集群了，然而为了能够在实际的生产环境使用还需要根据实际的业务需求对集群中的各个实例进行一些性能参数指标的监控，从性能、吞吐量和消息堆积能力等角度考虑，可以选择Kafka来作为RabbitMQ集群的监控队列使用。


因此，这里先给出了一个中小规模RabbitMQ集群架构设计图：


图片


对于消息的生产和消费者可以通过HAProxy的软负载将请求分发至RabbitMQ集群中的Node1～Node7节点，其中Node8～Node10的三个节点作为磁盘节点保存集群元数据和配置信息。鉴于篇幅原因这里就不在对监控部分进行详细的描述的，会在后续篇幅中对如何使用RabbitMQ的HTTP API接口进行监控数据统计进行详细阐述。


三、总结


本文主要详细介绍了RabbitMQ集群的工作原理和如何搭建一个具备负载均衡能力的中小规模RabbitMQ集群的方法，并最后给出了RabbitMQ集群的架构设计图。限于笔者的才疏学浅，对本文内容可能还有理解不到位的地方，如有阐述不合理之处还望留言一起探讨。

参考资料：

    消息中间件—RabbitMQ（集群原理与搭建篇)（推荐）
    RabbitMQ两种集群模式配置管理（五）
    http://blog.51cto.com/zengestudy/1885054
    http://www.cnblogs.com/Richard-xie/p/4201994.html
