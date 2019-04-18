1.使用说明
一般情况下，修改/etc/apt/sources.list文件，将Debian的默认源地址改成新的地址即可，比如将http://deb.debian.org改成https://mirrors.xxx.com，可使用以下命令：

1
sed -i "s@http://deb.debian.org@https://mirrors.xxx.com@g" /etc/apt/sources.list
若要使用https源，则需要执行apt-get install apt-transport-https，再执行apt-get update更新索引。

 

2.常用站点列表
163镜像站  

复制代码
deb http://mirrors.163.com/debian/ stretch main non-free contrib
deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib
deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib
deb-src http://mirrors.163.com/debian/ stretch main non-free contrib
deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib
deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib
deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib
deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib
复制代码
 

中科大镜像站

复制代码
deb https://mirrors.ustc.edu.cn/debian/ stretch main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ stretch main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ stretch-updates main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ stretch-updates main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ stretch-backports main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ stretch-backports main contrib non-free

deb https://mirrors.ustc.edu.cn/debian-security/ stretch/updates main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian-security/ stretch/updates main contrib non-free
复制代码
 

阿里云镜像站

复制代码
deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib
deb http://mirrors.aliyun.com/debian-security stretch/updates main
deb-src http://mirrors.aliyun.com/debian-security stretch/updates main
deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib
复制代码
 

华为镜像站

deb https://mirrors.huaweicloud.com/debian/ stretch main contrib non-free
deb-src https://mirrors.huaweicloud.com/debian/ stretch main contrib non-free
deb https://mirrors.huaweicloud.com/debian/ stretch-updates main contrib non-free
deb-src https://mirrors.huaweicloud.com/debian/ stretch-updates main contrib non-free
deb https://mirrors.huaweicloud.com/debian/ stretch-backports main contrib non-free
deb-src https://mirrors.huaweicloud.com/debian/ stretch-backports main contrib non-free 
 

清华大学镜像站

复制代码
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-backports main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ stretch/updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ stretch/updates main contrib non-free
复制代码
 

兰州大学镜像站

复制代码
deb http://mirror.lzu.edu.cn/debian stable main contrib non-free
deb-src http://mirror.lzu.edu.cn/debian stable main contrib non-free
deb http://mirror.lzu.edu.cn/debian stable-updates main contrib non-free
deb-src http://mirror.lzu.edu.cn/debian stable-updates main contrib non-free
deb http://mirror.lzu.edu.cn/debian/ stretch-backports main contrib non-free
deb-src http://mirror.lzu.edu.cn/debian/ stretch-backports main contrib non-free
deb http://mirror.lzu.edu.cn/debian-security/ stretch/updates main contrib non-free
deb-src http://mirror.lzu.edu.cn/debian-security/ stretch/updates main contrib non-free
复制代码
 

上海交大镜像站

复制代码
deb https://mirror.sjtu.edu.cn/debian/ stretch main contrib non-free
deb-src https://mirror.sjtu.edu.cn/debian/ stretch main contrib non-free
deb https://mirror.sjtu.edu.cn/debian/ stretch-updates main contrib non-free
deb-src https://mirror.sjtu.edu.cn/debian/ stretch-updates main contrib non-free
deb https://mirror.sjtu.edu.cn/debian/ stretch-backports main contrib non-free
deb-src https://mirror.sjtu.edu.cn/debian/ stretch-backports main contrib non-free
deb https://mirror.sjtu.edu.cn/debian-security/ stretch/updates main contrib non-free
deb-src https://mirror.sjtu.edu.cn/debian-security/ stretch/updates main contrib non-free
复制代码