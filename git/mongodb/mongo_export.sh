#// 备份指定月份数据，并导出
id=`docker ps |grep mongo |awk '{print $1}'`
date1=`date '+%Y%m%d%H%M%S'`
echo ${id}
docker cp  /opt/monggoexport.js ${id}:/usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/
docker exec  ${id}  /usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/mongo localhost:27017/local /usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/monggoexport.js
#docker exec -it ${id} bash 
docker exec  ${id}  /usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/mongoexport -h localhost -d local -c LogOperationDataEntitynew -o output1.js

docker cp   ${id}:/usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/output1.js /opt/output1_${date1}.js
dir -al
#docker exec -it ${id} bash
