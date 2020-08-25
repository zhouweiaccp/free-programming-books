https://www.cnblogs.com/lsgxeva/p/11275465.html
HSTS部署
服务器开启HSTS的方法是：当客户端通过HTTPS发出请求时，在服务器返回的超文本传输协议响应头中包含Strict-Transport-Security字段。非加密传输时设置的HSTS字段无效。

最佳的部署方案是部署在离用户最近的位置，例如：架构有前端反向代理和后端Web服务器，在前端代理处配置HSTS是最好的，否则就需要在Web服务器层配置HSTS。如果Web服务器不明确支持HSTS，可以通过增加响应头的机制。如果其他方法都失败了，可以在应用程序层增加HSTS。

HSTS启用比较简单，只需在相应头中加上如下信息：

Strict-Transport-Security: max-age=63072000; includeSubdomains;preload;
Strict-Transport-Security是Header字段名，max-age代表HSTS在客户端的生效时间。 includeSubdomains表示对所有子域名生效。preload是使用浏览器内置的域名列表。

HSTS策略只能在HTTPS响应中进行设置，网站必须使用默认的443端口；必须使用域名，不能是IP。因此需要把HTTP重定向到HTTPS，如果明文响应中允许设置HSTS头，中间人攻击者就可以通过在普通站点中注入HSTS信息来执行DoS攻击。

Apache上启用HSTS
$ vim /etc/apache2/sites-available/hi-linux.conf

# 开启HSTS需要启用headers模块
LoadModule headers_module /usr/lib/apache2/modules/mod_headers.so

<VirtualHost *:80>
  ServerName www.hi-linux.com
  ServerAlias hi-linux.com
...
 #将所有访问者重定向到HTTPS,解决HSTS首次访问问题。
  RedirectPermanent / https://www.hi-linux.com/
</VirtualHost>

<VirtualHost 0.0.0.0:443>
...
# 启用HTTP严格传输安全
  Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains; preload"
...
</VirtualHost>
重启Apache服务

$ service apche2 restart
Nginx上启用HSTS
$ vim /etc/nginx/conf.d/hi-linux.conf

server {
   listen 443 ssl;
   server_name www.hi-linux.com;
   add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
...
}

server {
   listen 80;
   server_name www.hi-linux.com;
   return 301 https://www.hi-linux.com$request_uri;
...
}
重启Nginx服务

$ service nginx restart
IIS启用HSTS
要在IIS上启用HSTS需要用到第三方模块，具体可参考：https://hstsiis.codeplex.com/

测试设置是否成功
设置完成了后，可以用curl命令验证下是否设置成功。如果出来的结果中含有Strict-Transport-Security的字段，那么说明设置成功了。

$ curl -I https://www.hi-linux.com
HTTP/1.1 200 OK
Server: nginx
Date: Sat, 27 May 2017 03:52:19 GMT
Content-Type: text/html; charset=utf-8
...
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
...
对于HSTS以及HSTS Preload List，建议是只要不能确保永远提供HTTPS服务，就不要启用。因为一旦HSTS生效，之前的老用户在max-age过期前都会重定向到HTTPS，造成网站不能正确访问。唯一的办法是换新域名。

参考文档
 
http://t.cn/RSzfyBb
https://yuan.ga/hsts-strict-https-enabled-site/
https://imququ.com/post/sth-about-switch-to-https.html
http://www.ttlsa.com/web/hsts-for-nginx-apache-lighttpd/
http://www.jianshu.com/p/66ddc3124006

 

如何关闭浏览器的HSTS功能
来源  http://www.tuicool.com/articles/QbYBne

在安装配置 SSL 证书时，可以使用一种能使数据传输更加安全的Web安全协议，即在服务器端上开启 HSTS (HTTP Strict Transport Security)。它告诉浏览器只能通过HTTPS访问，而绝对禁止HTTP方式。 

HTTP Strict Transport Security (HSTS) is an opt-in security enhancement that is specified by a web application through the use of a special response header. Once a supported browser receives this header that browser will prevent any communications from being sent over HTTP to the specified domain and will instead send all communications over HTTPS. It also prevents HTTPS click through prompts on browsers.

但是，在日常开发的过程中，有时我们会想测试页面在 HTTP 连接中的表现情况，这时 HSTS 的存在会让调试不能方便的进行下去。而且由于 HSTS 并不是像 cookie 一样存放在浏览器缓存里，简单的清空浏览器缓存操作并没有什么效果，页面依然通过 HTTPS 的方式传输。  那么怎样才能关闭浏览器的 HSTS 呢，各种谷歌

度娘

之后，在这里汇总一下几大常见浏览器 HSTS 的关闭方法。

Safari 浏览器
完全关闭 Safari
删除 ~/Library/Cookies/HSTS.plist 这个文件
重新打开 Safari 即可
极少数情况下，需要重启系统
Chrome 浏览器
地址栏中输入 chrome://net-internals/#hsts
在 Delete domain 中输入项目的域名，并 Delete 删除
可以在 Query domain 测试是否删除成功
Opera 浏览器
和 Chrome 方法一样

Firefox 浏览器
关闭所有已打开的页面
清空历史记录和缓存
地址栏输入 about:permissions
搜索项目域名，并点击 Forget About This Site
 

 