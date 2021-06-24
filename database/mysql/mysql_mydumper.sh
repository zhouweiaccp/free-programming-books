#!/bin/bash
# ./mydumper.sh -u efor11m -p 1qaz2WSX1qaz2WSX -h 192.168.251.67 -P 30001 -b edoc2v5 -o /opt/bak   备份demo

# 2：还原：还原到另一台服务器，先建立要还原的数据库(edoc2v5)
#  myloader -u efor11m -p 1qaz2WSX1qaz2WSX -h 192.168.251.67 -P 30001 -o -d /opt/bak/20210623180010/

# wget https://github.com/maxbube/mydumper/releases/download/v0.10.5/mydumper_0.10.5-1.$(lsb_release -cs)_amd64.deb
# dpkg -i mydumper_0.10.5-1.$(lsb_release -cs)_amd64.deb

# mydumper 备份脚本
# sh mydumper.sh -u user -p passwd -o /backdir [ -d 4(保存天数) -b databases -t table -h locahost —P port -s SockFile -c]
# 参数说明：
# -u : (必选)备份使用用户
# -p : (必选)用户密码
# -o : (必选)备份路径
# -d : [可选]备份保存天数
# -b : [可选]要备份哪个库(选择后只备份这个库)
# -t : [可选]要备份哪个表(选择后只备份这个表，必须配合 -b 使用)
# -h : [可选]备份 MySQL 地址，默认 localhost
# -P : [可选]备份 MySQL 端口，默认 3306
# -s : [可选]使用socket连接
# -x : [可选]备份线程，默认4线程
# -c : [可选]是否需要压缩备份
# 使用场景说明

# 1. 临时执行备份
#  sh mydumper.sh -u user -p passwd -o /backdir [ -b databases -t table -h locahost -c ]
 
# 执行此命令会在 /backdir 目录下生成一个当天日期的文件目录，存放此次数据库备份。
# 备份过程日志会记录在 /tmp/mydumper.log 日志文件中。
 
# 2. 计划任务定期执行
# 在 crontab 里增加计划任务
# 示例：

# 0 4 * * * sh mydumper.sh -u user -p passwd -o /backdir -d 4 -c

# C

# 此计划任务会在每天凌晨4点，进行备份，备份结果存放在 /backdir 目录下，备份保存 4 天，且对备份进行压缩。

# 注意：计划任务定期执行一定要加 -d 参数设置保存数据多少天。否则可能将磁盘撑爆。

 

# 3. 其他挂载需求

# 如果需要将备份存放在其他磁盘，比如 NAS 或 NFS 磁盘

# 需要在脚本中增加
# mount_dir=''
# 配置要挂载到的文件路径。默认挂载中的备份文件保存15天。
# 然后注释掉脚本末尾的 mount_backup

# ...

# check_back_dir
# echo "`date` $cmd" >$log_dir
# del_save_days
# $cmd
# mount_backup

# C

 
# 三、恢复命令

# 恢复场景一：

# 需要恢复全库备份

# myloader -u 用户名 -p 密码 -h 要恢复到的数据库IP -P 端口 -o -d 数据库备份路径 -t 4

# Markup

 

# 恢复场景二：

# 需要恢复某个库，比如恢复备份中的 A_database 库到目标的数据库的 A_database 库

# myloader -u 用户名 -p 密码 -h 要恢复到的数据库IP -P 端口 -o -d 数据库备份路径 -t 4 -s A_database

# Markup

 

# 恢复场景三：

# 需要恢复备份中的 A_database 库到目标数据库的 B_database 库中

# myloader -u 用户名 -p 密码 -h 要恢复到的数据库IP -P 端口 -o -d 数据库备份路径 -t 4 -s A_database -B B_database

# Markup

 

# 恢复场景四：

# 需要恢复备份中的某一个表

# 在数据库命令行中，执行source 命令去恢复单表

# #恢复表结构
# source table-schema.sql
# #恢复数据
# source tables.sql

# mydumper.sh  如下

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

check_mydumper=$(yum list installed|grep mydumper |wc -l)
mydumper_rpm='https://github.com/maxbube/mydumper/releases/download/v0.9.5/mydumper-0.9.5-2.el7.x86_64.rpm'

mount_dir=''

if [ ${check_mydumper} != 0 ];then
  mydumper_version=$(mydumper --version  |awk -F, '{print $1}')
  echo "mydumper already installed.The version is ${mydumper_version}"
else
  echo "mydumper has not been installed, install now..."
  yum install ${mydumper_rpm} || echo -e "\n########Install failed.Please check.########\n" && exit 1
fi

cmd="mydumper -R -e "

log_dir=/tmp/mydumper.log
while getopts :u::p::o:d:b:t:h:x:s:P:c opt;do
  case $opt in
    c) cmd=$cmd" -c ";;
    u) cmd=$cmd" -u $OPTARG"
       user=$OPTARG ;;
    p) cmd=$cmd" -p $OPTARG"
       passwd=$OPTARG ;;
    o) cmd=$cmd" -o $OPTARG/`date -d yesterday +%Y%m%d`" 
       back_dir=$OPTARG ;;
    h) cmd=$cmd" -h $OPTARG" ;;
    P) cmd=$cmd" -P $OPTARG" ;;
    b) cmd=$cmd" -B $OPTARG" ;;
    t) cmd=$cmd" -T $OPTARG" ;;
    x) cmd=$cmd" -t $OPTARG" ;;
    s) cmd=$cmd" -S $OPTARG" ;;
    d) save_days=$OPTARG ;;
    ?) exit 1;;
  esac
done

check_back_dir(){
if [ ! -d $back_dir ];then
  mkdir -p $back_dir
fi
}

# 删除旧备份
del_save_days(){
if [ $? -eq 0 ];then
  #find $back_dir -maxdepth 1 -type d -ctime +$save_days | xargs rm -rf
  rm -rf $back_dir/`date --date "$save_days days ago" +%Y%m%d`
fi
}

# 是否需要拷贝备份到挂载磁盘
mount_backup(){
  rsync -a $back_dir/`date -d yesterday +%Y%m%d` $mount_dir/
  echo "`date` 拷贝备份到挂载目录" 2>&1 >>$log_dir
  rm -rf $mount_dir/`date --date "15 days ago" +%Y%m%d`
  echo `date` ' 删除挂载目录15天前备份' 2>&1 >>$log_dir
}

if [ -z  "$user" -a -z "$passwd" -a -z "$back_dir" ];then
  exit 1
fi

check_back_dir
echo "`date` $cmd" >$log_dir
del_save_days
$cmd
# mount_backup

#chmod +x /opt/backup_script/mydumper.sh

# crontab -e
# 00 03 * * * /bin/sh /opt/backup_script/mydumper.sh -u repl -p Xjb0^DDy -h 192.168.20.26 -P 30001 -b edoc2v5 -d 15 -o /opt/backdir &> /dev/nul

# 注：以上例子是每天凌晨进行数据备份，仅供参考，实际情况请根据客户需求更改

# 上面的例子，备份远程主机的MySQL 192.168.20.26 上的edoc2v5库的数据，到 /opt/backdir 下，保留15天的数据