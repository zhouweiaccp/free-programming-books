#!/bin/bash
MASTER_HOST=$(cat /data/config/sentinel.conf |grep monitor |cut -d ' ' -f4)
while true;do
   if redis-cli -h ${MASTER_HOST} INFO &> /dev/null;then
        redis-server /data/config/sentinel.conf --sentinel
        if [ $? -eq 0 ];then
	     break
        fi
   fi
   sleep 5
done
