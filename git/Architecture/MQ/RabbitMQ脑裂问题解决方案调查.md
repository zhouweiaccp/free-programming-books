RabbitMQ GUI上显示

Network partition detected
Mnesia reports that this RabbitMQ cluster has experienced a network partition. There is a risk of losing data. Please read RabbitMQ documentation about network partitions and the possible solutions.

原因分析：

这是由于网络问题导致集群出现了脑裂临时解决办法：

在 相对不怎么信任的分区里，对那个分区的节点实行 

   在出现问题的节点上执行:  sbin/rabbitmqctl stop_app 
   在出现问题的节点上执行:  sbin/rabbitmqctl start_app 

注意：mq集群不能采用kill -9 杀死进程，否则生产者和消费者不能及时识别mq的断连，会影响生产者和消费者正常的业务处理。 
Rabbitmq network partition的判定及恢复策略的选择

 
RabbitMQ Network Partitions问题具体分析和解决方案

Clustering and Network Partitions 
RabbitMQ clusters do not tolerate network partitions well. If you are thinking of clustering across a WAN, don’t. You should use federation or the shovel instead. 
However, sometimes accidents happen. This page documents how to detect network partitions, some of the bad effects that may happen during partitions, and how to recover from them. 
RabbitMQ stores information about queues, exchanges, bindings etc in Erlang’s distributed database, Mnesia. Many of the details of what happens around network partitions are related to Mnesia’s behaviour.

集群和网络分区 
RabbitMQ集群并不能很好的“忍受”网络分区。如果你想将RabbitMQ集群建立在广域网上，记住那是行不通的，除非你使用federation或者shovel等插件。

然而有时候会有一些意想不到的事情发生。本文主要讲述了RabbitMQ集群如何检测网络分区，发生网络分区带来的影响以及如何恢复。

RabbitMQ会将queues, exchanges, bindings等信息存储在Erlang的分布式数据库——Mnesia中，许多围绕网络分区的一些细节都和这个Mnesia的行为有关。

Detecting network partitions 
Mnesia will typically determine that a node is down if another node is unable to contact it for a minute or so (see the page on net_ticktime). If two nodes come back into contact, both having thought the other is down, Mnesia will determine that a partition has occurred. This will be written to the RabbitMQ log in a form like:

=ERROR REPORT==== 15-Oct-2012::18:02:30 ===
Mnesia(rabbit@smacmullen): ** ERROR ** mnesia_event got
    {inconsistent_database, running_partitioned_network, hare@smacmullen}

RabbitMQ nodes will record whether this event has ever occurred while the node is up, and expose this information through rabbitmqctl cluster_status and the management plugin. 
rabbitmqctl cluster_status will normally show an empty list for partitions:

# rabbitmqctl cluster_status
Cluster status of node rabbit@smacmullen ...
[{nodes,[{disc,[hare@smacmullen,rabbit@smacmullen]}]},
 {running_nodes,[rabbit@smacmullen,hare@smacmullen]},
 {partitions,[]}]
...done.

However, if a network partition has occurred then information about partitions will appear there:

# rabbitmqctl cluster_status
Cluster status of node rabbit@smacmullen ...
[{nodes,[{disc,[hare@smacmullen,rabbit@smacmullen]}]},
 {running_nodes,[rabbit@smacmullen,hare@smacmullen]},
 {partitions,[{rabbit@smacmullen,[hare@smacmullen]},
              {hare@smacmullen,[rabbit@smacmullen]}]}]
...done.

The management plugin API will return partition information for each node under partitions in /api/nodes. The management plugin UI will show a large red warning on the overview page if a partition has occurred.

检测网络分区 
如果另一个节点在一分钟（或者一个net_ticktime时间）内不能连接上一个节点，那么Mnesia通常任务这个节点已经挂了。就算之后两个节点连通（译者注：应该是指网络上的可连通），但是这两个节点都认为对方已经挂了，Mnesia此时认定发送了网络分区的情况。这些会被记录在RabbitMQ的日志中，如下所示：

=ERROR REPORT==== 15-Oct-2012::18:02:30 ===
Mnesia(rabbit@smacmullen): ** ERROR ** mnesia_event got
    {inconsistent_database, running_partitioned_network, hare@smacmullen}

当一个节点起来的时候，RabbitMQ会记录是否发生了网络分区，你可以通过rabbitmqctl cluster_status这个命令或者管理插件看到相关信息。正常情况下，通过rabbitmqctl cluster_status命令查看到的信息中partitions那一项是空的，就像这样：

# rabbitmqctl cluster_status
Cluster status of node rabbit@smacmullen ...
[{nodes,[{disc,[hare@smacmullen,rabbit@smacmullen]}]},
 {running_nodes,[rabbit@smacmullen,hare@smacmullen]},
 {partitions,[]}]
