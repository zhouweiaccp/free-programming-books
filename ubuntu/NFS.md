git@github.com:zhouweiaccp/Linux-Tutorial.git ## NFS 安装

## NFS 安装

-   查看是否已安装：
-   CentOS：`rpm -qa | grep nfs-*`
-   Ubuntu：`dpkg -l | grep nfs-*`

-   安装：
-   CentOS 5：`sudo yum install -y nfs-utils portmap`
-   CentOS 6：`sudo yum install -y nfs-utils rpcbind`
-   Ubuntu：`sudo apt-get install -y nfs-common nfs-kernel-server`

## NFS 服务器配置文件常用参数

-   配置文件介绍（记得先备份）：`sudo vim /etc/exports`
-   默认配置文件里面是没啥内容的，我们需要自己加上配置内容，一行表示共享一个目录。为了方便使用，共享的目录最好将权限设置为 777（`chmod 777 folderName`）。
-   假设在配置文件里面加上：`/opt/mytest 192.168.0.0/55(rw,sync,all_squash,anonuid=501,anongid=501,no_subtree_check)`
-   该配置解释：

    -   /opt/mytest 表示我们要共享的目录
    -   192.168.0.0/55 表示内网中这个网段区间的 IP 是可以进行访问的，如果要任意网段都可以访问，可以用 `*` 号表示
    -   (rw,sync,all_squash,anonuid=501,anongid=501,no_subtree_check) 表示权限
        -   rw：是可读写（ro 是只读）
        -   sync：同步模式，表示内存中的数据时时刻刻写入磁盘（async：非同步模式，内存中数据定期存入磁盘）
        -   all_squash：表示不管使用 NFS 的用户是谁，其身份都会被限定为一个指定的普通用户身份。（no_root_squash：其他客户端主机的 root 用户对该目录有至高权限控制。root_squash：表示其他客户端主机的 root 用户对该目录有普通用户权限控制）
        -   anonuid/anongid：要和 root_squash 或 all_squash 选项一同使用，表示指定使用 NFS 的用户被限定后的 uid 和 gid，前提是本图片服务器的/etc/passwd 中存在这一的 uid 和 gid
        -   no_subtree_check：不检查父目录的权限

-   启动服务：
-   `/etc/init.d/rpcbind restart`
-   `/etc/init.d/nfs-kernel-server restart`

## NFS 客户端访问

-   客户端要访问服务端的共享目录需要对其共享的目录进行挂载，在挂载之前先检查下：`showmount -e 192.168.1.25`（这个 IP 是 NFS 的服务器端 IP）
-   如果显示：/opt/mytest 相关信息表示成功了。
-   现在开始对其进行挂载：`mount -t nfs 192.168.1.25:/opt/mytest/ /mytest/`
-   在客户端机器上输入命令：`df -h` 可以看到多了一个 mytest 分区。然后我们可以再创建一个软链接，把软链接放在 war 包的目录下，这样上传的图片都会跑到另外一台服务器上了。软链接相关内容请自行搜索。

## NFS 资料

-   <http://wiki.jikexueyuan.com/project/linux/nfs.html>
-   <http://www.jb51.net/os/RedHat/77993.html>
-   <http://www.cnblogs.com/Charles-Zhang-Blog/archive/2013/02/05/2892879.html>
-   <http://www.linuxidc.com/Linux/2013-08/89154.htm>
-   <http://www.centoscn.com/image-text/config/2015/0111/4475.html>

https://www.cnblogs.com/Dy1an/p/10536093.html
安装部署 NFS

闲话少说，直接开干，具体拓扑图如下：

我们以两台测试机器为例，系统都为 CENTOS 7.5~

我们要共享的目录结构如下图，我们想把 node1 上面的三个目录都刚想出去给 node2 挂载：

【1】在 node1 上面部署配置 NFS 服务端：

# 安装需要的包

yum -y install nfs-utils rpcbind

# 添加共享配置

vim /etc/exports

内容如下：

/nfsdata 192.168.100.101(rw,fsid=0,sync,no_wdelay,insecure_locks,no_root_squash)
简单的说一下配置：

1. 这是一个通用的配置，几乎对挂载目录没做什么限制，参数后续会就行补充说明。

2. 三个目录，但是我们只做了 1 条规则，这个规则是下面需要共享目录的顶层目录。

3. 在规则的后面有个 fsid=0 的配置，这是 NFS4 不可缺少的。

启动服务：

复制代码

# 启动 rpcbind 和配置开机自启动

