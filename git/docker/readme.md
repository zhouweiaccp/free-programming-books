## 常见问题
- [客户端ip](https://github.com/banianhost/remux/blob/master/app/nginx.conf#L57)  https://github.com/moby/moby/issues/32575  http://fengyilin.iteye.com/blog/2401156


## 常用命令
apt-get update 
apt install net-tools # ifconfig  netstat
apt install iputils-ping # ping
apt-get install inetutils-ping

 1查找docker的进程号 ：
docker inspect -f '{{.State.Pid}}' 49b98b2fbad2
2. 查看连接： 
nsenter -t 1840 -n netstat |grep ESTABLISHED
