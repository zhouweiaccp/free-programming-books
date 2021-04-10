


https://www.shangmayuan.com/a/280dd9fe6dc14cb29e68e52c.html
任何一个服务，若是仅仅是单机部署，那么性能老是有上限的，RabbitMQ 也不例外，当单台 RabbitMQ 服务处理消息的能力到达瓶颈时，能够经过集群来实现高可用和负载均衡。java
RabbitMQ 集群知多少

一般状况下，在集群中咱们把每个服务称之为一个节点，在 RabbitMQ 集群中，节点类型能够分为两种：node

    内存节点：元数据存放于内存中。为了重启后能同步数据，内存节点会将磁盘节点的地址存放于磁盘之中，除此以外，若是消息被持久化了也会存放于磁盘之中，由于内存节点读写速度快，通常客户端会链接内存节点。
    磁盘节点：元数据存放于磁盘中（默认节点类型），须要保证至少一个磁盘节点，不然一旦宕机，没法恢复数据，从而也就没法达到集群的高可用目的。

PS：元数据，指的是包括队列名字属性、交换机的类型名字属性、绑定信息、vhost等基础信息，不包括队列中的消息数据。nginx

RabbitMQ 中的集群主要有两种模式：普通集群模式和镜像队列模式。web
普通集群模式

在普通集群模式下，集群中各个节点之间只会相互同步元数据，也就是说，消息数据不会被同步。那么问题就来了，假如咱们链接到 A 节点，可是消息又存储在 B 节点又怎么办呢？服务器

不管是生产者仍是消费者，假如链接到的节点上没有存储队列数据，那么内部会将其转发到存储队列数据的节点上进行存储。虽说内部能够实现转发，可是由于消息仅仅只是存储在一个节点，那么假如这节点挂了，消息是否是就没有了？这个问题确实存在，因此这种普通集群模式并无达到高可用的目的。cookie
镜像队列模式

镜像队列模式下，节点之间不只仅会同步元数据，消息内容也会在镜像节点间同步，可用性更高。这种方案提高了可用性的同时，由于同步数据之间也会带来网络开销从而在必定程度上会影响到性能。网络
RabbitMQ 集群搭建

接下来让咱们一块儿尝试搭建一个 RabbitMQ 集群：app

    假如以前启动过单机版，那么先删除旧数据 rm -rf /var/lib/rabbitmq/mnesia 或者删除安装目录内的 var/lib/rabbitmq/mnesia，我本机是安装在安装目录下，因此执行的是命令 rm -rf /usr/local/rabbitmq_server-3.8.4/var/lib/rabbitmq/mnesia/。负载均衡

    接下来须要启动如下三个命令来启动三个不一样端口号的 RabbitMQ 服务，除了指定 RabbitMQ 服务端口以后还须要额外指定后台管理系统的端口，并且必须指定 node 名的前缀，由于集群中是以节点名来进行通讯的，因此节点名必须惟一，默认的节点名是 rabbit@hostname，下面的命令表示指定了前缀：分布式

RABBITMQ_NODE_PORT=5672 RABBITMQ_SERVER_START_ARGS="-rabbitmq_management listener [{port,15672}]" RABBITMQ_NODENAME=rabbit1 rabbitmq-server -detached
RABBITMQ_NODE_PORT=5673 RABBITMQ_SERVER_START_ARGS="-rabbitmq_management listener [{port,15673}]" RABBITMQ_NODENAME=rabbit2 rabbitmq-server -detached
RABBITMQ_NODE_PORT=5674 RABBITMQ_SERVER_START_ARGS="-rabbitmq_management listener [{port,15674}]" RABBITMQ_NODENAME=rabbit3 rabbitmq-server -detached

启动以后进入 /usr/local/rabbitmq_server-3.8.4/var/lib/rabbitmq/mnesia/ 目录查看，发现建立了 3 个节点信息：

在这里插入图片描述

另外经过 ps -ef | grep rabbit 也能够发现三个服务进程被启动。

    如今启动的三个服务彼此之间尚未联系，如今咱们须要以其中一个节点为主节点，而后其他两个节点须要加入主节点，造成一个集群服务，须要注意的是加入集群以前，须要重置节点信息，即不容许带有数据的节点加入集群。

