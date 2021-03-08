https://github.com/DocsHome/microservices  学习站点

https://github.com/Seedin/ConsulHelper


做服务发现的框架常用的有
定义：**CAP定理指的是在一个分布式系统中，Consistency（一致性）、 Availability（可用性）、Partition tolerance（分区容错性），三者不可兼得**。CAP定理的命名就是这三个指标的首字母。

- **Partition tolerance** 指的是在分布式系统中，由于不同的服务器之间可能无法通讯，所以需要一定的容错机制，默认情况下认为 Partition tolerance总是成立。

- **Consistency** 指的是在分布式系统中，不同的服务器上所存储的数据需要一致，可以理解成当服务器A执行操作数据的指令后，服务器B上也要应用同样的操作以保证其所提供的数据同A中的一致。
- **Availability** 指的是分布式系统中，每当服务端收到客户端的请求，服务端都必须给出回应。

zookeeper cp
eureka    ap
etcd     cp
consul  cp



Consul强一致性(C)带来的是：

服务注册相比Eureka会稍慢一些。因为Consul的raft协议要求必须过半数的节点都写入成功才认为注册成功
Leader挂掉时，重新选举期间整个consul不可用。保证了强一致性但牺牲了可用性。
Eureka保证高可用(A)和最终一致性：

服务注册相对要快，因为不需要等注册信息replicate到其他节点，也不保证注册信息是否replicate成功
当数据出现不一致时，虽然A, B上的注册信息不完全相同，但每个Eureka节点依然能够正常对外提供服务，这会出现查询服务信息时如果请求A查不到，但请求B就能查到。如此保证了可用性但牺牲了一致性。
其他方面，eureka就是个servlet程序，跑在servlet容器中; Consul则是go编写而成。

这里就平时经常用到的服务发现的产品进行下特性的对比，首先看下结论:

Feature	Consul	zookeeper	etcd	euerka
服务健康检查	服务状态，内存，硬盘等	(弱)长连接，keepalive	连接心跳	可配支持
多数据中心	支持	—	—	—
kv存储服务	支持	支持	支持	—
一致性	raft	paxos	raft	—
cap	ca	cp	cp	ap
使用接口(多语言能力)	支持http和dns	客户端	http/grpc	http（sidecar）
watch支持	全量/支持long polling	支持	支持 long polling	支持 long polling/大部分增量
自身监控	metrics	—	metrics	metrics
安全	acl /https	acl	https支持（弱）	—
spring cloud集成	已支持	已支持	已支持	已支持
服务的健康检查
Euraka 使用时需要显式配置健康检查支持；Zookeeper,Etcd 则在失去了和服务进程的连接情况下任务不健康，而 Consul 相对更为详细点，比如内存是否已使用了90%，文件系统的空间是不是快不足了。

多数据中心支持
Consul 通过 WAN 的 Gossip 协议，完成跨数据中心的同步；而且其他的产品则需要额外的开发工作来实现；

KV 存储服务
除了 Eureka ,其他几款都能够对外支持 k-v 的存储服务，所以后面会讲到这几款产品追求高一致性的重要原因。而提供存储服务，也能够较好的转化为动态配置服务哦。

产品设计中 CAP 理论的取舍
Eureka 典型的 AP,作为分布式场景下的服务发现的产品较为合适，服务发现场景的可用性优先级较高，一致性并不是特别致命。其次 CA 类型的场景 Consul,也能提供较高的可用性，并能 k-v store 服务保证一致性。 而Zookeeper,Etcd则是CP类型 牺牲可用性，在服务发现场景并没太大优势；

多语言能力与对外提供服务的接入协议
Zookeeper的跨语言支持较弱，其他几款支持 http11 提供接入的可能。Euraka 一般通过 sidecar的方式提供多语言客户端的接入支持。Etcd 还提供了Grpc的支持。 Consul除了标准的Rest服务api,还提供了DNS的支持。

Watch的支持（客户端观察到服务提供者变化）
Zookeeper 支持服务器端推送变化，Eureka 2.0(正在开发中)也计划支持。 Eureka 1,Consul,Etcd则都通过长轮询的方式来实现变化的感知；

自身集群的监控
除了 Zookeeper ,其他几款都默认支持 metrics，运维者可以搜集并报警这些度量信息达到监控目的；

安全
Consul,Zookeeper 支持ACL，另外 Consul,Etcd 支持安全通道https.

Spring Cloud的集成
目前都有相对应的 boot starter，提供了集成能力。

总的来看，目前Consul 自身功能，和 spring cloud 对其集成的支持都相对较为完善，而且运维的复杂度较为简单（没有详细列出讨论），Eureka 设计上比较符合场景，但还需持续的完善。
https://blog.csdn.net/ZYC88888/article/details/81453647 

https://github.com/dyc87112/SpringCloud-Learning/tree/master/2-Dalston%E7%89%88%E6%95%99%E7%A8%8B%E7%A4%BA%E4%BE%8B