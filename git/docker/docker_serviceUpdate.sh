
set -x 
id=`docker service ls |grep _orgsync |awk '{print $1}'`
echo $id
read -p "Please enter your image: " im
#docker service update --force --image 192.168.251.78/edoc2v5/orgsync:20200427003 --replicas=1 zhou_orgsync
docker service update --force --image $im --replicas=1 $id 

