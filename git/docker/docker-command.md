基本用法
* [dotnetcore](https://docs.docker.com/engine/examples/dotnetcore/)
 docker build -t aspnetapp .
 docker build -f  Dockerfile.test -t image-train-test .
 docker run -d -p 8080:80 --name myapp aspnetapp  -i -t ubuntu bash
  docker run -itd -v /d/deveolp:soft centos /bin/bash
 docker exec -it 4ba8754ce8a3 bash
 docker logs --follow 4ba8754ce8a3
 docker commit --message "5.8.00ok" 4ba8754ce8a3  edoc2:v3
docker login -uzhouwei -pAA1qaz2WSX 192.168.251.21                    docker login --username=cheergoivan registry.cn-hangzhou.aliyuncs.com

（13）删除镜像
docker rmi c861a419888a（镜像ID）
 （15）创建容器
 docker commit  6746a0ecd213  openldap:v1

 docker inspect -f "{{ .Config.Env }}"  6746a0ecd213


docker run -v /testdocker:/soft --name oracle -d -p 1521:1521 -e ORACLE_ALLOW_REMOTE=true wnameless/oracle-xe-11g

https://docs.docker.com/compose/compose-file/   Compose and Docker compatibility matrix   docker-compose.yml version与安装程序对应关系

cp 从容器里面拷文件到宿主机
docker cp 942377f48ede:/etc/hostname d:/hostname.txt
从宿主机拷文件到容器里面
docker cp d:/ip.txt 942377f48ede:/etc

docker save和docker export的区别
总结一下docker save和docker export的区别：

docker save保存的是镜像（image），docker export保存的是容器（container）；
docker load用来载入镜像包，docker import用来载入容器包，但两者都会恢复为镜像；
docker load不能对载入的镜像重命名，而docker import可以为镜像指定新名称。


docker save -o images.tar postgres:9.6 mongo:3.4     docker load -i images.tar
docker export -o postgres-export.tar postgres docker import postgres-export.tar postgres:latest

Linux scp命令
scp -P 22 local_file remote_username@remote_ip:remote_folder 


部署新的堆栈或更新现有堆栈
docker stack deploy -c docker-compose.yml stack-demo

列出现有堆栈
docker stack ls

列出堆栈中的任务
docker stack ps stack-demo

删除一个或多个堆栈
docker stack rm stack-demo

列出堆栈中的服务
docker stack services stack-demo




docker run -d -p 9000:9000 -l portainer=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

https://www.kancloud.cn/websoft9/docker-guide/829734
yum install docker
systemctl start docker
systemctl enable docker
docker volume create portainer_data
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
cd /usr/libexec/docker/
sudo ln -s docker-runc-current docker-runc


https://github.com/liufee/docker 最新lnmp环境，包含php, java,nginx, mysql, go, node, mongodb, openssh server, redis, crond xhprof,maven等服务
https://github.com/lpxxn/godockerswarm  docker swarms demo


docker images  |grep 20190605154729
docker tag 192.168.251.78/xx/orgsync:20190605155018 192.168.251.119:5000/xx/orgsync:20190605155018
docker push  192.168.251.119:5000/xx/orgsync:20190605155018

Linux查看文件大小的几种方法
stat ~/Downloads/jdk-8u60-linux-x64.tar.gz
du -h  ~/Downloads/jdk-8u60-linux-x64.tar.gz
ls -lh  ~/Downloads/jdk-8u60-linux-x64.tar.gz

查看Linux系统版本信息
cat /proc/version
cat /etc/issue
cat /etc/redhat-release，这种方法只适合Redhat系的Linux
uname -a


https://docs.docker.com/engine/reference/commandline/images/
docker images --format "{{.ID}}: {{.Repository}}"

https://docs.docker.com/engine/reference/commandline/ps/
docker ps --format "table {{.ID}}  \t {{.Image}} \t{{.RunningFor}}\t {{.Names}}"
sudo docker ps --filter "name=ci119-zhouwei-30002_edoc2*" --format "table {{.ID}}"

https://docs.docker.com/v17.09/engine/reference/builder/#copy

## docker 改网段
1)vim /etc/docker/daemon.json（这里没有这个文件的话，自行创建）
{
    "bip":"192.168.0.1/24"
}

