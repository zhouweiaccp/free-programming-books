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