...done.

然而当网络分区发生时，会变成这样：

# rabbitmqctl cluster_status
Cluster status of node rabbit@smacmullen ...
[{nodes,[{disc,[hare@smacmullen,rabbit@smacmullen]}]},
 {running_nodes,[rabbit@smacmullen,hare@smacmullen]},
 {partitions,[{rabbit@smacmullen,[hare@smacmullen]},
              {hare@smacmullen,[rabbit@smacmullen]}]}]
...done.

通过管理插件的API（under partitions in /api/nodes）可以获取到在各个节点的分区信息.

通过Web UI可以在Overview这一页看到一个大的红色的告警窗口，就像这样： 
这里写图片描述

During a network partition 
While a network partition is in place, the two (or more!) sides of the cluster can evolve independently, with both sides thinking the other has crashed. Queues, bindings, exchanges can be created or deleted separately.Mirrored queues which are split across the partition will end up with one master on each side of the partition, again with both sides acting independently. Other undefined and weird behaviour may occur. 
It is important to understand that when network connectivity is restored, this state of affairs persists. The cluster will continue to act in this way until you take action to fix it.

网络分区期间 
当一个集群发生网络分区时，这个集群会分成两部分（或者更多），它们各自为政，互相都认为对方分区内的节点已经挂了， 包括queues, bindings, exchanges这些信息的创建和销毁都处于自身分区内，与其他分区无关。如果原集群中配置了镜像队列，而这个镜像队列又牵涉到两个（或者多个）网络分区的节点时，每一个网络分区中都会出现一个master节点（译者注：如果rabbitmq版本较新，分区节点个数充足，也会出现新的slave节点。），对于各个网络分区，此队列都是互相独立的。当然也会有一些其他未知的、怪异的事情发生。

当网络（这里只网络连通性，network connectivity）恢复时，网络分区的状态还是会保持，除非你采取了一些措施去解决他。

Partitions caused by suspend / resume 
While we refer to “network” partitions, really a partition is any case in which the different nodes of a cluster can have communication interrupted without any node failing. In addition to network failures, suspending and resuming an entire OS can also cause partitions when used against running cluster nodes - as the suspended node will not consider itself to have failed, or even stopped, but the other nodes in the cluster will consider it to have done so. 
While you could suspend a cluster node by running it on a laptop and closing the lid, the most common reason for this to happen is for a virtual machine to have been suspended by the hypervisor. While it’s fine to run RabbitMQ clusters in virtualised environments, you should make sure that VMs are not suspended while running. Note that some virtualisation features such as migration of a VM from one host to another will tend to involve the VM being suspended. 
Partitions caused by suspend and resume will tend to be asymmetrical - the suspended node will not necessarily see the other nodes as having gone down, but will be seen as down by the rest of the cluster. This has particular implications for pause_minority mode.

挂起/恢复导致的分区 
当我们涉及到“网络分区”时，当集群中的不同的节点发生交互失败中断(communication interrupted)等，但是又没有节点挂掉这种情况下，才是发生了分区。然而除了网络失败(network failures)原因，操作系统的挂起或者恢复也会导致集群内节点的网络分区。因为发生挂起的节点不会认为自身已经失败或者停止工作，但是集群内的其他节点会这么认为。

如果一个集群中的一个节点运行在一台笔记本上，然后你合上了笔记本，这样这个节点就挂起了。或者说一种更常见的现象，节点运行在某台虚拟机上，然后虚拟机的管理程序挂起了这个虚拟机节点，这样也可能发生挂起。

由于挂起/恢复导致的分区并不对称——挂起的节点将看不到其他节点是否消失，但是集群中剩余的节点可以观察到，这一点貌似暗示了pause_minority这种模式（下面会涉及到）。

Recovering from a network partition 
To recover from a network partition, first choose one partition which you trust the most. This partition will become the authority for the state of Mnesia to use; any changes which have occurred on other partitions will be lost. 
Stop all nodes in the other partitions, then start them all up again. When they rejoin the cluster they will restore state from the trusted partition. 
Finally, you should also restart all the nodes in the trusted partition to clear the warning. 
It may be simpler to stop the whole cluster and start it again; if so make sure that the first node you start is from the trusted partition.

从网络分区中恢复 
未来从网络分区中恢复，首先需要挑选一个信任的分区，这个分区才有决定Mnesia内容的权限，发生在其他分区的改变将不被记录到Mnesia中而直接丢弃。

停止（stop）其他分区的节点，然后启动(start)这些节点，之后重新将这些节点加入到当前信任的分区之中。

最后，你应该重启(restart)信任的分区中所有的节点，以去除告警。

