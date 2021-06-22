
## 启用适用于 Linux 的 Windows 子系统
```powershell
 Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
#  https://docs.microsoft.com/zh-cn/windows/wsl/install-manual
Rename-Item .\Ubuntu.appx .\Ubuntu.zip
Expand-Archive .\Ubuntu.zip .\Ubuntu

# 忘记密码
# 如果忘记了 Linux 分发版的密码：

# 请打开 PowerShell，并使用以下命令进入默认 WSL 分发版的根目录：wsl -u root

# 如果需要在非默认分发版中更新忘记的密码，请使用命令：wsl -d Debian -u root，并将 Debian 替换为目标分发版的名称。
```


## 如何修改WSL的安装路径
下载wsl的appx镜像https://docs.microsoft.com/zh-cn/windows/wsl/install-manual，比如下载的Ubuntu 18.04
将下载的文件的后缀Appx改为zip，然后解压到你想要安装该wsl的位置。比如像安装到Z盘，则解压到Z盘。比如我当前所在目录是在Z，解压后的目录是Ubuntu18.04onWindows_1804  
所以，这种安装方式相当于绿色版的wsl，解压到哪，就运行(安装)在哪。

那么多版本的wsl也非常容易了，随便在哪个位置装都行。

## 迁移已安装在系统盘的WSL
```dos
https://github.com/DDoSolitary/LxRunOffline/releases/tag/v3.4.1

# 查看当前已经安装的wsl
PS G:\桌面\LxRunOffline-v3.4.0> .\LxRunOffline.exe list
Legacy
Ubuntu-18.04
 
# 移动指定的wsl
# 比如移动Legacy到Z:\LegacyWSL目录下
PS G:\桌面\LxRunOffline-v3.4.0> .\LxRunOffline.exe move -n Legacy -d ‘Z:\LegacyWSL\‘
```

##　WSL-Ubuntu 的根目录在C盘下面
C:\Users\sheny\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\

## 命令
https://docs.microsoft.com/zh-cn/windows/wsl/wsl-config
https://docs.microsoft.com/zh-cn/windows/wsl/reference
 wsl --list
 wsl -s <DistributionName> 设置默认分发版
 wsl --unregister <DistributionName>  取消
wsl -d <DistributionName>, wsl --distribution <DistributionName>  运行特定的分发版
## wsl2地址每次重新开机之后都会发生变化
一般来说这不是什么大问题，但是别忘了我们要wsl是干啥的，我们总是希望能够在windows中访问wsl中的一些服务，比如安装的mysql、redis等，如果wsl的ip地址总是变化，岂不是每次开机都要在windows中手动设置一次ip地址[ 1 ]？固定ip地址的方法比较简单，直接运行以下脚本即可，我这里安装了docker，有些小伙伴没安装docker则需要修改下脚本才行。
https://www.cnblogs.com/kuangdaoyizhimei/p/14175143.html
```dos
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
```
## ssh 登录
```bash
 apt-get remove --purge openssh-server
#重新安装ssh服务
 apt-get install openssh-server ssh  

#编辑sshd_config文件，修改几处配置才能正常使用用户名/密码的方式连接


#需要找到并修改以下几项(其他博客有修改其他项成功的,但是我只改了这两项就OK了)
#Port 222  #默认的是22，Windows自己的SSH服务也是的22端口，所以我改成了223
#PermitRootLogin yes #默认是PermitRootLogin prohibit-password
sed -ir 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ir 's/^#Port.*/Port 222/' /etc/ssh/sshd_config
/etc/init.d/ssh start
service ssh --full-restart
```

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
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl daemon-reload
systemctl restart docker.service
service docker restart
```
## docker-compose
```bash
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```