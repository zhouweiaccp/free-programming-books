Nginx是一个很高效稳定的软负载均衡器，最新的版本可以负载均衡HTTP(s),TCP,UDP等多种协议的链接。一般访问量比较大一点的Web站点都会用NGINX做HTTP协议的Web负载均衡，其后端一般是多个PHP或者JAVA中间件。另外NGINX还可以和Keepalived配合防止均衡器的单点故障，这一点要强于F5，A10这一类的硬件负载均衡设备。

但是F5，A10等硬件负载均衡器虽然价格昂贵但是仍然很有市场，其中原因之一就是硬件负载均衡器比Nginx配置简单，具备图形化界面，有图形化的实时监测界面（收费版的Nginx Plux也有这个功能，但是价格更加昂贵）。但是最重要的一点，就是硬件负载均衡器有成熟的会话保持措施，这一点是Nginx的弱点。

一般来说，我们在java中都通过如下代码进行用户登录后的服务端注册，并且在用户下次请求时无需再登陆一遍，这就是Servlet的Session

HttpSession session = request.getSession(false); 
session.setAttribute("data", data);
session.getAttribute("data"); 

使用了这种Session策略，那么Web容器比如tomcat就为当前用户生成一个SessionID，并且以这个SessionID为索引，存储这个用户相关的键值对，比如用户名，登陆时间一类的。存储在服务器的内存中。同时再response里向用户浏览器中设置一个cookie，这个cookie的名字为jsessionid，内容为服务器生成的随机数SessionID。在用户第二次请求时，将这个cookie发给服务器，服务器根据这个SessionID到内存中寻找相关数据，把用户名什么的提取出来，服务器就可以在本来无状态的HTTP连接中识别出这是哪个客户发出的请求，然后绘制相关页面。



这中Session机制使用简单方便，被使用了很长时间。但是一旦做成集群，这种方式就不灵了。以NGINX默认的轮询方式为例，用户在A服务器上登陆成功，SessionID和用户名等相关信息写入了A服务器的内存中，该用户第二次请求时被NGINX分发到了B服务器，而B服务器没用该用户的SessionID和用户名等相关信息，于是要求用户再登陆一遍。用户第二次登陆之后发送第三次请求，被NGINX分配到了A或者C服务器，于是用户又必须登陆一遍，总之这个用户一直没法登陆成功。



所以使用NGINX默认的轮询（round-robin）方式是没法做到会话保持的，如果你硬要再这种情况下做会话保持，那么就不能使用Servlet中HttpSession这个方案了。一般有如下两种方式可以选择

1、数据库存储Session。

与Servlet Session不同的是，现在SessionID和用户信息不放到服务器内存中，而放到数据库中让所有节点都可以访问。setAttribute()变成iSQL nsert语句，getAttribute()变成SQL select语句，主键就是jsessionid这个cookie的值，这样就实现了Session的共享。但是一般不推荐这样做，因为这样会给数据库带来大量的读写请求，应用服务器是负载均衡了，可是数据库这样搞就炸了，所以避免这样搞。

2、Redis，Memcached存储Session

这个的原理和数据库存储是一样的，因为你完全可以把Redis和Memcached看成一种数据库，只不过由于Redis和Memcached是把数据存放到内存中，一般不做持久化，所以IO速度要快于普通数据库，并且Redis比较容易做集群，可以防止单点故障。是目前比较流行的一种方法。同上面一样，setAttribute()变成了put语句，getAttribute()变成了get语句。另外Redis对于JAVA支持比较好，更推荐使用Redis，Memcached在PHP中有官方的支持，比JAVA中好用。



上面的方式虽然解决了集群的问题，但是如果要从F5迁移到NGINX，那么成本是很高的，因为要重写相关的代码，还要搭建Redis服务器等等，对于一开始没有考虑到集群的项目是很难做的。

那么NGINX官方对于这种情况的解决方案是什么呢？请看下面

