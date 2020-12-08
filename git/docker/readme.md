## Swarm调度策略
Swarm在scheduler节点（leader节点）运行容器的时候，会根据指定的策略来计算最适合运行容器的节点，目前支持的策略有：spread, binpack, random.
1. Random
顾名思义，就是随机选择一个Node来运行容器，一般用作调试用，spread和binpack策略会根据各个节点可用的CPU, RAM以及正在运行的容器数量来计算应该运行容器的节点。

2. Spread
在同等条件下，Spread策略会选择运行容器最少的那台节点来运行新的容器，binpack策略会选择运行容器最集中的那台机器来运行新的节点。使用Spread策略会使得容器会均衡的分布在集群中的各个节点上运行，一旦一个节点挂掉了只会损失少部分的容器。

3. Binpack
Binpack策略最大化的避免容器碎片化，就是说binpack策略尽可能的把还未使用的节点留给需要更大空间的容器运行，尽可能的把容器运行在一个节点上面。

## Swarm Cluster模式的特性
1）批量创建服务
建立容器之前先创建一个overlay的网络，用来保证在不同主机上的容器网络互通的网络模式

2）强大的集群的容错性
当容器副本中的其中某一个或某几个节点宕机后，cluster会根据自己的服务注册发现机制，以及之前设定的值--replicas n，在集群中剩余的空闲节点上，重新拉起容器副本。整个副本迁移的过程无需人工干预，迁移后原本的集群的load balance依旧好使！不难看出，docker service其实不仅仅是批量启动服务这么简单，而是在集群中定义了一种状态。Cluster会持续检测服务的健康状态并维护集群的高可用性。

3）服务节点的可扩展性
Swarm Cluster不光只是提供了优秀的高可用性，同时也提供了节点弹性扩展或缩减的功能。当容器组想动态扩展时，只需通过scale参数即可复制出新的副本出来。仔细观察的话，可以发现所有扩展出来的容器副本都run在原先的节点下面，如果有需求想在每台节点上都run一个相同的副本，方法其实很简单，只需要在命令中将"--replicas n"更换成"--mode=global"即可！其中:
复制服务（--replicas n）将一系列复制任务分发至各节点当中，具体取决于您所需要的设置状态，例如“--replicas 3”。
全局服务（--mode=global）适用于集群内全部可用节点上的服务任务，例如“--mode global”。如果在 Swarm 集群中设有 7 台 Docker 节点，则全部节点之上都将存在对应容器。

4)  调度机制
所谓的调度其主要功能是cluster的server端去选择在哪个服务器节点上创建并启动一个容器实例的动作。它是由一个装箱算法和过滤器组合而成。每次通过过滤器（constraint）启动容器的时候，swarm cluster 都会调用调度机制筛选出匹配约束条件的服务器，并在这上面运行容器。

Swarm cluster的创建过程包含以下三个步骤                                                                      
1）发现Docker集群中的各个节点，收集节点状态、角色信息，并监视节点状态的变化
2）初始化内部调度（scheduler）模块
3）创建并启动API监听服务模块

一旦创建好这个cluster，就可以用命令docker service批量对集群内的容器进行操作，非常方便！

在启动容器后，docker 会根据当前每个swarm节点的负载判断，在负载最优的节点运行这个task任务，用"docker service ls" 和"docker service ps + taskID"
可以看到任务运行在哪个节点上。容器启动后，有时需要等待一段时间才能完成容器创建。


## 常见问题
- [客户端ip](https://github.com/banianhost/remux/blob/master/app/nginx.conf#L57)  https://github.com/moby/moby/issues/32575  http://fengyilin.iteye.com/blog/2401156





## 常用命令
apt-get update 
apt install net-tools # ifconfig  netstat
apt install iputils-ping # ping
apt-get install inetutils-ping

 1查找docker的进程号 ：
docker inspect -f '{{.State.Pid}}' 49b98b2fbad2
2. 查看连接： 
nsenter -t 1840 -n netstat |grep ESTABLISHED


ceontos 安装 [https://www.cnblogs.com/linnuo/p/7159268.html]
yum install http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
cd /etc/yum.repos.d && wget http://www.hop5.in/yum/el6/hop5.repo
yum install docker-io
docker -h
6、启动docker
service docker start

7、停止docker
service docker stop





## pouch
https://yq.aliyun.com/articles/272475

## docker 镜像地址
-[dockerhub](https://mirrors.ustc.edu.cn/help/dockerhub.html)


## docker book
- [Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/introduction/why.html) Docker — 从入门到实践