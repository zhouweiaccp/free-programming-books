#!/bin/bash
# 安装函数
install(){
   for soft in $*
   do
        echo "$soft"安装中...
        yum -y install $soft &>/dev/null
        if [ $? -ne 0 ];then
#                echo "$soft"安装失败
                echo "$soft"安装失败 >> /opt/log.txt
#               return 48
        else
                systemctl restart $soft &> /dev/null
                if [ $? -ne 0 ];then
                        systemctl restart "$soft"d &> /dev/null
                        [ $? -ne 0 ] && echo "$soft"启动失败 >> /opt/log.txt
                        systemctl enable "$soft"d &> /dev/null
                else
                        systemctl enable $soft &> /dev/null
#                       return 0
                fi
 
                 echo "$soft"安装成功
 
                 echo "$soft"安装成功 >> /opt/log.txt
        fi
   done
}
 
yum list &> /dev/null
if [ $? -ne 0 ];then
        echo yum源不可用 > /opt/log.txt
else
        install $*
fi