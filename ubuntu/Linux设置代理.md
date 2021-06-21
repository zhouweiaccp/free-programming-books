一、wget下的代理设置
1、临时生效
set "http_proxy=http://[user]:[pass]@host:port/"
或
export "http_proxy=http://[user]:[pass]@host:port/" 
执行完，就可以在当前shell 下使用wget程序了。

2、使用wget参数
wget -e "http_proxy=http://[user]:[pass]@host:port/" http://baidu.com
3、当前用户永久生效
创建$HOME/.wgetrc文件，加入以下内容：

http_proxy=代理主机IP:端口 
配置完后，就可以通过代理wget下载包了。

注：如果使用ftp代理，将http_proxy 改为ftp_proxy 即可。

二、lftp下代理设置
使lftp可以通过代理上网，可以做如下配置

echo "export http_proxy=proxy.361way.com:8888" > ~/.lftp
三、yum设置
编辑/etc/yum.conf文件，按如下配置

proxy=http://yourproxy:8080/      #匿名代理
proxy=http://username:password@yourproxy:8080/   #需验证代理
四、全局代理配置
编辑/etc/profile 或~/.bash_profile ，增加如下内容：

http_proxy=proxy.361way.com:8080
https_proxy=proxy.361way.com:8080
ftp_proxy=proxy.361way.com:8080
export http_proxy https_proxy ftp_proxy 

##  /etc/apt/apt.conf
http_proxy=proxy.361way.com:8080