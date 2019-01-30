


cp 从容器里面拷文件到宿主机
docker cp 942377f48ede:/etc/hostname d:/hostname.txt
从宿主机拷文件到容器里面
docker cp d:/ip.txt 942377f48ede:/etc

docker save和docker export的区别
总结一下docker save和docker export的区别：

docker save保存的是镜像（image），docker export保存的是容器（container）；
docker load用来载入镜像包，docker import用来载入容器包，但两者都会恢复为镜像；
docker load不能对载入的镜像重命名，而docker import可以为镜像指定新名称。


docker save -o images.tar postgres:9.6 mongo:3.4     docker load -i images.tar
docker export -o postgres-export.tar postgres docker import postgres-export.tar postgres:latest