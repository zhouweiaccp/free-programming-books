
## 服务端
安装执行： rpm -ivh iperf3-3.1.3-1.fc24.x86_64.rpm
iperf3 -s -p 80   #执行此命令进行监听


## window客户端 测试   #ip更换为服务端IP，测试时间为60秒
.\iperf3.exe -c 47.101.165.38 -p 80 -t 60



## linux 测试   #ip更换为服务端IP，测试时间为60秒
iperf3.exe -c 47.101.165.38 -p 80 -t 60