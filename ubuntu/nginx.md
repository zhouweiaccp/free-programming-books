
学习地址
https://github.com/fcambus/nginx-resources
https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-cookbook

https://github.com/magenx/Magento-nginx-config/blob/master/magento-proxy_pass/nginx.conf  demo

https://github.com/angristan/nginx-autoinstall  安装脚本

安装
ubuntu16.04
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
deb http://nginx.org/packages/ubuntu/ xenial nginx
deb-src http://nginx.org/packages/ubuntu/ xenial nginx
apt-get update
apt-get install nginx
systemctl start nginx
systemctl status nginx
systemctl stop nginx

nginx -t #配置
nginx -s reload 加载配置
nginx -s start

https://www.cnblogs.com/zhuxiangru/p/9414038.html

apt install gazebo7
apt-get install libpcre3 libpcre3-dev zlib1g-dev libssl-dev build-essential
wget http://www.openssl.org/source/openssl-1.0.2a.tar.gz

 tar -zxvf openssl-1.0.2a.tar.gz -C /usr/local/src/

cd /usr/local/src/openssl-1.0.2a/

 ./config
 make && sudo make install
 https://www.cnblogs.com/chrisDuan/p/4499731.html




