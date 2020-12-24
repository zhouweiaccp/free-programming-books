
# Table of Contents
* [apm](#apm)
* [awesome](#awesmoe)
* [curl](#curl)
* [git](#git)
* [规范](#规范)
* [mysql工具](#mysql工具)
* [mssql数据库文档生成](#mssql数据库文档生成)
* [nuget](#nuget)
* [mirror](#mirror)
* [ftp](#ftp)
* [microservice](#microservice)
* [mongodb工具](#mongodb工具)
* [mock](#mock)
* [redis](#redis)
* [.net工具](#.net工具)
* [nuget](#nuget)
* [sqlite工具](#sqlite工具)
* [内网穿透](#内网穿透)
* [调试工具](#调试工具)
* [团队文档协作](#团队文档协作)
* [原型图](#原型图)
* [window_shell](#window_shell)
* [测试工具](#测试工具)
* [网络测试和抓包](#网络测试和抓包)
* [渗透测试工具](#渗透测试工具)
* [开源浏览器](#开源浏览器)
* [监控系统](#监控系统)
* [服务器](#服务器)
* [手机测试](#手机测试)
* [代理](#代理)
* [下载歌曲](#下载歌曲)
* [下载](#下载)
* [私有同步云盘](#私有同步云盘)
* []()

## apm
* [cat](https://github.com/dianping/cat) -大宗点评网开源
* [pinpoint](https://github.com/naver/pinpoint)
* [incubator-skywalking](https://github.com/apache/incubator-skywalking)  参考https://github.com/JaredTan95/skywalking-docker  https://github.com/OpenSkywalking/skywalking-netcore
* [学习链接](https://cloud.tencent.com/developer/article/1345706)

## curl
* [](https://curl.haxx.se/windows/dl-7.68.0/curl-7.68.0-win64-mingw.zip) https://curl.haxx.se/windows/
* [wget](https://eternallybored.org/misc/wget/)    [https://nchc.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-setup.exe]
* []() 

## git
* [gitolite](https://github.com/sitaramc/gitolite) perl 权限管理
* [gitosis](https://github.com/res0nat0r/gitosis)  python 权限管理
* []() 
* []() 
* []() 


## awesome
* [https://github.com:zhouweiaccp/awesome-dotnet.git](awesome-dotnet)
* [https://github.com:zhouweiaccp/free-programming-books.git](free-programming-books)
* [https://github.com:zhouweiaccp/awesome-javascript.git](awesome-javascript)
* [https://github.com:zhouweiaccp/awesome-dotnet-core.git](awesome-dotnet-core)
* [awesome-github-vue](https://github.com/zhouweiaccp/awesome-github-vue)
* []()


## 规范
* [OpenTracing](https://opentracing.io/docs/overview/what-is-tracing/)开放式分布式追踪规范
* [zeromq]()
* [IdentityServer4](https://identityserver.io/)sing .NET to build identity and access control solutions for modern applications, including single sign-on, identity management, authorization, and API security.
* [jwt](https://jwt.io/)JSON Web Tokens are an open, industry standard RFC 7519 method for representing claims securely between two parties.

JWT.IO allows you to decode, verify and generate JWT
* []()
## 内网穿透
https://github.com/ffay/lanproxy/blob/master/README.md
https://blog.csdn.net/zhangguo5/article/details/77848658?utm_source=5ibc.net&utm_medium=referral
ngrok 
官网 http://ngrok.com 
ngrok1为开源版本，ngrok2闭源 ,并且官方好像并不打算开源，只会开源client端 
https://github.com/inconshreveable/ngrok 
go语言实现
网上有很多基于ngrok的内网透传工具natapp、ngrokcc、mofasuidao https://open-doc.dingtalk.com/microapp/debug/ucof2g
frp 项目地址:https://github.com/fatedier/frp 
pagekite 官网: https://pagekite.net/ https://github.com/pagekite/PyPagekite
可用的
http://ngrok.ciqiuwl.cn/
https://github.com/PassByYou888/ZServer4D  学习资料
https://github.com/cnlh/nps
https://github.com/fatedier/frp
ZeroTier，这个限制到100个接入电脑，而且是开源的。还能给你分配IPv6的地址。但常年实测稳定性比蒲公英稍差。因为内网穿透连接初期要到一个中转服务器拿到底层链路信息，ZeroTier和TeamViewer都要到国外绕一下，没有国内蒲公英（就是花生壳公司）的流畅
openvpn
teamviewer/向日葵/pcanywhere都是通过本地登录的方式实现远程连接，如果目标端进入屏保状态往往就会卡住。远程桌面是不一样的原理，跟本地登录无关（实际上是互斥的，不改注册表，同一个账户远程登录了本地就会退出），只要机器取消睡眠设置，不会有TV那样的问题
目前市面上做SD-WAN的提供商差不多有十家，他们分别是Aryaka Networks、Cisco Meraki、CiscoViptela、Citrix、Cradlepoint、Riverbed、Silver Peak、Talari、VMware和Versa Networks。IT团队可以根据供应商当前的SD-WAN技术
- [SD-WAN]() software-defined networking in a wide area network 
   - [](蒲公英VPN)
- [flexiwangroup](https://gitlab.com/flexiwangroup)  ![](https://docs.flexiwan.com/overview/open-source.html)
- [NSmartProxy](https://gitee.com/studio2017/NSmartProxy) NSmartProxy是一款免费的内网穿透工具。采用.NET CORE的全异步模式打造。此为镜像仓库，如果希望贡献此项目



## mysql工具
* [mycli](https://github.com/dbcli/mycli)  python -m pip install mssql-cli
* [HeidiSQL](https://www.heidisql.com/?place=lblAppWebpage)"Heidi" lets you see and edit data and structures from computers running one of the database systems MariaDB, MySQL, Microsoft SQL or PostgreSQL. Invented in 2002 by Ansgar, with a development peak between 2009 and 2013, HeidiSQL belongs to the most popular tools for MariaDB and MySQL worldwide
* [beekeeper-studio](https://github.com/beekeeper-studio/beekeeper-studio) https://www.beekeeperstudio.io/ 直接运行
* [dbeaver](https://github.com/dbeaver/dbeaver) java

## mssql工具
* [mssql-cli](https://github.com/dbcli/mssql-cli)
* [canal](https://github.com/alibaba/canal) 阿里巴巴 MySQL binlog 增量订阅& 消费组件 数据库实时备份
* [Zebra](https://github.com/Meituan-Dianping/Zebra) 高性能的数据库访问层解决方案，是美团点评内部使用的数据库访问层中间件。具有以下的功能点：
* [SQL Server Management Studio](https://docs.microsoft.com/zh-cn/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017)https://download.microsoft.com/download/d/9/7/d9789173-aaa7-4f5b-91b0-a2a01f4ba3a6/SSMS-Setup-CHS.exe
* []()
* []()
* []()
* []()
* []()


## mssql数据库文档生成
 * [DBCHM](https://gitee.com/lztkdr/DBCHM)
 * [Kalman.Studio](https://github.com/loamen/Kalman.Studio/releases)


## nuget
* [huaweicloud](https://mirrors.huaweicloud.com/)
* [alibaba](https://opsx.alibaba.com/mirror)
* []()
* []()
* []()
 
## mirror
* [BaGet](https://github.com/mirecad/BaGet) A lightweight NuGet and Symbol server.
* []()
* []()

## ftp
* [filezilla](https://www.filezilla.cn/download/client)
* [freesshd](http://www.freesshd.com/?ctt=download) window 下sftp
* []()
* []()
* []()
* []()

## microservice
* [apollo](https://github.com/ctripcorp/apollo) 分布式配置中心

## mongodb工具
* [robomongo]()
* [mongobooster]()
* [studio-3t-x64]()
* [mongovue]()
* [Robo 3T](https://www.robomongo.org/)
* [Mongood](https://github.com/RenzHoly/Mongood) 开源Mongood


## mock
* [fastmock](https://www.fastmock.site/)  /mock/6c270ede0a0f3f1063a056314c3cde0c/base2/api/abc1 
* [mocky](https://designer.mocky.io/design)
* [](https://github.com/easy-mock/easy-mock)
* []()
* []()
* []()
* []()
* []()
* []()


## redis 
* [redis-tui](https://github.com/mylxsw/redis-tui/releases)
* [RedisDesktopManager](https://github.com/uglide/RedisDesktopManager)
* [AnotherRedisDesktopManager](https://github.com/qishibo/AnotherRedisDesktopManager/releases)
* []()
* []()
* []()
* []()

## .net工具
* [ILSpy.exe]()
* [dnSpy.exe]()

## nuget
* [nexus-repository](https://www.sonatype.com/product-nexus-repository) [](https://www.sonatype.com/nexus-repository-oss)
* []()


## sqlite工具
* [sqlitestudio](https://sqlitestudio.pl/index.rvt?act=download)
* [SQLiteSpy](https://www.yunqa.de/delphi/downloads/SQLiteSpy_1.9.13.zip)

## 调试工具
* [winddbg](https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/debugger-download-tools)
* [PerfView]()基于Windows事件跟踪（ETW）事件。这是一个内置的日志记录系统，运行速度非常快，Windows的每个部分都可以使用它。一切都将事件记录到ETW，包括内核，Windows操作系统，CLR运行时，IIS，ASP.NEt框架，WPF等
* [Performance Monitor (PerfMon)]()Windows中有一种称为“性能计数器”的内置机制。这些计数器可让你根据计算机上发生的事情跟踪大量有用的指标。这些可能是系统范围内的指标，也可能是针对特定过程的指标
* [ProcDump]()保存转储文件的命令行工具。它可以立即或在触发器上生成转储。例如，在崩溃或挂起时创建转储。这是我推荐的用于捕获转储的工具
* [Process Monitor]()允许你监视流程活动事件。具体的说，你可以弹道注册表事件，文件事件，网络事件，线程活动和性能分析事件。如果你想找出你的过程涉及哪些文件或注册表，那么ProcMon可以为你提供帮助
* [SysInternals Suite]()Windows软件进行故障排除和监视的实用程序。它包括一些我们调试所需的最重要的工具。我建议下载整个套件并将其保存在易于命令行键入的位置
* [SciTech's .NET Memory Profiler](https://memprofiler.com)
* [dotPeek]()
* [dotTrace]()
* [dnSpy]()
* []()
* []()
* [](https://www.cnblogs.com/sesametech-netcore/p/12365896.html) 10常用调试工具

## 团队文档协作
* [GitBook Editor](https://www.gitbook.com/editor)   GitBook + GitLab 团队文档协作 https://www.jianshu.com/p/e74dad6845d1
* [GitBook CI](https://github.com/GitbookIO/gitbook-cli)
* [hexo](https://hexo.io/zh-cn/docs/)是一个快速、简洁且高效的博客框架。Hexo 使用 Markdown（或其他渲染引擎）解析文章，在几秒内，即可利用靓丽的主题生成静态网页   https://app.netlify.com/
* [Jekyll]()
* [bookstack](https://www.bookstack.cn/read/help/opensource.md)基于MinDoc，使用Beego开发的在线文档管理系统，功能类似Gitbook和看云
* []()
* []()
* []()
* []()
* []()
* []()

## 原型图
- [axure](https://www.axure.com/)
- [Sketch]()好用的插件：包括标注、自动生成内容、icon、批量替换等等和设计、甚至开发之间，更顺畅的工作流
- [naotu](https://naotu.baidu.com/)
- [processon](https://www.processon.com/)
- [Blumind]()
- [XMIND]()
- [VISIO]()
- []()
- []()
- []()
- []()
- []()
- []()




## window_shell
- [Kitty](http://www.9bis.net/kitty/) - 高级 Putty (SSH 和 telnet 客户端)。
- [MobaXterm](http://mobaxterm.mobatek.net/) - Xserver 和标签式 SSH 客户端。
- [mRemoteNG](https://mremoteng.org/) - 下一代 mRemote，开源，多标签，多协议，远程连接管理器。 [![Open-Source Software][OSS Icon]](https://mremoteng.org/) ![Freeware][Freeware Icon]
- [MTPuTTY](http://ttyplus.com/multi-tabbed-putty/) - 多标签 PuTTY。
- [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) - SSH 和 telnet 客户端。
- [Terminus](https://eugeny.github.io/terminus/) - 基于Web技术的现代高度可配置的终端应用程序。
- [windows terminal](https://github.com/microsoft/terminal) - window10
- [conemu](https://conemu.github.io/en/Downloads.html) -   

## 测试工具
* [Apache Bench](https://www.apachelounge.com/download/) apache 服务器自带的一个web压力测试工具，简称ab，对发起负载的本机要求很低，根据ab命令可以创建很多的并发访问线程，模拟多个访问者同时对某一URL地址进行访问，因此可以用来测试目标服务器的负载压力。总的来说ab工具小巧简单，上手学习较快，可以提供需要的基本性能指标，但是没有图形化结果，不能监控
* [apache-jmeter](http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-jmeter-5.1.1.zip)
* [wrk]( https://github.com/wg/wrk.git)
* [Locust]()  yum -y install python-pip
  - [用法](https://www.cnblogs.com/grizz/p/11570801.html)
* [SuperBenchmarker]( https://github.com/aliostad/SuperBenchmarker) netcore  [](https://www.cnblogs.com/yyfh/p/12447263.html)


## 渗透测试工具
* [burp suite](https://portswigger.net)
* [Zed Attack Proxy]() ZAP位于浏览器和测试网站之间，允许您拦截(也就是中间人)流量来检查和修改
* [Kali Linux]()
* [Metasploit]()
* [Nmap]()
* [Sqlmap]() Sqlmap支持所有常见的目标，包括MySQL、Oracle、PostgreSQL、Microsoft SQL Server、Microsoft Access、IBM DB2、SQLite、Firebird、Sybase、SAP MaxDB、Informix、HSQLDB和H2
* [新网络安全思维导图](https://www.toomcat.com/?p=564)高清版本 – 新网络安全思维导图
* []()


## 网络测试和抓包
* [nslookup]()
* [netcat](https://eternallybored.org/misc/netcat/) ![linux](apt-get -y install netcat-traditional )
* [postwoman]( git@github.com:liyasthomas/postwoman.git) https://postwoman.io/
* [Charles](https://www.charlesproxy.com/overview/features/) 收费
* [mitmproxy](https://www.mitmproxy.org) a free and open source interactive HTTPS proxy.  python
* [mitmproxy](https://github.com/wuchangming/node-mitmproxy)
* [anyproxy](http:///github.com/alibaba/anyproxy)anyproxy是阿里巴巴开发的一个优秀的代理的轮子，nodejs
   * [用法](https://www.cnblogs.com/yoyoketang/p/10867050.html)
* [fiddler]()
* []()
* []()



## 开源浏览器
* [miniblink](https://weolar.github.io/miniblink/) 是一款极致小巧的开源浏览器控件,可嵌入各种软件中,提供浏览服务... 通过嵌入miniblink,实现打包web功能至本地应用。可实现财务报表、OA企业办公自动化系统  https://weolar.github.io/miniblink/doc-main.html  https://github.com/E024/MiniBlinkPinvokeDemo
* [cef]()优点是由于集成的chromium内核，所以对H5支持的很全，同时因为使用的人也多，各种教程、示例，资源很多。但缺点很明显，太大了。最新的cef已经夸张到了100多M，还要带一堆的文件。同时新的cef已经不支持xp了（chromium对应版本是M49）。而且由于是多进程架构，对资源的消耗也很夸张。如果只是想做个小软件，一坨文件需要带上、超大的安装包，显然不能忍受
* [nwjs]()者最近大火的electron：和cef内核类似，都是chromium内核。缺点和cef一模一样。优点是由于可以使用nodejs的资源，同时又自带了各种api的绑定，所以可以用的周边资源非常丰富；而基于js的开发方案，使得前端很容易上手。所以最近N多项目都是基于nwjs或electron来实现。例如vscode，atom等等。
* [webkit]()现在官网还在更新windows port，但显然漫不在心，而且最新的webkit也很大了，超过20几M。最关键的是，周边资源很少，几乎没人再基于webkit来做开发。同时由于windows版的saferi已经停止开发了，所以用webkit就用不了他的dev tools了。这是个大遗憾
* [fiddler-everywhere](https://www.telerik.com/download/fiddler-everywhere)  跨平台
* []()
* []()
* []()
* []()

## 监控系统
* [open-falcon](https://github.com/open-falcon/agent)小米的监控系统  整个系统的后端，全部golang编写，portal和dashboard使用python编写  http://book.open-falcon.org/zh/intro/
* [zabbix]()
* []()
* []()


##  服务器
* [iperf](https://iperf.fr/iperf-download.php) 服务器之间带宽测试
* [zabbix]()
* [jumpserver](https://docs.jumpserver.org/zh/docs/setup_by_prod.html) 管理后台, 管理员可以通过 Web 页面进行资产管理、用户管理、资产授权等操作, 用户可以通过 Web 页面进行资产登录, 文件管理等操作
koko 为 SSH Server 和 Web Terminal Server 。用户可以使用自己的账户通过 SSH 或者 Web Terminal 访问 SSH 协议和 Telnet 协议资产
Luna 为 Web Terminal Server 前端页面, 用户使用 Web Terminal 方式登录所需要的组件
Guacamole 为 RDP 协议和 VNC 协议资产组件, 用户可以通过 Web Terminal 来连接 RDP 协议和 VNC 协议资产 (暂时只能通过 Web Terminal 来访问)

##  手机测试
* [Appium](http://appium.io/) 一个开源测试自动化框架,可用于原生,混合和移动Web应用程序测试。 它使用WebDriver协议驱动iOS,Android和Windows应
* []()
* []()


##  代理
* [caddys](https://caddyserver.com/docs/getting-started) go语言 比nginx 简单
* []()
* []()
* []()
* []()

## 下载歌曲
* [SoundPirate](https://github.com/seekerlee/SoundPirate)支持豆瓣FM，豆瓣音乐人，虾米，QQ音乐，网易云音乐，酷我，echo回声等.
* []()

## 下载
* [motrix]https://motrix.app/zh-CN/features)  (https://github.com/agalwood/Motrix)Motrix 是一款全能的下载工具，支持下载 HTTP、FTP、BT、磁力链、某盘等资源。它的界面简洁易用，希望大家喜欢 
* [Aria2](http://aria2.github.io/) 几乎全能的下载神器 https://github.com/mayswind/AriaNg  https://github.com/aria2/aria2
    -[](https://www.cnblogs.com/jiangwenwen1/p/10241293.html)
* []()

## 私有同步云盘
* [Nextcloud](https://docs.nextcloud.com/server/18/admin_manual/installation/)php 开发Nextcloud是一款开源免费的私有云存储网盘项目，可以让你快速便捷地搭建一套属于自己或团队
* [Seafile](https://github.com/haiwen/seafile) C开发，有一键部署脚本，无论是windows还是linux平台部署都比较简单，但是linux的一键脚本还不够自动化，开机启动，webdav等功能需要手动配置脚本，好在国产程序文档比较清楚，有点基础的一般不难配置成功  https://cloud.seafile.com/published/seafile-manual-cn/deploy/README.md
* [Cloudreve](https://github.com/cloudreve/Cloudreve)支持多家云存储的云盘系统 (A project helps you build your own cloud in minutes) https://cloudreve.org
* [go-fastdfs](https://github.com/sjqzhang/go-fastdfs)
* []()
* []()
* []()
* []()

-[awesome-http](https://github.com/semlinker/awesome-http) HTTP、HTTP Cache、CORS、HTTPS、HTTP/2、Fiddler、WireShark、Web Crawler
-[awesome-spider](https://github.com/facert/awesome-spider) 爬虫集合
-[码农周刊分类整理](https://github.com/nemoTyrant/manong)
-[node.js中文资料导航](https://github.com/sergtitov/NodeJS-Learning/blob/master/cn_resource.md)
- [octotree](https://github.com/ovity/octotree github 代码插件  树
- [WireShark——IP](https://www.cnblogs.com/CSAH/p/13170860.html)WireShark——IP协议包分析(Ping分析IP协议包)
- [WireShark——ARP](https://www.cnblogs.com/CSAH/p/12749368.html)WireShark——ARP 协议包分析
- [wireshark怎么抓包、wireshark抓包详细图文教程](https://www.cnblogs.com/moonbaby/p/10528401.html)c、wireshark抓包详细图文教程
- [FiddlerGenerateHttpClientCode](https://github.com/sunilpottumuttu/FiddlerGenerateHttpClientCode)
- [Fiddler抓取HTTPS最全](https://www.cnblogs.com/liulinghua90/p/9109282.html)
- []()
- []()
- []()


## misc
- [一款开源的一文多发平台](https://github.com/crawlab-team/artipub)