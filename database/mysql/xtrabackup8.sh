#!/bin/bash
#This mysql backup scripts.
#
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
#export PATH
set -u

dir="/opt/dbbackup"
user='root'
pass='1qaz2WSX1'
logfile="${dir}/xtra.log"
HOST='127.0.0.1'
USE_MEM="1024m"
IOPS=60

if [ ! -d $dir ]; then
    mkdir -p $dir
fi

full_backup() {
   fulldir=`date +%Y-%m-%d-%H:%M:%S`-base
   cd $dir
   mkdir $fulldir
   echo "Full Backup Start Time: `date`" > $logfile
   echo "=============================" >> $logfile
   xtrabackup  --throttle=$IOPS --use-memory=$USE_MEM  --host=$HOST \
   --user=$user --password=$pass --backup --extra-lsndir=$dir \
   --stream=xbstream --target-dir=$dir/$fulldir 2>>$logfile | gzip - > $dir/$fulldir/${fulldir}.gz

   RETVAL=$?
        if [[ $RETVAL == 0 ]] && [[ `tail -50 "${logfile}" | egrep -ic "\berror\b|\bfailed\b"` == 0 ]]; then
            echo "" >> $logfile
            echo "=============================" >> $logfile
            echo "Full Backup Sucess!!: `date`" >> $logfile
            return 0
        else
            echo "" >> $logfile
            echo "=============================" >> $logfile
            echo "Full Backup Failed!!: `date`" >> $logfile
            return 1
        fi

}


incremental() {
    cd ${dir}
    incdir=`date +%Y-%m-%d-%H:%M:%S`-inc
    mkdir $incdir
    LAST_CHECKPOINT=`awk '/to_lsn/{print $3}' ${dir}/xtrabackup_checkpoints 2>/dev/null`
    if [ ! -e "${dir}/xtrabackup_checkpoints" ]; then
       echo "error: xtrabackup_checkpoints does not exist!!" > $logfile
       exit 1
    fi
    xtrabackup  --throttle=$IOPS --use-memory=$USE_MEM  --host=$HOST \
    --user=$user --password=$pass --backup --incremental-lsn=$LAST_CHECKPOINT --extra-lsndir=$dir/$incdir \
    --stream=xbstream --target-dir=$dir/$incdir 2>$logfile | gzip - > $dir/$incdir/${incdir}.gz
    RETVAL=$?
    if [[ $RETVAL == 0 ]] && [[ `tail -50 "${logfile}" | egrep -ic "\berror\b|\bfailed\b"` == 0 ]]; then
       rm -f ${dir}/xtrabackup_* && mv ${dir}/${incdir}/xtrabackup_* ${dir}/ 
       echo "MySql Incremental Backup Success: $(date)" >> $logfile
    else
       echo "MySql Incremental Backup Failure: $(date)" >> $logfile
    fi   
}

if [ `date +%u` -eq 1 ]; then
   full_backup
   if [ $? -eq 0 ];then
     find $dir -maxdepth 1 -type d -mtime +13 -exec rm -rf {} \;
   fi
else   
   if ! ls $dir |grep  -q base; then
     full_backup
  else
     incremental
  fi
fi
