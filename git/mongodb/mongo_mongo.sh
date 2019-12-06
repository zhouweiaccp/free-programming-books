#//删除数据
id=`docker ps |grep mongo |awk '{print $1}'`
echo ${id}
docker cp  /opt/deldata.js ${id}:/usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/
#docker exec -it ${id} bash 
docker exec  ${id}  /usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/mongo localhost:27017/local /usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/deldata.js

#./bin/mongo local
#load('/usr/local/mongodb/mongodb-linux-x86_64-debian81-3.4.10/bin/a.js')


# ：