2）重启docker    systemctl restart docker

方法2在docker-compose.yml配置文件中明确的指定subnet和gateway
 
复制代码
   nginx2:
      image: nginx:1.13.12
      container_name: nginx2
      restart: always
      networks:
         extnetwork:
            ipv4_address: 172.19.0.2

networks:
  cow-cow5:
    driver: bridge
    ipam:
      driver: default
      config:
      - subnet: 10.88.12.0/24
        gateway: 10.88.12.1

## docker deploy
docker stack deploy -c /opt/docker-compose.yml indrive --resolve-image never    (https://docs.docker.com/engine/reference/commandline/deploy/)  
(“always”|”changed”|”never”)

## Docker CE 的具体加速
一般来说你需要找到 docker daemon 的配置文件 /etc/docker/daemon.json
{
  "insecure-registries" : [
    "registry.mirrors.aliyuncs.com"
  ],
  "debug" : true,
  "experimental" : false,
  "registry-mirrors" : [
    "https://docker.mirrors.ustc.edu.cn",
    "https://dockerhub.azk8s.cn",
    "https://reg-mirror.qiniu.com",
    "https://registry.docker-cn.com"
  ]
}

## 进入容器
docker exec -it $(docker ps | grep elasticsearch:v6.7.1.0|awk '{print $1}') bash
docker exec -it  `docker ps | grep zhouwei| grep org|awk '{print $1}'`  bash

## 普通用户添加docker 权限
sudo groupadd docker     #添加docker用户组
sudo gpasswd -a $USER docker     #将登陆用户加入到docker用户组中
newgrp docker     #更新用户组


## Error response from daemon: Get https://192.168.75.12/v2/: dial tcp 192.168.75.12:443: connect: connection refused
vim /etc/docker/daemon.json 
{
   "insecure-registries": ["https://192.168.75.12"]
}

systemctl restart docker
## network "school-service-net" is declared as external, but could not be found. You need to create a swarm-scoped network before the stack is deployed
docker network create --driver overlay school-service-net

## user_defined_bridge" is declared as external, but it is not in the right scope: "local" instead of "swarm"
docker network create --scope=swarm --driver=bridge --subnet=172.22.0.0/16 --gateway=172.22.0.1 user_defined_bridge



## Your kernel does not support swap limit capabilities or the cgroup is not mounted. Memory limited without swap.
修改系统的/etc/default/grub file文件。使用vim在这个文件中添加一行；
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
sudo update-grub
改动在系统下次重启后生效

## http: server gave HTTP response to HTTPS client & Get https://192.168.2.119/v2/: dial tcp 192.168.2.119:443: getsockopt: connection refused
出现这问题的原因是：Docker自从1.3.X之后docker registry交互默认使用的是HTTPS，但是搭建私有镜像默认使用的是HTTP服务，所以与私有镜像交时出现以上错误
docker start $(docker ps -aq)
如果上述方法还是不能解决，还可以通过以下办法解决：
1.vim  /etc/docker/daemon.json    增加一个daemon.json文件
{ "insecure-registries":["192.168.1.100:5000"] }
保存退出

2.重启docker服务
systemctl daemon-reload
systemctl restart docker



## ## docker 环境变量
printenv

## 将node1节点下线。如果要删除node1节点
温馨提示：更改节点的availablity状态
swarm集群中node的availability状态可以为 active或者drain，其中：
active状态下，node可以接受来自manager节点的任务分派；
drain状态下，node节点会结束task，且不再接受来自manager节点的任务分派（也就是下线节点）。
 
[root@manager-node ~]# docker node update --availability drain node1    //将node1节点下线。如果要删除node1节点，命令是"docker node rm --force node1"

## docker service  --mount-add 挂载
docker service  update --mount-add type=bind,src=/root/anaconda-ks.cfg,dst=/app/anaconda-ks.cfg  --force  --replicas=1  indrive_orgsync
docker service update --mount-rm /app/anaconda-ks.cfg indrive_orgsync  #去掉挂载
[](https://docs.docker.com/engine/reference/commandline/service_update/)



## docker-compose -f docker-com.yml pull

## docker service ps indrive_content --no-trunc 查看日志

##  no suitable node (scheduling constraints not satisfied on 1 node
 docker node update --label-add nodelabels=Middleware $(docker node ls |grep \* |awk '{print $1}')
  修改节点标签
执行命令：（注意：nodeid根据实际情况更改，主机的hostname即可）
docker node update --label-add nodetype=InDrive  nodeid
docker node update --label-add nodelabels=Middleware nodeid
docker  node  update  --label-add  nodeportainer=Portainer   nodeid
https://docs.docker.com/engine/reference/commandline/node_update/

## docker端口
TCP端口2377，用于集群管理信息的交流
TCP、UDP端口7946用于集群中节点的交流
UDP端口4789用于overlay网络中数据报的发送与接收

firewall-cmd --zone=public --add-port=2377/tcp --permanent 　　 # 集群管理端口

firewall-cmd --zone=public --add-port=7946/tcp --permanent 　　 # 节点之间通讯端口
firewall-cmd --zone=public --add-port=7946/udp --permanent

firewall-cmd --zone=public --add-port=4789/tcp --permanent 　　 # overlay网络通讯端口
firewall-cmd --zone=public --add-port=4789/udp --permanent
firewall-cmd --reload

- [docker-compose编排参数详解](https://www.cnblogs.com/wutao666/p/11332186.html)


## 策略
spread: 默认策略，尽量均匀分布，找容器数少的结点调度
binpack: 和spread相反，尽量把一个结点占满再用其他结点
random: 随机
## endpoint-mode:dnsrr
服务器是无法直接通过端口映射被外边访问的

swarm join-token ：可以查看或更换join token。
docker swarm join-token worker：查看加入woker的命令。
docker swarm join-token manager：查看加入manager的命令
docker swarm join-token --rotate worker：重置woker的Token。
docker swarm join-token -q worker：仅打印Token。
 #删除swarm节点
docker swarm leave --force  #node
docker node rm -f <node>    #manager
#docker swarm 常用命令
docker swarm init               #初始化集群
docker swarm join-token worker  #查看工作节点的 token
docker swarm join-token manager #查看管理节点的 token
docker swarm join               #加入集群中
#docker node 常用命令
docker node ls      #查看所有集群节点
docker node rm      #删除某个节点（-f强制删除）
docker node inspect ##查看节点详情
docker node demote  #节点降级，由管理节点降级为工作节点
docker node promote #节点升级，由工作节点升级为管理节点
docker node update  #更新节点
docker node ps      #查看节点中的 Task 任务
#docker service 常用命令
docker service create   #部署服务
docker service inspect  #查看服务详情
docker service logs     #产看某个服务日志
docker service ls       #查看所有服务详情
docker service rm       #删除某个服务（-f强制删除）
docker service scale    #设置某个服务个数
docker service update   #更新某个服务
docker service update --force --image 192.168.251.78/edoc2v5/orgsync:20200427003 --replicas=1 zhou_orgsync  []（https://docs.docker.com/engine/reference/commandline/service_update/）

## 清理
docker container prune # 删除所有退出状态的容器
docker volume prune # 删除未被使用的数据卷
docker image prune # 删除 dangling 或所有未被使用的镜像
删除容器：docker container rm $(docker container ls -a -q)
删除镜像：docker image rm $(docker image ls -a -q)
删除数据卷：docker volume rm $(docker volume ls -q)
删除 network：docker network rm $(docker network ls -q)