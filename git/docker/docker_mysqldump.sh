#!/bin/bash
id=`sudo docker ps |grep zhouwei | grep mysql|awk '{print $1}'`

TB=(org_user org_userposition)

for i in ${TB[*]}; do
   echo "dump table $i"

   docker exec ${id} mysqldump -uroot -p1aaWSX  edoc2v5 $i > /home/"$i".sql

done