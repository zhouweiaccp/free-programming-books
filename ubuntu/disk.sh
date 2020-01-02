

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