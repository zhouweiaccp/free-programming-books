#!/bin/bash

DEVICES=/dev/vda
BLOCKSIZE=4k,1m,4m
MODE=randwrite,randread
LOGFILE=/tmp/iotest.log
SIZE=1G

FIO_INS(){

which fio > /dev/null 2>&1


if [ $? -ne 0 ]; then
   echo -e "\033[32m 开始安装FIO,请保证可以连接外网，否则安装失败！ \033[0m"
   yum -y install fio > /dev/null 2>&1 
   REVL=$?
   
   if [ $REVL -ne 0 ]; then
      echo -e "\033[31m FIO安装失败，请检查网络是否异常！ \033[0m"
      exit $REVL
   fi
fi


}


IO_TEST(){

for DEV in $(echo "${DEVICES}" |tr ',' ' ')
do
  for BS in $(echo "${BLOCKSIZE}" |tr ',' ' ') 
      do
          for MD in $(echo "${MODE}" |tr ',' ' ')
              do
                  echo "===========================================================================" >> ${LOGFILE}
                  echo "$(date)" >> ${LOGFILE}
                  echo "test ${DEV} ${BS} ${MD}" >> ${LOGFILE}
                  /usr/bin/fio -filename=${DEV} -direct=1 -iodepth 8 -thread=4 -rw=${MD} -ioengine=libaio -bs=${BS} -size=$SIZE -numjobs=8 -runtime=600 -group_reporting -name=mytest >> ${LOGFILE}
              done
      done
done
}

FIO_INS
IO_TEST