systemctl start rpcbind
systemctl enable rpcbind

# 启动 nfs 和配置开机自启动

systemctl start nfs
systemctl enable nfs
复制代码

查看本机共享目录情况：

showmount -e
如图：

注意：在我们修改 exports 文件的添加其他目录的时候，我们需要重启 rpcbind 和 nfs 服务端服务，再度查看才会存在！

【2】在 node2 上面部署 nfs 客户端：

yum -y install nfs-utils rpcbind

启动服务，和服务端不同的是，我们只需要启动 rpcbind 服务即可~

# 启动 rpcbind 和配置开机自启动

systemctl start rpcbind
systemctl enable rpcbind

查看指定服务器授权给我们的目录：

showmount -e 192.168.100.100
结果如图：

本地的目录结构：

我们依次想把 node1 上面的 test123 挂载到 node2 上面的 data123 ~

mount -t nfs4 192.168.100.100:/test1 /nfsdata/data1
mount -t nfs4 192.168.100.100:/test2 /nfsdata/data2
mount -t nfs4 192.168.100.100:/test3 /nfsdata/data3
和传统的 nfs 不一样，这里我们指定协议为 nfs4~

查看挂载结果：

nfsstat -m
结果如图：

查看目录效果：

至此，NFS 同主机多目录 NFS4 协议挂载完成~

参数说明

【1】挂载授权 IP 说明：

配置 说明
授权某个 IP 192.168.1.1
授权某个网段 192.168.1.0/24
授权某个域名 www.baidu.com
授权某个域 _.baidu.com
授权所有 _

【2】授权参数：

参数 说明
ro 目录只读
rw 目录可读写
all_squash 将远程访问的所有普通用户和组都映射为匿名（nfsnobody）
no_all_squash 与 all_squash 取反（默认设置）
root_squash 将 root 用户及所属组都映射为匿名用户或用户组（默认设置）
no_root_squash 与 root_squash 取反
anonuid=xxx 将远程访问的所有用户都映射为匿名用户，并指定该用户为本地用户（UID=xxx）
anongid=xxx 将远程访问的所有用户组都映射为匿名用户组，并指定该匿名用户组为本地用户组（GID=xxx）
secure 限制客户端只能从小于 1024 的 tcp/ip 端口连接 nfs 服务器（默认设置）
insecure 允许客户端从大于 1024 的 tcp/ip 端口连接服务器
sync 将数据同步写入内存缓冲区与磁盘中，效率低，但可以保证数据的一致性
async 将数据先保存在内存缓冲区中，必要时才写入磁盘
wdelay 检查是否有相关的写操作，如果有则将这些写操作一起执行，这样可以提高效率（默认设置）
no_wdelay 若有写操作则立即执行，应与 sync 配合使用
subtree_check 若目录是一个子目录，则 nfs 服务器将检查其父目录的权限(默认设置)
no_subtree_check 即使目录是一个子目录，nfs 服务器也不检查其父目录的权限，这样可以提高效率



### install sh
```bash
# 说明: 本文档适用于centos系统nfs相关操作,建议使用nfs v4协议.

# 1. NFS server端安装
 yum -y install nfs-utils  rpcbind
# 2. 配置nfs
cat >>  /etc/exports << efo

/opt/data *(rw,no_root_squash,no_all_squash,anonuid=0,anongid=0,sync)
efo
#注: 以上例子是通过NFS共享本地的/opt/data ,部署时请根据实际情况修改目录

#3. 启动nfs服务
systemctl  start  rpcbind
systemctl  start  nfs
systemctl  enable  rpcbind
systemctl  enable  nfs

# 3. 客户端挂载nfs
# 检查本地是否支持nfs文件系统

rpm -qa |grep nfs-utils
#以上命令有输出说明己支持nfs文件系统

#如果不支持需要安装nfs-utils
yum -y install nfs-utils

#挂载NFS
mkdir /nfs
mount -t nfs -o noac,nfsvers=4,_netdev NFS_SERVER_IP:/opt/data  /nfs
# 设置开机自动挂载

cat >>   /etc/fstab << efo

NFS_SERVER_IP:/opt/data  /nfs  defautls,nfsvers=4,_netdev,noac  0  0 
efo
# 注: /nfs为本地路径,如果不存在,需要使用mkdir创建
#    NFS_SERVER_IP 为NFS server的ip
#   /opt/data  为nfs服务端共享的路径
# 请根据实际情况修改 /nfs,NFS_SERVER_IP,/opt/data 三个参数
```