//rabbit2 节点重置后加入集群
rabbitmqctl -n rabbit2 stop_app
rabbitmqctl -n rabbit2 reset
rabbitmqctl -n rabbit2 join_cluster --ram rabbit1@`hostname -s` //--ram 表示这是一个内存节点
rabbitmqctl -n rabbit2 start_app

rabbitmqctl -n rabbit3 stop_app
rabbitmqctl -n rabbit3 reset
rabbitmqctl -n rabbit3 join_cluster --disc rabbit1@`hostname -s` //--disc表示磁盘节点（默认也是磁盘节点）
rabbitmqctl -n rabbit3 start_app

    成功以后，执行命令 rabbitmqctl cluster_status 查询节点 rabbit1 的状态，能够看到下图所示，两个磁盘节点一个内存节点：

在这里插入图片描述

    须要注意的是，到这里启动的集群只是默认的普通集群，若是想要配置成镜像集群，则须要执行如下命令：

rabbitmqctl -n rabbit1 set_policy ha-all "^" '{"ha-mode":"all"}'

到这里 RabbitMQ 集群就算搭建完成了，不过须要注意的是，这里由于是单机版本，因此没有考虑 .erlang.cookie 文件保持一致。
基于 HAProxy + Keepalived 高可用集群

假如一个 RabbitMQ 集群中，有多个内存节点，咱们应该链接到哪个节点呢？这个选择的策略若是放在客户端作，那么会有很大的弊端，最严重的的就是每次扩展集群都要修改客户端代码，因此这种方式并非很可取，因此咱们在部署集群的时候就须要一个中间代理组件，这个组件要可以实现服务监控和转发，好比 Redis 中的 Sentinel（哨兵）集群模式，哨兵就能够监听 Redis 节点并实现故障转移。

在 RabbitMQ 集群中，经过 Keepalived 和 HAProxy 两个组件实现了集群的高可用性和负载均衡功能。
HAProxy

HAProxy 是一个开源的、高性能的负载均衡软件，一样能够做为负载均衡软件的还有 nginx，lvs 等。 HAproxy 支持 7 层负载均衡和 4 层负载均衡。
负载均衡

所谓的 7 层负载均衡和 4 层负载均衡针对的是 OSI 模型而言，以下图所示就是一个 OSI 通讯模型：

在这里插入图片描述

上图中看到，第 7 层对应了应用层，第 4 层对应了传输层。经常使用的负载均衡软件如 nginx 通常工做在第 7 层，lvs（Linux Virtual Server）通常工做在第 4 层。

    4 层负载：

4 层负载使用了 NAT （Network Address Translation）技术，即：网络地址转换。收到客户端请求时，能够经过修改数据包里的源 IP 和端口，而后把数据包转发到对应的目标服务器。4 层负载均衡只能根据报文中目标地址和源地址对请求进行转发，没法判断或者修改请求资源的具体类型。

    7 层负载：

根据客户端请求的资源路径，转发到不一样的目标服务器。
高可用 HAProxy

HAProxy 虽然实现了负载均衡，可是假如只是部署一个 HAProxy，那么其自己也存在宕机的风险。一旦 HAProxy 宕机，那么就会致使整个集群不可用，因此咱们也须要对 HAProxy 也实现集群，那么假如 HAProxy 也实现了集群，客户端应该链接哪一台服务呢？问题彷佛又回到了起点，陷入了无限循环中…
Keepalived

为了实现 HAProxy 的高可用，须要再引入一个 Keepalived 组件，Keepalived 组件主要有如下特性：

    具备负载功能，能够监控集群中的节点状态，若是集群中某一个节点宕机，能够实现故障转移。
    其自己也能够实现集群，可是只能有一个 master 节点。
    master 节点会对外提供一个虚拟 IP，应用端只须要链接这一个 IP 就好了。能够理解为集群中的 HAProxy 节点会同时争抢这个虚拟 IP，哪一个节点争抢到，就由哪一个节点来提供服务。

VRRP 协议

VRRP 协议即虚拟路由冗余协议（Virtual Router Redundancy Protocol）。Keepalived 中提供的虚拟 IP 机制就属于 VRRP，它是为了不路由器出现单点故障的一种容错协议。
总结

本文主要介绍了 RaabbitMQ 集群的相关知识，并对比了普通集群和镜像集群的区别，最后经过实践搭建了一个 RabbitMQ 集群，同时也介绍了普通的集群存在一些不足，能够结合 HAProxy 和 Keepalived 组件来实现真正的高可用分布式集群服务。