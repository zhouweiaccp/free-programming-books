
## registry
- [](https://docs.docker.com/registry/)

docker run -d -p 5000:5000 --name registry registry:2
docker pull ubuntu
docker image tag ubuntu localhost:5000/myfirstimage
docker push localhost:5000/myfirstimage


## Harbor 

- [](https://goharbor.io/docs/2.1.0/install-config/installation-prereqs/)


## demo
1.安装docker

# docker install docker
2.拉取仓库镜像

# docker pull registry
3.生成认证certificate

# mkdir ~/certs
# openssl req -newkey rsa:4096 -nodes -sha256 -keyout /root/certs/domain.key  -x509 -days 365 -out /root/certs/domain.crt
4.复制认证到docker

# mkdir /etc/docker/certs.d/mydockerhub.com:5000
# cp /root/certs/domain.crt  /etc/docker/certs.d/mydockerhub.com\:5000/ca.crt
5.复制认证到本机

# cat /root/certs/domain.crt >> /etc/pki/tls/certs/ca-bundle.crt 
7.启动仓库镜像

# docker run -d -p 5000:5000 --privileged=true -v /root/docker/registry:/var/lib/registry -v /root/certs/:/root/certs  -e REGISTRY_HTTP_TLS_CERTIFICATE=/root/cer
ts/domain.crt -e REGISTRY_HTTP_TLS_KEY=/root/certs/domain.key registry
8.创建一个镜像

docker run -it --name=nginx centos /bin/bash
yum install epel-release.noarch -y
yum install nginx -y
docker commit 7ab4d6b6a438 dingyingsi/nginx  //7ab4d6b6a438为容器id
docker tag dingyingsi/nginx mydockerhub.com:5000/nginx:latest //给当前镜像打标签
9.修改当前主机名：

vi /etc/hosts
192.168.184.166 mydockerhub.com
10.推送镜像到https私有仓库

docker push mydockerhub.com:5000/nginx
11.删除本地镜像并重新从https私有仓库拉取镜像

docker rmi mydockerhub.com:5000/nginx
docker pull mydockerhub.com:5000/nginx
 12.添加http basic authentication

docker run --entrypoint htpasswd  registry:2 -Bbn testuser testpassword > /root/auth/htpasswd
13.停止仓库

docker stop  2a4c76559e18
docker start 2a4c76559e18
14.启动http basic authentication仓库

复制代码
docker run -d \
--name registry \
-p 5000:5000 \
--restart=always \
--privileged=true \
-v /root/docker/registry:/var/lib/registry \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-v /root/auth:/root/auth \
-e "REGISTRY_AUTH_HTPASSWD_PATH=/root/auth/htpasswd" \
-v /root/certs/:/root/certs \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/root/certs/domain.crt \
-e REGISTRY_HTTP_TLS_KEY=/root/certs/domain.key \
registry
复制代码
 

15.登录仓库

docker login mydockerhub.com:5000
username:testuser
password:testpassword