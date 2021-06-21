

##　WSL-Ubuntu 的根目录在C盘下面
C:\Users\sheny\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\


##. wsl2地址每次重新开机之后都会发生变化
一般来说这不是什么大问题，但是别忘了我们要wsl是干啥的，我们总是希望能够在windows中访问wsl中的一些服务，比如安装的mysql、redis等，如果wsl的ip地址总是变化，岂不是每次开机都要在windows中手动设置一次ip地址[ 1 ]？固定ip地址的方法比较简单，直接运行以下脚本即可，我这里安装了docker，有些小伙伴没安装docker则需要修改下脚本才行。
https://www.cnblogs.com/kuangdaoyizhimei/p/14175143.html
@echo off
setlocal enabledelayedexpansion

wsl -u root service docker start | findstr "Starting Docker" > nul
if !errorlevel! equ 0 (
    echo docker start success
    :: set wsl2 ip
    wsl -u root ip addr | findstr "192.168.169.2" > nul
    if !errorlevel! equ 0 (
        echo wsl ip has set
    ) else (
        wsl -u root ip addr add 192.168.169.2/28 broadcast 192.168.169.15 dev eth0 label eth0:1
        echo set wsl ip success: 192.168.169.2
    )

    :: set windows ip
    ipconfig | findstr "192.168.169.1" > nul
    if !errorlevel! equ 0 (
        echo windows ip has set
    ) else (
        netsh interface ip add address "vEthernet (WSL)" 192.168.169.1 255.255.255.240
        echo set windows ip success: 192.168.169.1
    )
)

##　　docker
```sh
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -


sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"


    sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
## docker-compose
```bash
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```