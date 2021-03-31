关于统计API调用次数,一直都没有比较通用的方案,那么今天我来给一个解决方案,从应用层解决,不需要开发人员去做(即使去做也不一定比这个好,别觉得哥狂妄).好了也不屁话这么多,开正题了.
https://my.oschina.net/MasterXimen/blog/2996579

ngx_dynamic_limit_req_module还是需要这个模块
cd redis-4.0**version**/deps/hiredis
make 
make install 


git clone https://github.com/limithit/ngx_dynamic_limit_req_module.git
cd ngx_dynamic_limit_req_module
git checkout limithit-API_alerts
./configure --add-module=/path/to/this/ngx_dynamic_limit_req_module 
make
make install

配置参考:
worker_processes  2;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    
    dynamic_limit_req_zone $binary_remote_addr zone=one:10m rate=100r/s redis=127.0.0.1 block_second=300;
    
    server {
        listen       80;
        server_name  localhost;
        location / {
            if ($document_uri ~* "index.html"){
             dynamic_limit_req zone=one burst=100 nodelay;
            dynamic_limit_req_status 403;
                 }
				 if ($document_uri ~* "about.html"){
                dynamic_limit_req zone=one burst=30 nodelay mail_to=123@qq.com api_max=20;  #mail_to是要通知邮箱 api_max是当请求达到20次以上就发邮件通知5分钟内只发一次
                dynamic_limit_req_status 405;
                 }
            root   html;
            index  index.html index.htm;
           
        }
        error_page   403 500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }

}
其实邮箱是选填的,不需要通知的话就不用填,如果需要全局记录的话,不需要加筛选条件document_uri 

 server {
        listen       80;
        server_name  localhost;
        location / {
            dynamic_limit_req zone=one burst=100 nodelay;
            dynamic_limit_req_status 403;
                 
				
            root   html;
            index  index.html index.htm;
           
        }
        error_page   403 500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
0x2

会按天记录每天PV,UV,AllCount是每个域名的全部请求以及每个页面的请求次数,这取决于你的筛选条件



 

0x3

大概有人会问redis能存多少个key呢又会占用多少内存呢,根据官方的描述是100万个key 大概85MB的内存

Redis最多可以处理2 ^32键，并且在实践中经过测试，每个实例至少处理2.5亿个键。

每个哈希，列表，集和排序集可以容纳2 ^32个元素。

换句话说，您的限制可能是系统中的可用内存。

所以不必但心数据日渐增多的困扰