

sudo fdisk -l #查看硬盘的分区 #
 hdparm -i /dev/hda　#查看IDE硬盘信息 #sud
hdparm -I /dev/sda 
sudo apt-get install blktool #sudo blktool /dev/sda id #　查看STAT硬盘信息 #sudo hdparm -I /dev/sda 或 #sudo apt-get install blktool #sudo blktool /dev/sda id
df -h #　查看硬盘剩余空间 #df -h #df -H
du -hs 目录名　查看目录占用空间 #du -hs 目录名
sync fuser -km /media/usbdisk #　优盘没法卸载 #
mkfs.ext4 /dev/vdb1  #mkfs.ext4 /dev/vdb1  
 cat /etc/fstab
# 
- [](https://www.fujieace.com/linux/centos-mount.html)

# 常见的命名：
# fd：软驱
# hd：IDE 磁盘
# sd：SCSI 磁盘
# tty：terminals
# vd：virtio 磁盘

# IOtest.sh  测试

fdisk /dev/sdb 创建磁盘的分区 [](https://jingyan.baidu.com/album/aa6a2c14bd8cc70d4c19c4c8.html?picindex=2)
我们为这个硬盘创建分区，输入fdisk /dev/sdb，依次输入n，p，1，w，其中n分别表示创建一个新分区，p表示分区类型为主分区，1表示分区编号是1，w表示保存

3、mkfs -t ext4 /dev/sdb 格式化文件系统
4、mkdir /data; 
mount /dev/sdb /data

5、设计开机启动自动加载
vim /etc/fstab
/dev/sdb /data ext4 defaults 0 0

参数解释：

具体说明，以挂载/dev/sdb1为例：
：分区定位，可以给UUID或LABEL，例如：UUID=6E9ADAC29ADA85CD或LABEL=software
：具体挂载点的位置，例如：/data
：挂载磁盘文件系统类型，linux分区一般为ext4，windows分区一般为ntfs
：挂载参数，一般为defaults
：指定分区是否被dump备份，0代表不备份，1代表每天备份，2代表不定期备份。
：磁盘检查，默认为0，不需要检查
修改完/etc/fstab文件后，运行命令：sudo mount -a如果没有报错就证明配制好了。如果配置不正确可能会导致系统无法正常启动。
重启系统 命令：sudo reboot
修复由/etc/fstab文件配制错误引起的系统不能启动问题
启动后根据提示按 m 进入root命令行页面，更改/etc/fstab文件，然后重新启动。如果不能修改/etc/fstab文件，可能是根分区挂载权限问题，可使用 mount -o remount,rw / 重新挂载根分区，其中rw代表读写权限。修改好后，重启完成修复
原文链接：https://blog.csdn.net/qq_21950671/article/details/85098022