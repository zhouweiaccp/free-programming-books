#!/bin/bash

#https://docs.docker.com/install/linux/docker-ce/ubuntu/
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
   software-properties-common
echo 'curl ....https://download.docker.com/linux/ubuntu/gpg '
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo 'apt update....'
  apt update
  apt install -y docker-ce docker-ce-cli containerd.io
  mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://dist7hw1.mirror.aliyuncs.com"]
}
EOF
 systemctl daemon-reload &&systemctl restart docker
  #apt-get purge docker-ce
function install_bin(){
  #https://blog.csdn.net/yangqinjiang/article/details/80792313
  #https://www.cnblogs.com/xiaochina/p/10469715.html
  wget https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz
tar xzvf docker-18.03.1-ce.tgz
cp docker/* /usr/bin/
cat >/etc/systemd/system/docker.service <<-EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
  
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
  
[Install]
WantedBy=multi-user.target
EOF
 
#start
chmod +x /etc/systemd/system/docker.service
systemctl daemon-reload && systemctl start docker && systemctl enable docker.service   
 
#testing
systemctl status docker && docker -v

}