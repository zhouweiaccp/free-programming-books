
https://www.cnblogs.com/xiaoxiaotank/p/14762665.html

官方文档：https://www.jenkins.io/doc/book/installing/docker/

先说一下：官方文档中使用了镜像docker:dind来执行docker命令和运行程序容器，我感觉完全没啥必要，而且引入这玩意会带来很多额外的问题，所以我没用它。

如果你想了解dind，请访问这里和这篇博客

创建Dockerfile文件
vim Dockerfile
在Dockerfile文件中填入以下内容
Tag参考：https://hub.docker.com/r/jenkins/jenkins
注意：不要使用过时的镜像 jenkins，而应该使用镜像 jenkins/jenkins
FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"

# 安装 docker-ce-cli 才能在 jenkins 中发送 docker 命令到 docker daemon
RUN apt-get update && apt-get install -y docker-ce-cli
构建镜像
docker build . -t myjenkins
如果出现警告：[Warning] IPv4 forwarding is disabled. Networking will not work.

其实就是说你的linux没有开启 Ipv4 数据包转发功能

可以先尝试重启docker解决

systemctl restart docker
如果无效，则

# 1. 打开 sysctl.conf
vim /etc/sysctl.conf

# 2.添加下面一行
net.ipv4.ip_forward=1

# 3.重启 network 和 docker
systemctl restart network && systemctl restart docker
运行Jenkins
注释版
docker run \
  --name jenkins \                                      # 给容器起个名字，叫做 jenkins
  --detach \                                            # 以后台分离模式运行
  --publish 8080:8080 \                                 # host 8080端口映射容器8080端口
  --publish 50000:50000 \                               # host 50000端口映射容器50000端口
  --volume jenkins-data:/var/jenkins_home \             # 卷 jenkins-data 映射容器路径/var/jenkins_home，这样就可以在host上直接修改jenkins配置了
  --volume /var/run/docker.sock:/var/run/docker.sock \  # host 上的docker sock映射容器的docker sock，这样容器内的docker命令都会发送到host上的docker中来执行
  myjenkins                                             # 使用刚刚构建的镜像 myjenkins 来运行容器
无注释版
docker run \
  --name jenkins \
  --detach \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  myjenkins
更换Jenkins插件源
前面我们将容器内的路径 /var/jenkins_home 映射到了volume jenkins-data，而所有的docker volume 都存放在目录 /var/lib/docker/volumes/下

打开hudson.model.UpdateCenter.xml
vim /var/lib/docker/volumes/jenkins-data/_data/hudson.model.UpdateCenter.xml
将文件中的url改为清华大学官方镜像：
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
即：
<?xml version='1.1' encoding='UTF-8'?>
<sites>
  <site>
    <id>default</id>
    <!--原 url： https://updates.jenkins.io/update-center.json -->
    <url>https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json</url>
  </site>
</sites>
重启 Jenkins：
docker restart jenkins
访问：http://<host-ip>:8080
输入管理员初始密码
查看管理员初始密码：
cat /var/lib/docker/volumes/jenkins-data/_data/secrets/initialAdminPassword