Session persistence
Please note that with round-robin or least-connected load balancing, each subsequent client’s request can be potentially distributed to a different server. There is no guarantee that the same client will be always directed to the same server. 
If there is the need to tie a client to a particular application server — in other words, make the client’s session “sticky” or “persistent” in terms of always trying to select a particular server — the ip-hash load balancing mechanism can be used. 
With ip-hash, the client’s IP address is used as a hashing key to determine what server in a server group should be selected for the client’s requests. This method ensures that the requests from the same client will always be directed to the same server except when this server is unavailable. 
To configure ip-hash load balancing, just add the ip_hash directive to the server (upstream) group configuration: 
upstream myapp1 {
    ip_hash;
    server srv1.example.com;
    server srv2.example.com;
    server srv3.example.com;
}
以上出自：http://nginx.org/en/docs/http/load_balancing.html
方法很简单，就是NGINX根据请求源的IP，固定的分配到某个地址上去，这样保证同一个IP多次分配都是同一台服务器，这样就不用考虑共享Session的问题了。可是这种解决方案是一种非常不负责任的方案。首先这样做必须确保NGINX是放在公网上的，且NGINX前面不能有其他的代理服务器，这样才能保证NGINX能够获得用户真实的IP。但是如果NGINX前面还有squid这种代理或者前面还有一个NGINX的话，那么当前NGINX收到的就是上一级代理的IP，所有IP都一个样，所以最后只有1台后端服务器被利用，根本没有做到负载均衡的要求。

即使退一步，NGINX确实是放在公网上的第一级代理，那么根据我国目前的网络状况，有很多学校，公司企业他们公网出口就一个IP。也就是近千人共用一个IP访问公网的情况非常普遍。而这正好又是一个学生选课系统或者办公系统的话，那么NGINX还是没有起到负载均衡的作用，顶多能发挥高可用的功能。

那么对于这种实际生产中碰到的问题，用NGINX应该如何解决呢。我们首先可以看一下F5是如何解决这样问题的。、



F5支持什么样的会话保持方法？
    F5 Big-IP支持多种的会话保持方法，其中包括：简单会话保持（源地址会话保持）、HTTP Header的会话保持，基于SSL Session ID的会话保持，i-Rules会话保持以及基于HTTP Cookie的会话保持，此外还有基于SIP ID以及Cache设备的会话保持等，但常用的是简单会话保持，HTTP Header的会话保持以及 HTTP Cookie会话保持以及基于i-Rules的会话保持。

2.1 简单会话保持
    简单会话保持也被称为基于源地址的会话保持，是指负载均衡器在作负载均衡时是根据访问请求的源地址作为判断关连会话的依据。对来自同一IP地址的所有访问 请求在作负载均时都会被保持到一台服务器上去。在BIG-IP设备上可以为“同一IP地址”通过网络掩码进行区分，比如可以通过对IP地址 192.168.1.1进行255.255.255.0的网络掩码，这样只要是来自于192.168.1.0/24这个网段的流量BIGIP都可以认为他 们是来自于同一个用户，这样就将把来自于192.168.1.0/24网段的流量会话保持到特定的一台服务器上。


    简单会话保持里另外一个很重要的参数就是连接超时值，BIGIP会为每一个进行会话保持的会话设定一个时间值，当一个会话上一次完成到这个会话下次再来之 前的间隔如果小于这个超时值，BIGIP将会将新的连接进行会话保持，但如果这个间隔大于该超时值，BIGIP将会将新来的连接认为是新的会话然后进行负 载平衡。


    基于原地址的会话保持实现起来简单，只需要根据数据包三、四层的信息就可以实现，效率也比较高。存在的问题就在于当多个客户是通过代理或地址转换的方式来 访问服务器时，由于都分配到同一台服务器上，会导致服务器之间的负载严重失衡。另外一种情况上客户机数量很少，但每个客户机都会产生多个并发访问，对这些 并发访问也要求通过负载均衡器分配到多个服器上，这时基于客户端源地址的会话保持方法也会导致负载均衡失效。


2.2 基于Cookie的会话保持
2.2.1 Cookie插入模式：
    在Cookie插入模式下，Big-IP将负责插入cookie，后端服务器无需作出任何修改


    当客户进行第一次请求时，客户HTTP请求（不带cookie）进入BIG-IP， BIG-IP根据负载平衡算法策略选择后端一台服务器，并将请求发送至该服务器，后端服务器进行HTTP回复（不带cookie）被发回BIGIP，然后 BIG-IP插入cookie，将HTTP回复返回到客户端。当客户请求再次发生时，客户HTTP请求（带有上次BIGIP插入的cookie）进入 BIGIP，然后BIGIP读出cookie里的会话保持数值，将HTTP请求（带有与上面同样的cookie）发到指定的服务器，然后后端服务器进行请 求回复，由于服务器并不写入cookie，HTTP回复将不带有cookie，恢复流量再次经过进入BIG-IP时，BIG-IP再次写入更新后的会话保 持 cookie。