你也可以简单的关闭整个集群的节点，然后再启动每一个节点，当然，你要确保你启动的第一个节点在你所信任的分区之中。

Automatically handling partitions 
RabbitMQ also offers three ways to deal with network partitions automatically: pause-minority mode, pause-if-all-down mode and autoheal mode. (The default behaviour is referred to as ignore mode). 
In pause-minority mode RabbitMQ will automatically pause cluster nodes which determine themselves to be in a minority (i.e. fewer or equal than half the total number of nodes) after seeing other nodes go down. It therefore chooses partition tolerance over availability from the CAP theorem. This ensures that in the event of a network partition, at most the nodes in a single partition will continue to run. The minority nodes will pause as soon as a partition starts, and will start again when the partition ends. 
In pause-if-all-down mode, RabbitMQ will automatically pause cluster nodes which cannot reach any of the listed nodes. In other words, all the listed nodes must be down for RabbitMQ to pause a cluster node. This is close to the pause-minority mode, however, it allows an administrator to decide which nodes to prefer, instead of relying on the context. For instance, if the cluster is made of two nodes in rack A and two nodes in rack B, and the link between racks is lost, pause-minority mode will pause all nodes. In pause-if-all-down mode, if the administrator listed the two nodes in rack A, only nodes in rack B will pause. Note that it is possible the listed nodes get split across both sides of a partition: in this situation, no node will pause. That is why there is an additional ignore/autoheal argument to indicate how to recover from the partition. 
In autoheal mode RabbitMQ will automatically decide on a winning partition if a partition is deemed to have occurred, and will restart all nodes that are not in the winning partition. Unlike pause_minority mode it therefore takes effect when a partition ends, rather than when one starts. 
The winning partition is the one which has the most clients connected (or if this produces a draw, the one with the most nodes; and if that still produces a draw then one of the partitions is chosen in an unspecified way). 
You can enable either mode by setting the configuration parameter cluster_partition_handling for therabbit application in your configuration file to: 
● pause_minority 
● {pause_if_all_down, [nodes], ignore | autoheal} 
● autoheal

自动处理分区 
RabbitMQ提供了三种方法自动的解决网络分区：pause-minority mode, pause-if-all-down mode以及autoheal mode。（默认的是ignore模式）

在pause-minority mode下，顾名思义，当发生网络分区时，集群中的节点在观察到某些节点“丢失”时，会自动检测其自身是否处于少数派（小于或者等于集群中一半的节点数），RabbitMQ会自动关闭这些节点的运作。根据CAP原理来说，这里保障了P，即分区耐受性（partition tolerance）。这样确保了在发生网络分区的情况下，大多数节点（当然这些节点在同一个分区中）可以继续运行。“少数派”中的节点在分区发生时会关闭，当分区结束时又会启动。

在pause-if-all-down mode下，RabbitMQ在集群中的节点不能和list中的任何节点交互时才会关闭集群的节点（{pause_if_all_down, [nodes], ignore | autoheal}，list即[nodes]中的节点）。也就是说，只有在list中所有的节点失败时才会关闭集群的节点。这个模式和pause-minority mode有点相似，但是，这个模式允许管理员的任命而挑选信任的节点，而不是根据上下文关系。举个案例，一个集群，有四个节点，2个节点在A机架上，另2个节点在B机架上，此时A机架和B机架的连接丢失，那么根据pause-minority mode所有的节点都将被关闭。

在autoheal mode下，当认为发生网络分区时，RabbitMQ会自动决定一个获胜（winning）的分区，然后重启不在这个分区中的节点。

一个获胜的分区（a winning partition）是指客户端连接最多的一个分区。（如果产生一个平局，即有两个（或多个）分区的客户端连接数一样多，那么节点数最多的一个分区就是a winning partition. 如果此时节点数也一样多，将会以一个未知的方式挑选winning partition.）

你可以通过在RabbitMQ配置文件中设置cluster_partition_handling参数使下面任何一种模式生效：

    pause_minority
    {pause_if_all_down, [nodes], ignore | autoheal}
    autoheal

Which mode should I pick? 
It’s important to understand that allowing RabbitMQ to deal with network partitions automatically does not make them less of a problem. Network partitions will always cause problems for RabbitMQ clusters; you just get some degree of choice over what kind of problems you get. As stated in the introduction, if you want to connect RabbitMQ clusters over generally unreliable links, you should use federation or the shovel. 
With that said, you might wish to pick a recovery mode as follows: 
● ignore - Your network really is reliable. All your nodes are in a rack, connected with a switch, and that switch is also the route to the outside world. You don’t want to run any risk of any of your cluster shutting down if any other part of it fails (or you have a two node cluster). 
● pause_minority - Your network is maybe less reliable. You have clustered across 3 AZs in EC2, and you assume that only one AZ will fail at once. In that scenario you want the remaining two AZs to continue working and the nodes from the failed AZ to rejoin automatically and without fuss when the AZ comes back. 
● autoheal - Your network may not be reliable. You are more concerned with continuity of service than with data integrity. You may have a two node cluster.

