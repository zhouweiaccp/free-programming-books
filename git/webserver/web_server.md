## 一 web服务器概念

Web服务器主要用来提供网络上信息浏览服务。目前， Linux 和 Windows Server 操作系统是搭建 Web 服务器最为常见的系统 。

## 二 常见web服务器

- Apache服务器: 目前占有率最大的web服务器。以进程为基础的结构，开支消耗很大，在多处理器环境中性能会有所下降，所以扩容Apache站点时常见的做法是增加服务器、扩充集群而不是增加处理器
- Tomcat: 专门用于Java的JSP和Servlet的轻量级服务器软件，使用配置规范，但是对静态文件、高并发处理较弱
- IIS: windows上常见的web服务器
- Nginx: 最初是为了解决C10K问题，拥有高性能、支持高并发特点，是目前最火热的web服务器。

C10K问题：最初的服务器是基于进程/线程模型，新到来一个TCP连接，就需要分配一个进程。假如有C10K，就需要创建1W个进程，单机必定是无法承受的。  


## nginx 优化
https://github.com/zhengwen09/database-profiler



## 插件
* [nginx-waf](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginx-waf/) Protect against Layer 7 attacks such as SQLi, XSS, CSRF, LFI, RFI, and more. The NGINX web application firewall (WAF) is built on ModSecurity 3.0.  [ngx_lua_waf](https://www.cnblogs.com/Template/p/9668305.html)