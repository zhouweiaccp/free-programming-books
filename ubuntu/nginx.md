
学习地址
https://github.com/fcambus/nginx-resources  A collection of resources covering Nginx, Nginx + Lua, OpenResty and Tengin
https://github.com/agile6v/awesome-nginx A curated list of awesome Nginx distributions, 3rd party modules, Active developers
https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-cookbook

https://github.com/magenx/Magento-nginx-config/blob/master/magento-proxy_pass/nginx.conf  demo

https://github.com/angristan/nginx-autoinstall  安装脚本

https://github.com/valentinxxx/nginxconfig.io 用法
https://github.com/jaywcjlove/nginx-tutorial
https://nginx.rails365.net/chapters/2.html

https://github.com/denji/nginx-tuning  配置
https://github.com/vozlt/nginx-module-sysguard  监控nginx
安装
ubuntu16.04
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
vim /etc/apt/sources.list
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

## 资源
 #[nginx-tutorial]( https://github.com:jaywcjlove/nginx-tutorial.git)


 ## demo
 
#禁止Scrapy等爬虫工具的抓取
if ($http_user_agent ~* "Scrapy|Sogou web spider|Baiduspider") {
  return 403;
}
#禁止指定UA及UA为空的访问
if ($http_user_agent ~ "FeedDemon|JikeSpider|Indy Library|Alexa Toolbar|AskTbFXTV|AhrefsBot|CrawlDaddy|CoolpadWebkit|Java|Feedly|UniversalFeedParser|ApacheBench|Microsoft URL Control|Swiftbot|ZmEu|oBot|jaunty|Python-urllib|lightDeckReports Bot|YYSpider|DigExt|YisouSpider|HttpClient|MJ12bot|heritrix|EasouSpider|LinkpadBot|Ezooms|^$" )
{
  return 403;
}
#禁止非GET|HEAD|POST方式的抓取
if ($request_method !~ ^(GET|HEAD|POST)$) {
  return 403;
}
if ($http_user_agent ~ "Mozilla/4.0\ \(compatible;\ MSIE\ 6.0;\ Windows\ NT\ 5.1;\ SV1;\ .NET\ CLR\ 1.1.4322;\ .NET\ CLR\ 2.0.50727\)") { 
   return 404;
}

Nginx也可实现根据访问源的设备类型进行判断并跳转到不同的tomcat或其它项目中

vim /usr/local/nginx/conf/conf.d/mobile.conf

upstream mobileserver {
    server 10.0.10.48:8089 max_fails=3 fail_timeout=60 weight=1;
    server 10.0.10.49:8089 max_fails=3 fail_timeout=60 weight=1;
    server 10.0.10.50:8089 max_fails=3 fail_timeout=60 weight=1;
}
upstream computerserver {
    server 10.0.10.48:8080 max_fails=3 fail_timeout=60 weight=1;
    server 10.0.10.49:8080 max_fails=3 fail_timeout=60 weight=1;
    server 10.0.10.50:8080 max_fails=3 fail_timeout=60 weight=1;
}
server {
    listen       80;
    server_name  house.wjoyxt.com;
    rewrite_log     on;
    if ($request_uri ~ " ") {
         return 444;
    }
    location / {
    #以下三行为重新定义或者添加发往后端服务器的请求头,nginx会在把请求转向后台real-server前把http报头中的ip地址进行替换（在使用反向代理时经常用，目的是为了使后端服务器获取客户端的真实IP地址）
    proxy_set_header Host      $host;           #如果不想改变请求头“Host”的值，可以这样来设置：proxy_set_header Host $http_host;但是，如果客户端请求头中没有携带这个头部，那么传递到后端服务器的请求也不含这个头部。这种情况下，更好的方式是使用$host变量——它的值在请求包含“Host”请求头时为“Host”字段的值，在请求未携带“Host”请求头时为虚拟主机的主域名
    proxy_set_header X-Real-IP $remote_addr;    #把真实的客户端ip发送给后端的web服务器    

    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; #把真实的客户端ip发送给后端的web服务器

    access_log  /data/logs/nginx/mobile.access.log  main;
    error_log  /data/logs/nginx/mobile.error.log;
    
    set $client    "";
    
    #如果是IPhone设备、iPad设备、iPod设备、苹果其它非PC设备、苹果PC设备
         if ( $http_user_agent ~* "(iPhone|iPad|iPod|iOS|Android|Mobile|nokia|samsung|htc|blackberry)") {
            set $client "1";
          }        
        if ($client = '1') {
              proxy_pass http://mobileserver;
              break;
        }
        if (!-f $request_filename) {
              proxy_pass http://computerserver;
               break;
        }
    }
    location ~ \.php$ {
        proxy_pass   http://127.0.0.1;
    }
    location ~* \.(html|shtml|htm|inc|log)$ {
            expires 1m;
    }
    location ~* ^.+\.(jpg|jpeg|gif|swf|mpeg|mpg|mov|flv|asf|wmv|avi|ico)$ {
            expires 15d;
    }

}