我该挑选那种模式？ 
有一点必须要清楚，允许RabbitMQ能够自动的处理网络分区并不一定会有正面的成效，也有能会带来更多的问题。网络分区会导致RabbitMQ集群产生众多的问题，你需要对你所遇到的问题作出一定的选择。就像本文开篇所说的，如果你置RabbitMQ集群于一个不可靠的网络环境下，你需要使用federation或者shovel插件。

你可能选择如下的恢复模式：

    ignore: 你的网络很可靠，所有的节点都在一个机架上，连接在同一个交换机上，这个交换机也连接在WAN上，你不需要冒险而关闭部分节点。（或者适合只有两个节点的集群。）
    pause_minority: 你的网络相对没有那么的可靠。比如你在EC2上建立了三个节点的集群，假设其中一个节点宕了，在这种策略下，剩余的两个节点还可以继续工作，失败的节点可以在恢复之后重新加入集群
    autoheal: 你的网络非常不可靠，你更关心服务的连续性而不是数据的完整性。适合有两个节点的集群。

More about pause-minority mode 
The Erlang VM on the paused nodes will continue running but the nodes will not listen on any ports or do any other work. They will check once per second to see if the rest of the cluster has reappeared, and start up again if it has. 
Note that nodes will not enter the paused state at startup, even if they are in a minority then. It is expected that any such minority at startup is due to the rest of the cluster not having been started yet. 
Also note that RabbitMQ will pause nodes which are not in a strict majority of the cluster - i.e. containing more than half of all nodes. It is therefore not a good idea to enable pause-minority mode on a cluster of two nodes since in the event of any network partition or node failure, both nodes will pause. However, pause_minoritymode is likely to be safer than ignore mode for clusters of more than two nodes, especially if the most likely form of network partition is that a single minority of nodes drops off the network. 
Finally, note that pause_minority mode will do nothing to defend against partitions caused by cluster nodes being suspended. This is because the suspended node will never see the rest of the cluster vanish, so will have no trigger to disconnect itself from the cluster.

有关pause-minority模式的更多信息 
关闭的RabbitMQ节点所在主机上的Erlang虚拟机还是在正常运行，但是此节点并不会监听任何端口也不会执行其他任务。这些节点每秒会检测一次剩下的集群节点是否会再次出现，如果出现，就启动自己继续运行。

注意上面所说的“关闭的RabbitMQ节点”并不会在启动时就进入关闭状态，即使它们在“少数派（minority）”。这些“少数派”可能在“剩余的集群节点”没有启动好之前就启动了。

同样需要注意的是RabbitMQ也会关闭不是严格意义上的“大多数（majority）”——数量超过集群的一半。因此在一个集群只有两个节点的时候并不适合采用pause-minority模式，因为由于其中任何一个节点失败而发生网络分区时，两个节点都会被关闭。然而如果集群中的节点个数远大于两个时，pause_minority模式比ignore模式更加的可靠，特别是网络分区通常是由于单个节点掉出网络。

最后，需要注意的是pause_minority模式将不会防止由于集群节点被挂起而导致的分区。这是因为挂起的节点将永远不会看到集群的其余部分的消失，因此将没有触发器将其从集群中断开。

https://www.cnblogs.com/liyongsan/p/9640361.html


2、解决办法：

原因是rabbitmq集群在配置时未设置出现网络分区处理策略，先要将集群恢复正常，再设置出现网络分区处理策略，步骤如下：
（1）首先需要挑选一个信任的分区，这个分区才有决定Mnesia内容的权限，发生在其他分区的改变将不被记录到Mnesia中而直接丢弃。
（2）停止（stop）其他分区的节点，然后启动(start)这些节点，之后重新将这些节点加入到当前信任的分区之中。

rabbitmqctl stop_app
rabbitmqctl start_app

    1
    2

（3）最后，你应该重启(restart)信任的分区中所有的节点，以去除告警。
你也可以简单的关闭整个集群的节点，然后再启动每一个节点，当然，你要确保你启动的第一个节点在你所信任的分区之中。
（4）设置出现网络分区处理策略，这里设置为autoheal，下面会详细说明其它策略
在/etc/rabbitmq下新建rabbitmq.conf，加入：

[
 {rabbit,
  [{tcp_listeners,[5672]},
   {cluster_partition_handling, autoheal}
]}
].
原文链接：https://blog.csdn.net/hhq163/article/details/92584790