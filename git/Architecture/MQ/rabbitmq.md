



### 集群脑裂问题
- [Login was refused using authentication mechanism PLAIN. For details see the](https://stackoverflow.com/questions/26811924/spring-amqp-rabbitmq-3-3-5-access-refused-login-was-refused-using-authentica)
rabbitmqctl add_user admin admin
 rabbitmqctl set_user_tags admin administrator
 rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"


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
