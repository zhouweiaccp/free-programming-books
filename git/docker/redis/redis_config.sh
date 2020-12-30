#!/bin/bash

if [ ! -f /data/host_list ];then
     touch /data/host_list
fi

while true
do
  for HOSTNAME in redis1 redis2 redis3
  do
      HOST_IP=$(dig ${HOSTNAME} +short)
      if [ -n "${HOST_IP}" ];then
          sed -i /${HOSTNAME}/d /data/host_list 
          echo "${HOSTNAME} ${HOST_IP}" >> /data/host_list
      fi
  done 
  sleep 3
done
