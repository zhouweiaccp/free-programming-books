#https://www.cnblogs.com/yufeng218/p/8370670.html
yum remove docker  docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
 yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 yum install docker-ce-18.03.1.ce
systemctl start docker
 #yum erase docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
systemctl enable docker
docker version



## Docker启动Get Permission Denied 
sudo groupadd docker     #添加docker用户组
sudo gpasswd -a $USER docker     #将登陆用户加入到docker用户组中
newgrp docker     #更新用户组
docker ps    #测试docker命令是否可以使用sudo正常使用