2.2.2 Cookie 重写模式
    当客户进行第一次请求时，客户HTTP请求（不带cookie）进入BIGIP， BIGIP根据负载均衡算法策略选择后端一台服务器，并将请求发送至该服务器，后端服务器进行HTTP回复一个空白的cookie并发回BIGIP，然后 BIGIP重新在cookie里写入会话保持数值，将HTTP回复返回到客户端。当客户请求再次发生时，客户HTTP请求（带有上次BIGIP重写的 cookie）进入BIGIP，然后BIGIP读出cookie里的会话保持数值，将HTTP请求（带有与上面同样的cookie）发到指定的服务器，然 后后端服务器进行请求回复，HTTP回复里又将带有空的cookie，恢复流量再次经过进入BIGIP时，BIGIP再次写入更新后会话保持数值到该 cookie。

2.2.3 Passive Cookie 模式，服务器使用特定信息来设置cookie。
    当客户进行第一次请求时，客户HTTP请求（不带cookie）进入BIGIP， BIGIP根据负载平衡算法策略选择后端一台服务器，并将请求发送至该服务器，后端服务器进行HTTP回复一个cookie并发回BIGIP，然后 BIGIP将带有服务器写的cookie值的HTTP回复返回到客户端。当客户请求再次发生时，客户HTTP请求（带有上次服务器写的cookie）进入 BIGIP，然后BIGIP根据cookie里的会话保持数值，将HTTP请求（带有与上面同样的cookie）发到指定的服务器，然后后端服务器进行请 求回复，HTTP回复里又将带有更新的会话保持cookie，恢复流量再次经过进入BIGIP时，BIGIP将带有该cookie的请求回复给客户端。

2.2.4 Cookie Hash模式：
    当客户进行第一次请求时，客户HTTP请求（不带cookie）进入BIGIP， BIGIP根据负载均衡算法策略选择后端一台服务器，并将请求发送至该服务器，后端服务器进行HTTP回复一个cookie并发回BIGIP，然后 BIGIP将带有服务器写的cookie值的HTTP回复返回到客户端。当客户请求再次发生时，客户HTTP请求（带有上次服务器写的cookie）进入 BIGIP，然后BIGIP根据cookie里的一定的某个字节的字节数来决定后台服务器接受请求，将HTTP请求（带有与上面同样的cookie）发到 指定的服务器，然后后端服务器进行请求回复，HTTP回复里又将带有更新后的cookie，恢复流量再次经过进入BIGIP时，BIGIP将带有该 cookie的请求回复给客户端。

2.3 SSL Session ID会话保持
    在用户的SSL访问系统的环境里，当SSL对话首次建立时，用户与服务器进行首次信息交换以：1}交换安全证书，2）商议加密和压缩方法，3）为每条对话 建立Session ID。由于该Session ID在系统中是一个唯一数值，由此，BIGIP可以应用该数值来进行会话保持。当用户想与该服务器再次建立连接时，BIGIP可以通过会话中的 SSL Session ID识别该用户并进行会话保持。


    基于SSL Session ID的会话保持就需要客户浏览器在进行会话的过程中始终保持其SSL Session ID不变，但实际上，微软Internet Explorer被发现在经过特定一段时间后将主动改变SSL Session ID，这就使基于SSL Session ID的会话保持实际应用范围大大缩小。


从F5的会话保持方法中获得启发，2.2.1的Cookie插入模式是使用最普遍也最简单的一种方式。如果NGINX也能实现相同的功能，为每个用户插入一个Cookie，再根据这个Cookie选择相应的负载均衡服务器的话，哪怕再多人公用一个IP也不害怕了。

可惜，NGINX官方并没有给出这样一个功能。那么目前有下面三种方案：



1、使用第三方模块nginx-sticky-module-ng

在这里你可以看到相关的说明：https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/overview

由于是第三方模块，所以需要重新编译你的NGINX，首先下载nginx-sticky-module-ng的源码，下载地址：https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/downloads/

然后解压出源码，使用--add-module 加源码路径添加这个模块，如下

./configure ... --add-module=/absolute/path/to/nginx-sticky-module-ng
make
make install

然后在你nginx配置文件的upstream片段中，去掉ip_hash等策略，加上sticky，如下

upstream {
  sticky;
  server 127.0.0.1:9000;
  server 127.0.0.1:9001;
  server 127.0.0.1:9002;
}

其中sticky后面还可以跟参数，比如

sticky expires=1h domain=toxingwang.com path=/; 

参数的意义如下
sticky [name=route] [domain=.foo.bar] [path=/] [expires=1h] [hash=index|md5|sha1] [no_fallback];  
name: 可以为任何的string字符,默认是route  
domain：哪些域名下可以使用这个cookie  
path：哪些路径对启用sticky,例如path/test,那么只有test这个目录才会使用sticky做负载均衡  
expires：cookie过期时间，默认浏览器关闭就过期，也就是会话方式。  
no_fallbackup：如果设置了这个，cookie对应的服务器宕机了，那么将会返回502（bad gateway 或者 proxy error），建议不启用
配置好之后，当upstream模块中有一个一上的server时，就可以在chrome中看到nginx添加的这个cookie（如果upstream里只有一个服务器是不行的）





