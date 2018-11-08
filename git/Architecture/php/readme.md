
http://doc.swoft.org/  https://github.com/swoft-cloud/swoft
首个基于 Swoole 原生协程的新时代 PHP 高性能协程全栈框架，内置协程网络服务器及常用的协程客户端，常驻内存，不依赖传统的 PHP-FPM，全异步非阻塞 IO 实现，以类似于同步客户端的写法实现异步客户端的使用，没有复杂的异步回调，没有繁琐的 yield, 有类似 Go 语言的协程、灵活的注解、强大的全局依赖注入容器、完善的服务治理、灵活强大的 AOP、标准的 PSR 规范实现等等，可以用于构建高性能的Web系统、API、中间件、基础服务等等。

基于 Swoole 扩展
内置协程网络服务器
WebSocket 服务器
MVC 分层设计
高性能路由
强大的 AOP (面向切面编程)
灵活的注解功能
全局的依赖注入容器
基于 PSR-7 的 HTTP 消息实现
基于 PSR-11 的容器规范实现
基于 PSR-14 的事件管理器
基于 PSR-15 的中间件
基于 PSR-16 的缓存设计
可扩展的高性能 RPC
RESTful 支持
国际化(i18n)支持
快速灵活的参数验证器
完善的服务治理，熔断、降级、负载、注册与发现
通用连接池 Mysql、Redis、RPC
数据库 ORM
协程、异步任务投递
自定义用户进程
协程和同步阻塞客户端无缝自动切换
别名机制
跨平台热更新自动 Reload
强大的日志系统

PHP的协程高性能网络通信引擎，使用C/C++语言编写，提供了PHP语言的异步多线程服务器，异步TCP/UDP网络客户端，异步MySQL，异步Redis，数据库连接池，AsyncTask，消息队列，毫秒定时器，异步文件读写，异步DNS查询。 Swoole内置了Http/WebSocket服务器端/客户端、Http2.0服务器端/客户端。

Swoole底层内置了异步非阻塞、多线程的网络IO服务器。PHP程序员仅需处理事件回调即可，无需关心底层。与Nginx/Tornado/Node.js等全异步的框架不同，Swoole既支持全异步，也支持同步。

除了异步IO的支持之外，Swoole为PHP多进程的模式设计了多个并发数据结构和IPC通信机制，可以大大简化多进程并发编程的工作。其中包括了并发原子计数器，并发HashTable，Channel，Lock，进程间通信IPC等丰富的功能特性。

Swoole从2.0版本开始支持了内置协程，可以使用完全同步的代码实现异步程序。PHP代码无需额外增加任何关键词，底层自动进行协程调度，实现异步。

Swoole可以广泛应用于互联网、移动通信、企业软件、网络游戏、物联网、车联网、智能家庭等领域。 使用PHP+Swoole作为网络通信框架，可以使企业IT研发团队的效率大大提升，更加专注于开发创新产品。

Swoole是开源免费的自由软件，授权协议是Apache2.0。企业和个人开发者均可免费使用Swoole的代码，并且在Swoole之上所作的修改可用于商业产品，无需开源（注：必须保留原作者的版权声明）。

1.8.7或更高版本已完全兼容PHP7
2.0.12版本开始不再支持PHP5

开发工具
Swoole 4.X 速查表 https://toxmc.github.io/swoole-cs.github.io/
IDE自动提示工具(自动生成版) ：https://github.com/swoole/ide-helper
国内Git镜像：https://gitee.com/swoole/swoole
全量markdown文档： https://github.com/swoole/swoole-wiki
新手入门教程：https://www.gitbook.com/book/linkeddestiny/easy-swoole/details
IDE自动提示工具(手动版) swoole-ide-helper：https://github.com/eaglewu/swoole-ide-helper
HHVM-Swoole：https://github.com/swoole/hhvm-swoole
C++-Swoole：https://github.com/swoole/cpp-swoole
Swoole-Docset: https://github.com/halfstring/swoole-chinese-docset
https://github.com/swoole/swoole-src/