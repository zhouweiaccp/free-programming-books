#!/bin/bash
d=`date '+%Y%m%d%H%M%S'`
id="d58ac9104f12"
echo $d
#`docker ps |grep zhouwei | grep mysql|awk '{print $1}'`
echo $id
#docker exec ${id} sh 'rm /home/org_user.txt'

cat > 1sql.sh << efo 
echo 'start exec sql...'

if [ ! -f /home/org_user.txt ];then
rm -f /home/org_user.txt
fi

mysql -hlocalhost -uuser -p1qaz2WSX -e "
use edoc2v5;
select user_account from org_user;
" >>/home/${d}
efo

echo 'copy ...'
docker cp 1sql.sh ${id}:/home/
echo 'exec ..'
docker exec  $id sh '/home/1sql.sh'
echo 'export....'
docker cp ${id}:/home/${d} ${id}_${d}org_user.txt
echo file ${id}_${d}org_user.txt
cat  ${id}_${d}org_user.txt