2、使用第三方NGINX——tengine

tengine是腾讯在nginx基础上开发的一个nginx分支，开发很活跃，更新频繁，可以作为替代NGINX的很好的方案，目前最新版本2.2.1。sticky模块的说明地址是：

http://tengine.taobao.org/document_cn/http_upstream_session_sticky_cn.html

用法和NGINX有一些区别，如下

# 默认配置：cookie=route mode=insert fallback=on
upstream foo {
server 192.168.0.1;
server 192.168.0.2;
session_sticky;
}
server {
location / {
proxy_pass http://foo;
}
}

在tengine中，sticky变成了session_sticky,并且后面的参数也有了一些变化，具体请看上面的链接。



3、使用cookie的HASH来区分同一个用户的不同链接。

上面两个方案都用到了第三方的模块，那么如果不想用第三方模块可不可以实现呢，也是可以的，但是只有对登陆用户有效。

前面我们已经知道了如果使用Servlet Session的话，Web容器会自动的在用户浏览器上建立名为jsessionid的cookie，并且值就是服务器端的SessionID。另一方面，新版的NGINX不光可以通过IP的hash来分发流量，也可以通过url的hash，cookie的hash，header的hash等等进行链接的固定分配。由于用户登陆成功以后名为jsessionid的cookie就有了一个短期固定的值，而且每个用户都不一样，那么我们就可以根据这个sessionid的hash值为它分配一个服务器。在当前sessionID起作用的时候那么分配的服务器也是同一个，并且不需要安装第三方的插件，方法如下

upstream backend {
    ...
    hash        $cookie_jsessionid;

}


在NGINX 1.7.2版本之前，这也是一个第三方模块，名为nginx_upstream_hash，它目前的源码地址：https://github.com/evanmiller/nginx_upstream_hash

在NGINX 1.7.2及之后，这成为了一个内置功能，而且默认就被编译进去了，所以我们可以很方便的使用它了，官方说明地址:http://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash，我把它摘出来放在下面

Syntax:	hash key [consistent];
Default:	—
Context:	upstream
This directive appeared in version 1.7.2.

Specifies a load balancing method for a server group where the client-server mapping is based on the hashed key value. The key can contain text, variables, and their combinations. Note that adding or removing a server from the group may result in remapping most of the keys to different servers. The method is compatible with the Cache::Memcached Perl library.

If the consistent parameter is specified the ketama consistent hashing method will be used instead. The method ensures that only a few keys will be remapped to different servers when a server is added to or removed from the group. This helps to achieve a higher cache hit ratio for caching servers. The method is compatible with the Cache::Memcached::Fast Perl library with the ketama_points parameter set to 160.



4、使用Http Header区分不同用户。

上面的方法中，不论F5还是NGINX的sticky模块都是根据cookie区分用户的。但是有些情况下无法使用cookie，比如客户端浏览器禁用的cookie，Android，IOS等移动端调用的HTTP API接口等。现在比较常用的做法是把SessionID，有的也喜欢叫做token，放在请求的URL或者请求参数中，比如下面这样

http://example.com/user.jsp?token=nv3e0n382nv83sk2

那么没有cookie如何区分用户呢，这种情况下虽然不能使用cookie，但是header是可以使用的，我们可以把token或者sessionID放到header中，然后对该header的值进行hash，并固定分配一个服务器。配置文件的写法如下

hash $http_你设置的header名称;

大多数的反向代理软件都会把它收到的请求源的IP记录在x_forwarded_for这个header中，所以一个客户总是拥有一个唯一的x_forwarded_for头不会变化，所以我们也可以对这个Header进行hash,效果就是根据IP地址进行分流是一样的。
hash $http_x_forwarded_for;


如果你的上级也是NGINX,那么应该按照如下配置
location / {
proxy_pass http://localhost:8000;
 
proxy_set_header X-Real-IP $remote_addr;
# needed for HTTPS
# proxy_set_header X_FORWARDED_PROTO https;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Host $host;
proxy_redirect off;
}


这种通过header的hash来分配服务器是Caddy官方主推的,在caddy中配置如下
proxy / web1.local:80 web2.local:90 web3.local:100
{
	policy header X-My-Header
}

官网文档地址：
https://caddyserver.com/docs/proxy


————————————————
版权声明：本文为CSDN博主「lvshaorong」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/lvshaorong/article/details/78309514