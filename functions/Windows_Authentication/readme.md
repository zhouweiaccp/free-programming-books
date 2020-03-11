


在由基于Windows Server 2003的域控制器组成的域中，默认的动态端口范围为1025至5000。Windows Server 2008 R2和Windows Server 2008符合互联网号码分配机构（IANA）的建议，增加了动态端口连接范围。新的默认开始端口是49152，并且新的默认端口是65535.因此，您必须增加防火墙中的远程过程调用（RPC）端口范围。如果您的混合域环境包含Windows Server 2008 R2和Windows Server 2008服务器以及Windows Server 2003，请允许通过端口1025至5000以及49152至65535的流量。

当您在下表中的协议和端口列中看到"TCP Dynamic"时，它指的是端口1025到5000（Windows Server 2003的默认端口范围）以及端口49152到65535，这是从Windows Server 2008开始的默认端口范围。

您可以使用以下的netsh命令运行Windows Server 2008 的计算机上查看的动态端口范围：

netsh int ipv4 show dynamicport tcp

netsh int ipv4 show dynamicport udp

netsh int ipv6 show dynamicport tcp

netsh int ipv6 show dynamicport udp

TCP和UDP 389	目录，复制，用户和计算机认证，组策略，信任	LDAP
TCP 636	目录，复制，用户和计算机认证，组策略，信任	LDAP SSL
TCP 3268	目录，复制，用户和计算机认证，组策略，信任	LDAP GC
TCP 3269	目录，复制，用户和计算机认证，组策略，信任	LDAP GC SSL
TCP和UDP 88	用户和计算机身份验证，林级信任	Kerberos
TCP和UDP 53	用户和计算机认证，名称解析，信任	DNS
TCP和UDP 445	复制，用户和计算机身份验证，组策略，信任	SMB，CIFS，SMB2，DFSN，LSARPC，NbtSS，NetLogonR，SamR，SrvSvc
TCP 25	复制	SMTP
TCP 135	复制	RPC，EPM
TCP Dynamic	复制，用户和计算机身份验证，组策略，信任	RPC，DCOM，EPM，DRSUAPI，NetLogonR，SamR，FRS
TCP 5722	文件复制	RPC，DFSR（SYSVOL）
UDP 123	Windows时间，信任	Windows Time
TCP和UDP 464	复制，用户和计算机认证，信任	Kerberos更改/设置密码
UDP Dynamic	组策略	DCOM，RPC，EPM
UDP 138	DFS，组策略	DFSN，NetLogon，NetBIOS数据报服务
TCP 9389	AD DS Web服务	SOAP
UDP 67和UDP 2535	DHCP	DHCP，MADCAP
	（DHCP不是核心的AD DS服务，但它经常出现在许多AD DS部署中。）	
UDP 137	用户和计算机认证，	NetLogon，NetBIOS名称解析
TCP 139	用户和计算机身份验证，复制	DFSN，NetBIOS会话服务，NetLogon




## kerberos
- [kerberos](https://www.cnblogs.com/artech/archive/2011/01/24/kerberos.html)  
- [](https://blog.csdn.net/wy_97/article/details/87649262)
- [authentication-concepts](https://docs.microsoft.com/zh-cn/windows/win32/secauthn/basic-authentication-concepts)
- [NTLM](https://www.cnblogs.com/artech/archive/2011/01/25/NTLM.html)


https://docs.microsoft.com/zh-cn/archive/blogs/mist/windows-authentication-http-request-flow-in-iis
https://support.microsoft.com/en-us/help/973917/description-of-the-update-that-implements-extended-protection-for-auth
https://docs.microsoft.com/en-us/iis/configuration/system.webserver/security/authentication/windowsauthentication/providers/
https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/debugging-windows-authentication-errors
https://docs.microsoft.com/en-us/aspnet/core/security/authentication/windowsauth?view=aspnetcore-3.1&tabs=visual-studio  netcore3.1

https://docs.microsoft.com/zh-cn/dotnet/framework/network-programming/ntlm-and-kerberos-authentication
https://support.microsoft.com/en-us/help/973917/description-of-the-update-that-implements-extended-protection-for-auth   f-the-update-that-implements-extended-protection-for-auth


https://blogs.msdn.microsoft.com/benjaminperkins/2011/09/14/integrated-windows-authentication-with-negotiate/    integrated-windows-authentication-with-negotiate https://benperk.github.io/msdn/2011/2011-08-integrated-windows-authentication-with-negotiate.html

https://blogs.iis.net/brian-murphy-booth/delegconfig-v2-beta  工具

https://support.microsoft.com/en-us/help/820129/http-sys-registry-settings-for-windows  参数

https://www.cnblogs.com/chnking/archive/2007/11/20/965553.html#_Toc183326157 IIS的各种身份验证详细测试

一、    IIS的身份验证概述

1、     匿名访问

2、     集成windows身份验证

2.1.    NTLM验证

2.2.    Kerberos验证

3、     基本身份验证

二、    匿名访问

三、    Windows集成验证

1、     NTLM验证过程

1.1.    客户端选择NTLM方式

1.2.    服务端返回质询码

1.3.    客户端加密质询码再次发送请求

1.4.    服务端验证客户端用户和密码

2、     Kerberos验证过程

2.1.    客户端选择Kerberos验证

2.2.    服务端验证身份验证票

3、     客户端和服务器都不在域中

3.1.    客户端用ip地址访问服务

3.1.1.     客户端IE申请页面

3.1.2.     服务端返回无授权回应

3.1.3.     客户端选择NTLM验证，要求输入用户名密码，请求质询码

3.1.4.     服务器返回质询码

3.1.5.     客户端发送使用前面输入账户的密码加密后的质询码

3.1.6.     服务端验证通过，返回资源

3.2.    客户端用机器名访问服务器，登录用户名/口令跟服务器不匹配

3.2.1.     客户端IE申请页面

3.2.2.     服务端返回无授权回应

3.2.3.     客户端选择NTLM验证，请求质询码

3.2.4.     服务器返回质询码

3.2.5.     客户端发送用登陆本机的账户加密后的质询码

3.2.6.     服务端返回无授权回应

3.2.7.     客户端及选选择NTLM验证，要求输入用户名和口令，再次请求质询码

3.2.8.     服务端返回质询码

3.2.9.     客户端发送使用前面输入账户的密码加密后的质询码

3.2.10.       服务端验证通过，返回资源

3.3.    客户端用机器名访问服务器，登录用户名/口令跟服务器匹配

3.3.1.     客户端IE申请页面

3.3.2.     服务端返回无授权回应

3.3.3.     客户端选择NTLM验证，请求质询码

3.3.4.     服务器返回质询码

3.3.5.     客户端发送用登陆本机的账户加密后的质询码

3.3.6.     服务端验证通过，返回资源

4、     客户端和服务器都在同一域中

4.1.    客户端用机ip访问服务器

4.1.1.     客户端IE申请页面

4.1.2.     服务端返回无授权回应

4.1.3.     客户端选择NTLM验证，要求输入用户名密码，请求质询码

4.1.4.     服务器返回质询码

4.1.5.     客户端发送使用前面输入账户的密码加密后的质询码

4.1.6.     服务端验证通过，返回资源

4.2.    客户端用机器名访问服务器，客户端用户以域账户登录

4.2.1.     客户端IE申请页面

4.2.2.     服务端返回无授权回应

4.2.3.     客户端选择Kerberos验证，发送验证票到服务端

4.2.4.     服务端验证通过，返回资源

4.3.    客户端用机器名访问服务器，客户端用户以客户端本地用户登录，用户名/口令跟服务器账户不匹配

4.3.1.     客户端IE申请页面

4.3.2.     服务端返回无授权回应

4.3.3.     客户端选择NTLM验证，请求质询码

4.3.4.     服务器返回质询码

4.3.5.     客户端发送用登陆本机的账户加密后的质询码

4.3.6.     服务端返回无授权回应

4.3.7.     客户端及选选择NTLM验证，要求输入用户名和口令，再次请求质询码

4.3.8.     服务端返回质询码

4.3.9.     客户端发送使用前面输入账户的密码加密后的质询码

4.3.10.       服务端验证通过，返回资源

4.4.    客户端用机器名访问服务器，客户端用户以客户端本地用户登录，用户名/口令跟服务器账户匹配

4.4.1.     客户端IE申请页面

4.4.2.     服务端返回无授权回应

4.4.3.     客户端选择NTLM验证，请求质询码

4.4.4.     服务器返回质询码

4.4.5.     客户端发送用登陆本机的账户加密后的质询码

4.4.6.     服务端验证通过，返回资源

5、     集成验证总结

5.1.    客户端以ip地址访问服务器

5.2.    服务器在域，客户端以域帐号登陆

5.3.    其他情况IE都选择采用NTLM验证方式。

四、    基本身份验证

1、     客户端IE申请页面

2、     服务端返回无授权回应，并告知客户端要求基本身份验证

3、     客户端弹出对话框要求输入用户名和密码

4、     服务端验证通过，返回资源

 

 

一、  IIS的身份验证概述
IIS具有身份验证功能，可以有以下几种验证方式：

1、 匿名访问
这种方式不验证访问用户的身份，客户端不需要提供任何身份验证的凭据，服务端把这样的访问作为匿名的访问，并把这样的访问用户都映射到一个服务端的账户，一般为IUSER_MACHINE这个用户，可以修改映射到的用户：

clip_image001

2、 集成windows身份验证
这种验证方式里面也分为两种情况

2.1.    NTLM验证
这种验证方式需要把用户的用户名和密码传送到服务端，服务端验证用户名和密码是否和服务器的此用户的密码一致。用户名用明码传送，但是密码经过处理后派生出一个8字节的key加密质询码后传送。

2.2.    Kerberos验证
这种验证方式只把客户端访问IIS的验证票发送到IIS服务器，IIS收到这个票据就能确定客户端的身份，不需要传送用户的密码。需要kerberos验证的用户一定是域用户。

每一个登录用户在登录被验证后都会被域中的验证服务器生成一个票据授权票（TGT）作为这个用户访问其他服务所要验证票的凭证（这是为了实现一次登录就能访问域中所有需要验证的资源的所谓单点登录SSO功能），而访问IIS服务器的验证票是通过此用户的票据授权票（TGT）向IIS获取的。之后此客户访问此IIS都使用这个验证票。同样访问其他需要验证的服务也是凭这个TGT获取该服务的验证票。

下面是kerberos比较详细的原理。

Kerberos原理介绍：

工作站端运行着一个票据授权的服务，叫Kinit，专门用做工作站同认证服务器Kerberos间的身份认证的服务。

1.        用户开始登录，输入用户名，验证服务器收到用户名，在用户数据库中查找这个用户，结果发现了这个用户。

2.        验证服务器生成一个验证服务器跟这个登录用户之间共享的一个会话口令（Session key），这个口令只有验证服务器跟这个登录用户之间使用，用来做相互验证对方使用。同时验证服务器给这个登录用户生成一个票据授权票(ticket-granting ticket)，工作站以后就可以凭这个票据授权票来向验证服务器请求其他的票据，而不用再次验证自己的身份了。验证服务器把{ Session key ＋ ticket-granting ticket }用登录用户的口令加密后发回到工作站。

3.        工作站用自己的口令解密验证服务器返回的数据包，如果解密正确则验证成功。解密后能够获得登录用户与验证服务器共享的Session key和一张ticket-granting ticket。

 

到此，登录用户没有在网络上发送口令，通过验证服务器使用用户口令加密验证授权票的方法验证了用户，用户跟验证服务器之间建立了关系，在工作站上也保存来相应的身份证明，以后要是用网络中的其他服务，可以通过这个身份证明向验证服务器申请相应服务器的服务票，来获得相应服务身份验证。

 

4.        如果用户第一次访问IIS服务器，工作站的kinit查看本机上没有访问IIS服务器的验证票，于是kinit会向验证服务器发出请求，请求访问IIS服务的验证票。Kinit先要生成一个验证器，验证器是这样的：{用户名：工作站地址}用跟验证服务器间的Session key加密。Kinit将验证器、票据授权票、你的名字、你的工作站地址、IIS服务名字发送的验证服务器，验证服务器验证验证授权票真实有效，然后用跟你共享的Session key解开验证器，获取其中的用户名和地址，与发送这个请求的用户和地址比较，如果相符，说明验证通过，这个请求合法。

5.        验证服务器先生成这个用户跟IIS服务器之间的Session key会话口令，之后根据用户请求生成IIS服务器的验证票，是这个样子的：｛会话口令：用户名：用户机器地址：服务名：有效期：时间戳｝，这个验证票用IIS服务器的密码（验证服务器知道所有授权服务的密码）进行加密形成最终的验证票。最后，验证服务器{会话口令＋加好密的验证票}用用户口令加密后发送给用户。

6.        工作站收到验证服务器返回的数据包，用自己的口令解密，获得跟IIS服务器的Session key和IIS服务器的验证票。

7.        工作站kinit同样要生成一个验证器，验证器是这样的：{用户名：工作站地址}用跟IIS服务器间的Session key加密。将验证器和IIS验证票一起发送到IIS服务器。

8.        IIS服务器先用自己的服务器密码解开IIS验证票，如果解密成功，说明此验证票真实有效，然后查看此验证票是否在有效期内，在有效期内，用验证票中带的会话口令去解密验证器，获得其中的用户名和工作站地址，如果跟验证票中的用户名和地址相符则说明发送此验证票的用户就是验证票的所有者，从而验证本次请求有效。

3、 基本身份验证
这种验证方式完全是把用户名和明文用明文（经过base64编码，但是base64编码不是加密的，经过转换就能转换成原始的明文）传送到服务端验证。服务器直接验证服务器本地是否用用户跟客户端提供的用户名和密码相匹配的，如果有则通过验证。

 

二、  匿名访问
服务端IIS设置了允许匿名访问后，在收到客户端的资源请求后，不需要经过身份验证，直接把请求的资源返回给客户端。

GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

If-Modified-Since: Fri, 21 Feb 2003 12:15:52 GMT

If-None-Match: "0ce1f9a2d9c21:d87"

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: 192.168.100.5

Connection: Keep-Alive

 

HTTP/1.1 200 OK

Content-Length: 1193

Content-Type: text/html

Last-Modified: Fri, 21 Feb 2003 12:15:52 GMT

Accept-Ranges: bytes

ETag: "0ce1f9a2d9c21:d8b"

Server: Microsoft-IIS/6.0

MicrosoftOfficeWebServer: 5.0_Pub

X-Powered-By: ASP.NET

Date: Mon, 12 Nov 2007 07:29:40 GMT

 

三、  Windows集成验证
集成 Windows 身份验证可以使用 NTLM 或 Kerberos V5 身份验证，当 Internet Explorer 试图设为集成验证的IIS的资源时，IIS 发送两个 WWW 身份验证头，Negotiate 和 NTLM。

客户端IE认识Negotiate头，将选择Negotiate头，之后IE可以选择NTLM 或 Kerberos两种验证方式。

如果客户端不认识Negotiate头，只能选择NTLM头，就只能使用NTLM验证方式。

现在IE使用的版本一般都在5.0以上，所以现在可以认为IE客户端都能识别Negotiate 头。

所以本文只考虑IE接受Negotiate头，分别使用NTLM 或 Kerberos两种验证的情况。

 

1、 NTLM验证过程
1.1.    客户端选择NTLM方式
如果IE选择了NTLM验证，IE就会在发送到IIS的请求中加入一个Authorization: Negotiate头，内容为：

Authorization: Negotiate NTLMSSPXXXXXXXXXXXXXXXXX

蓝色部分在实际中是经过base64编码的，其中“NTLMSSP”表示是NTLM验证的请求，后面的“XXXXXXXX”部分是二进制的数据，告诉服务器，客户端现在选择了NTLM验证，请服务器发送质询码给客户端。

1.2.    服务端返回质询码
服务器在返回无授权访问的http回应的头部加入Authorization: Negotiate头，内容为：

Authorization: Negotiate NTLMSSPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

服务器返回的“XXXXXXXX”部分中含有一个八字节的质询码。

1.3.    客户端加密质询码再次发送请求
客户端使用客户端帐号的密码派生出来的8字节DESkey使用DES算法加密收到的质询码。连同客户端帐号的用户名发送到服务端，形式还是这样：

Authorization: Negotiate NTLMSSPXXXXXXXXXXXXXXXXX

这里的“XXXXXXX”部分包含了加密后的质询码和客户端用户名，用户名在其中以明码形式存在。

1.4.    服务端验证客户端用户和密码
服务端收到用户名后，先查验本机是否有这个用户，如果没有直接返回没有授权的http回应。

如果有这个用户，就用这个用户的密码派生出来的8字节DESkey使用DES算法加密发给客户端的那个8字节的质询码，然后跟收到客户端发送来的加密后的质询码比较，如果不相同，表示客户端输入密码不正确看，返回没有授权的http回应；如果相同，就表示客户端输入这个用户的密码正确，验证通过，返回客户端请求的资源。

 

2、 Kerberos验证过程
2.1.    客户端选择Kerberos验证
如果客户端选择了Kerberos验证，客户端直接在请求头中加入Authorization: Negotiate头，内容为：

Authorization: Negotiate XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

其中“XXXXXXXXXX”包含了客户端登录用户的身份验证票（登录时域中的票据服务器发放的标识此登录用户身份的票据，其中不包含用户的密码）。

2.2.    服务端验证身份验证票
服务器验证用户验证票，如果有效的票据，服务端能据此获得用户的用户名，并验证用户的有效性。验证通过后，服务端返回客户端请求的资源。

 

但是客户端IE何时选择NTLM 、合适选择Kerberos呢？下面通过一系列的测试来找出答案。

 

分服务器和客户端在域不在域两种情况测试。

 

3、 客户端和服务器都不在域中
测试环境为服务器和客户端机器在同一个局域网中，但是都不在域中。客户端IE请求服务端IIS的一个页面default.aspx。

IIS服务端设置：

l         不启用匿名访问

l         只启用集成windows身份验证

 

这个环境下又分为下面几种情况：

3.1.    客户端用ip地址访问服务
3.1.1.    客户端IE申请页面
客户端IE浏览器的地址栏上输入要访问的URL，就会向服务端发送一个GET请求：

GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: 192.168.1.13:81

Connection: Keep-Alive

3.1.2.    服务端返回无授权回应
服务端设置了禁用匿名访问，只允许windows验证，所以服务端返回了无授权回应：

HTTP/1.1 401 Unauthorized

返回的http头中还包括的:

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

这两个头表示服务端只接受集成windows验证方式

HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Sun, 11 Nov 2007 12:28:29 GMT

 

3.1.3.    客户端选择NTLM验证，要求输入用户名密码，请求质询码
客户端通过Authorization: Negotiate NTLMSSPXXXX 头告诉服务器，客户端要求NTLM验证，请求服务端发送质询码。

GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: 192.168.1.13:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAAD3==

 

3.1.4.    服务器返回质询码
服务端收到客户端的请求，发送一个八字节的质询码。

HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAAEgASADgAAAAFgoqii7rzphzu6mEAAAAAAAAAAFwAXABKAAAABQLODgAAAA9CAEkAWgBUAEEATABLAFIAMgACABIAQgBJAFoAVABBAEwASwBSADIAAQASAEIASQBaAFQAQQBMAEsAUgAyAAQAEgBiAGkAegB0AGEAbABrAFIAMgADABIAYgBpAHoAdABhAGwAawBSADIAAAAAAA==

X-Powered-By: ASP.NET

Date: Sun, 11 Nov 2007 12:29:44 GMT

 

3.1.5.    客户端发送使用前面输入账户的密码加密后的质询码
客户端IE收到质询码后，使用根据一定的规则从登录用户密码派生出的8字节的key对质询码进行DES加密，加密后的质询码和用户名明码连同页面请求一起发送到服务端。

GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: 192.168.1.13:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAI4AAAAYABgApgAAABgAGABIAAAAGgAaAGAAAAAUABQAegAAAAAAAAC+AAAABYKIogUCzg4AAAAPMQA5ADIALgAxADYAOAAuADEALgAxADMAYQBkAG0AaQBuAGkAcwB0AHIAYQB0AG8AcgBXAEkATgAyADAAMAAzAC0AUABDAL0amMkkEMWLAAAAAAAAAAAAAAAAAAAAAFND1Boc0kthz0TBnfxn3z4W9/NILU1CtW==

 

3.1.6.    服务端验证通过，返回资源
服务端收到用户名和加密后的质询码后，根据用户名查找服务器上此用户的密码，按照客户端同样的方法加密质询码，然后跟收到客户端返回的质询码，如果一致，则说明用户名和密码都一致，验证通过，返回客户端IE请求资源。如果不对，再次返回无授权http回应。

HTTP/1.1 200 OK

Date: Sun, 11 Nov 2007 12:29:44 GMT

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

X-AspNet-Version: 2.0.50727

Cache-Control: private

Content-Type: text/html; charset=utf-8

Content-Length: 522

 

 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 

<html xmlns="http://www.w3.org/1999/xhtml" >

<head><title>

.Untitled Page

</title></head>

<body>

    <form name="form1" method="post" action="default.aspx" id="form1">

<div>

<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwUJNzgzNDMwNTMzZGTcefU2sz1MLsbXiZdUEXomIyZ20Q==" />

</div>

 

    <div>

        This is a simple page!</div>

    </form>

</body>

</html>

 

3.2.    客户端用机器名访问服务器，登录用户名/口令跟服务器不匹配
这种情况，客户端用服务器名访问服务器，但是客户端登录系统的用户跟服务器上的用户名和密码不匹配，也就是要么服务器上没这个用户，要么就是服务器这个用户的密码跟客户端这个用户的密码不一样。

3.2.1.    客户端IE申请页面
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

3.2.2.    服务端返回无授权回应
服务端不允许匿名访问，服务端返回需要集成验证的的http头。

HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 12:38:36 GMT

3.2.3.    客户端选择NTLM验证，请求质询码
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAADw==

3.2.4.    服务器返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAAEgASADgAAAAFgoqikemftrQx0qUAAAAAAAAAAFwAXABKAAAABQLODgAAAA9CAEkAWgBUAEEATABLAFIAMgACABIAQgBJAFoAVABBAEwASwBSADIAAQASAEIASQBaAFQAQQBMAEsAUgAyAAQAEgBiAGkAegB0AGEAbABrAFIAMgADABIAYgBpAHoAdABhAGwAawBSADIAAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 12:38:36 GMT

3.2.5.    客户端发送用登陆本机的账户加密后的质询码
客户端IE首先用本机登录用户的密码派生的key加密质询码，然后连同用户名一起发送到服务端验证。

GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAIoAAAAYABgAogAAABQAFABIAAAAGgAaAFwAAAAUABQAdgAAAAAAAAC6AAAABYKIogUCzg4AAAAPVwBJAE4AMgAwADAAMwAtAFAAQwBBAGQAbQBpAG4AaQBzAHQAcgBhAHQAbwByAFcASQBOADIAMAAwADMALQBQAEMAwo4jxECJeUwAAAAAAAAAAAAAAAAAAAAA2/kscwhI0mmAC6W4OmsZjbrRyrS2NGUX

3.2.6.    服务端返回无授权回应
客户端本机登录的用户名和密码跟服务器端没有匹配的，所以验证在服务端没有通过，服务端返回无授权的回应。

HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 12:38:36 GMT

 

3.2.7.    客户端及选选择NTLM验证，要求输入用户名和口令，再次请求质询码
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAADw==

3.2.8.    服务端返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAAEgASADgAAAAFgoqi3GHiM9qD6TUAAAAAAAAAAFwAXABKAAAABQLODgAAAA9CAEkAWgBUAEEATABLAFIAMgACABIAQgBJAFoAVABBAEwASwBSADIAAQASAEIASQBaAFQAQQBMAEsAUgAyAAQAEgBiAGkAegB0AGEAbABrAFIAMgADABIAYgBpAHoAdABhAGwAawBSADIAAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 12:38:45 GMT

3.2.9.    客户端发送使用前面输入账户的密码加密后的质询码
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAIgAAAAYABgAoAAAABIAEgBIAAAAGgAaAFoAAAAUABQAdAAAAAAAAAC4AAAABYKIogUCzg4AAAAPQgBJAFoAVABBAEwASwBSADIAYQBkAG0AaQBuAGkAcwB0AHIAYQB0AG8AcgBXAEkATgAyADAAMAAzAC0AUABDAKeYMtcyzwKJAAAAAAAAAAAAAAAAAAAAAExqwTipbr+IzohNdmnopPU1B9pp7QBplA==

3.2.10.     服务端验证通过，返回资源
HTTP/1.1 200 OK

Date: Wed, 14 Nov 2007 12:38:45 GMT

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

X-AspNet-Version: 2.0.50727

Cache-Control: private

Content-Type: text/html; charset=utf-8

Content-Length: 522

 

 

 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 

<html xmlns="http://www.w3.org/1999/xhtml" >

<head><title>

.Untitled Page

</title></head>

<body>

    <form name="form1" method="post" action="default.aspx" id="form1">

<div>

<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwUJNzgzNDMwNTMzZGTcefU2sz1MLsbXiZdUEXomIyZ20Q==" />

</div>

 

    <div>

        This is a simple page!</div>

    </form>

</body>

</html>

3.3.    客户端用机器名访问服务器，登录用户名/口令跟服务器匹配
这种情况，客户端用服务器名访问服务器，而且客户端登录系统的用户正好在服务器上有个同名同密码的用户。

3.3.1.    客户端IE申请页面
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

3.3.2.    服务端返回无授权回应
同样，服务端不允许匿名访问，服务端返回需要集成验证的的http头。

HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 12:35:41 GMT

3.3.3.    客户端选择NTLM验证，请求质询码
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAADw==

3.3.4.    服务器返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAAEgASADgAAAAFgoqiSWLtzjLMElAAAAAAAAAAAFwAXABKAAAABQLODgAAAA9CAEkAWgBUAEEATABLAFIAMgACABIAQgBJAFoAVABBAEwASwBSADIAAQASAEIASQBaAFQAQQBMAEsAUgAyAAQAEgBiAGkAegB0AGEAbABrAFIAMgADABIAYgBpAHoAdABhAGwAawBSADIAAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 12:35:41 GMT

3.3.5.    客户端发送用登陆本机的账户加密后的质询码
GET /wstest/default.aspx HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1; MAXTHON 2.0)

Host: biztalkr2:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAIoAAAAYABgAogAAABQAFABIAAAAGgAaAFwAAAAUABQAdgAAAAAAAAC6AAAABYKIogUCzg4AAAAPVwBJAE4AMgAwADAAMwAtAFAAQwBBAGQAbQBpAG4AaQBzAHQAcgBhAHQAbwByAFcASQBOADIAMAAwADMALQBQAEMAg7v6JYS/3bAAAAAAAAAAAAAAAAAAAAAArE2xu3xDN3w0LmV1yUkDkrqVWhb2wg27

3.3.6.    服务端验证通过，返回资源
用户端登录的用户名和密码正好能匹配到服务端的一个用户和密码，验证通过。

HTTP/1.1 200 OK

Date: Wed, 14 Nov 2007 12:35:41 GMT

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

X-AspNet-Version: 2.0.50727

Cache-Control: private

Content-Type: text/html; charset=utf-8

Content-Length: 522

 

 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 

<html xmlns="http://www.w3.org/1999/xhtml" >

<head><title>

.Untitled Page

</title></head>

<body>

    <form name="form1" method="post" action="default.aspx" id="form1">

<div>

<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwUJNzgzNDMwNTMzZGTcefU2sz1MLsbXiZdUEXomIyZ20Q==" />

</div>

 

    <div>

        This is a simple page!</div>

    </form>

</body>

</html>

 

4、 客户端和服务器都在同一域中
服务器和客户端机器在同一个局域网中，并同在一个域中。客户端IE请求服务端IIS的一个页面iisstart.htm。

IIS服务端设置：

l         不启用匿名访问

l         只启用集成windows身份验证

 

这样的环境下又范围以下几种情况：

4.1.    客户端用机ip访问服务器
4.1.1.    客户端IE申请页面
GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: 192.168.100.5:81

Connection: Keep-Alive

4.1.2.    服务端返回无授权回应
IIS的设置不允许匿名访问，只能windows验证，所以发送401无授权回应，同时发回Negotiate和NTLM两个身份验证头让客户端选择。

HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 07:23:43 GMT

4.1.3.    客户端选择NTLM验证，要求输入用户名密码，请求质询码
由于使用的是ip地址访问服务器，URL中包含有”.”字符，IE认为访问的不是企业内部服务器，所以不直接提供用户凭据给服务端，要求用户输入帐户

GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: 192.168.100.5:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAAD4==

4.1.4.    服务器返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAACgAKADgAAAAFgomiF0CRjzLrr+cAAAAAAAAAAHwAfABCAAAABQLODgAAAA9TAFoAQgBUAEkAAgAKAFMAWgBCAFQASQABAAgATABPAEcAUwAEABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAwAiAGwAbwBnAHMALgBzAHoAYgB0AGkALgBnAG8AdgAuAGMAbgAFABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 07:24:15 GMT

4.1.5.    客户端发送使用前面输入账户的密码加密后的质询码
GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: 192.168.100.5:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAHYAAAAYABgAjgAAABoAGgBIAAAACgAKAGIAAAAKAAoAbAAAAAAAAACmAAAABYKIogUCzg4AAAAPMQA5ADIALgAxADYAOAAuADEAMAAwAC4ANQBqAGkAbgBqAHoASgBJAE4ASgBaALVaV8Ku0ERuAAAAAAAAAAAAAAAAAAAAAFowQcbaUXykWTrI7WJKQUA2taaV7wo5T2==

4.1.6.    服务端验证通过，返回资源
HTTP/1.1 200 OK

Content-Length: 1135

Content-Type: text/html

Last-Modified: Mon, 12 Nov 2007 09:33:27 GMT

Accept-Ranges: bytes

ETag: "d4469314f25c81:e35"

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 07:24:15 GMT

 

<html>

 

<head>

<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=gb2312">

 

</head>

 

<body bgcolor=white>

This is a simple page!

 

</body>

</html>

 

4.2.    客户端用机器名访问服务器，客户端用户以域账户登录
4.2.1.    客户端IE申请页面
GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: logs:81

Connection: Keep-Alive

4.2.2.    服务端返回无授权回应
HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 08:27:18 GMT

4.2.3.    客户端选择Kerberos验证，发送验证票到服务端
客户端在域中，并且以域账户登录，所以客户端IE选择使用Kerberos身份验证，发送与用户的验证票到服务端。

GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate YIIEzQYGKwYBBQUCoIIEwTCCBL2gJDAiBgkqhkiC9xIBAgIGCSqGSIb3EgECAgYKKwYBBAGCNwICCqKCBJMEggSPYIIEiwYJKoZIhvcSAQICAQBuggR6MIIEdqADAgEFoQMCAQ6iBwMFACAAAACjggOiYYIDnjCCA5qgAwIBBaEOGwxTWkJUSS5HT1YuQ06iFzAVoAMCAQKhDjAMGwRIVFRQGwRsb2dzo4IDaDCCA2SgAwIBF6EDAgEMooIDVgSCA1IeN8fZeLtzkw+5H8HOKmM8zgDOVL5GmeXoS8dMgE20RtI14EVWWZLn2j0AMXTqMOA550Grsadh89vZ89+6vprkVL0v49FM+gxHFCmZSOvLTIawBqXvLU6w1Pni8PN1pbhOKCRVON6+5XH4MN8Rfuqpyy1A/2gfeQIfLMMHs73yohp7h7QJP29b61jm0vj1xE0jEP7EupHlr225vrrVCnktTksbyqi88kIZlCB84J1gTqYoNeOycn4Qzvv8x6z1AsCfo2SBSwo1tj38BK2Fbu+BRXw26RrebGWPkILYwqED7bSR+RlDdokEhjubbyaWcnIjiSXZaN5kQqZQqms3iqhUrZpX7RaaV5BsMOgJs7LwYmc3uM5v7YqljwFD3T44XfpAiS3xlyirP3modOR1l+hV2xdIIFusXtRzY7rTkmEb2F3dGjTiMXySrc0GGhe3TrIeH9nB/2Udo/Z9m0ifXC0EU2fFogefmDc322vHhhv9gEYccG44Q/cnWx8gY9GfWCRihlaefGK+DmCvm+515UFYeIcG5KafXBQw3KX7MjI4/4hlAh3mQNn9p3nX0ePy1G1RRV2SToN7eg1PkaaYXDeC6MSIwCb53MfebzpyN0LKzmPZ6GneLYbyBIpANzPNoXz/LADA1h/l8F098ti1fThPVkUgoehgy1iyovTXyqJg6rojI0juIH7fKfc/UpfO+eLMhsquhH1KNjkCTD2CkdUfcsEU7B15j15p1OyGeg5/tEbRE67+NAWkfLSPp5R3tzGqjAh39w8n/8EWot9DBlHwk+qJp3rMFJZIvNtmXuvqnUW1NGpO1GIf78PBixyFwrJSo5syTfCiWIcw9YQ7MyvuyynAmsXeaI5+OP/GfmGpnvt5kMznu5q/nNf7LMV8n6x2+lmNlcPJiWr+KckPM9Nvntw2h/bl2qGnHDdOqNYI2N0VxzIm8wY6dWS3NIwlGl/usMjjebaELFP6rdHjpVG6pziJYjrBrws5DbqCxJ1EOeQdBiT8l1O6OUQqdOBVZH6/bj5MkLghWv0edHG8TJ4OGa69nMHDwTBOyuyRbTr5uWWFnESdyAGGbfGlJjuvSSzxgZViMSB2j8Ulk8x8MCqrupEK2i0UR6HrMNMJIDJsVcXTpIG6MIG3oAMCAReiga8EgazteAbcguseBpQnHeJihLFO78PfjI2Qop+MkH9jCOrvO9cQns1GzOKByoAbeP307QQq4zbaDF3EJlOC//4k4A6W4dc4k5lNeOgwR4LEvbIQKpdlljFiW8XUb+IgovsOlZEG0qFQgZY0I35I4Uvk/2dDkz06DGiDsQ0IENrRIMT4/7xgMSmkzspO2ojSbG5aKlbjK203QxMlkEoxb8WpJFZQggUqrLAr0q2graET

4.2.4.    服务端验证通过，返回资源
HTTP/1.1 200 OK

Content-Length: 167

Content-Type: text/html

Last-Modified: Wed, 14 Nov 2007 08:21:24 GMT

Accept-Ranges: bytes

ETag: "bf2d54589726c81:e35"

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

WWW-Authenticate: Negotiate oYGgMIGdoAMKAQChCwYJKoZIgvcSAQICooGIBIGFYIGCBgkqhkiG9xIBAgICAG9zMHGgAwIBBaEDAgEPomUwY6ADAgEXolwEWrdYWb37ROEMMnP/4vTBwSe9hVe4XklXCWqFKG16d53aBUiTEem+lrFE8ycBgSln3zme63lKfSn9UHoNTlT100T86wxllsyrrMe437ElPcxI4pgcv9rNKU9aKg==

Date: Wed, 14 Nov 2007 08:27:18 GMT

 

<html>

 

<head>

<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=gb2312">

 

</head>

 

<body bgcolor=white>

This is a simple page!

 

</body>

</html>

 

4.3.    客户端用机器名访问服务器，客户端用户以客户端本地用户登录，用户名/口令跟服务器账户不匹配
4.3.1.    客户端IE申请页面
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

4.3.2.    服务端返回无授权回应
HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 08:58:13 GMT

4.3.3.    客户端选择NTLM验证，请求质询码
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAADw==

4.3.4.    服务器返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAACgAKADgAAAAFgomibnmMcRgPlTMAAAAAAAAAAHwAfABCAAAABQLODgAAAA9TAFoAQgBUAEkAAgAKAFMAWgBCAFQASQABAAgATABPAEcAUwAEABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAwAiAGwAbwBnAHMALgBzAHoAYgB0AGkALgBnAG8AdgAuAGMAbgAFABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 08:58:13 GMT

4.3.5.    客户端发送用登陆本机的账户加密后的质询码
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAHYAAAAYABgAjgAAAAoACgBIAAAAGgAaAFIAAAAKAAoAbAAAAAAAAACmAAAABYKIogUCzg4AAAAPSgBJAE4ASgBaAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIASgBJAE4ASgBaACY8afODxKsFAAAAAAAAAAAAAAAAAAAAAPfRbw7FX9gKolM+6+QhqsRU+MWS3jKLkQ==

4.3.6.    服务端返回无授权回应
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 08:58:13 GMT

4.3.7.    客户端及选选择NTLM验证，要求输入用户名和口令，再次请求质询码
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAADw==

4.3.8.    服务端返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAACgAKADgAAAAFgomi3CZKUW4302QAAAAAAAAAAHwAfABCAAAABQLODgAAAA9TAFoAQgBUAEkAAgAKAFMAWgBCAFQASQABAAgATABPAEcAUwAEABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAwAiAGwAbwBnAHMALgBzAHoAYgB0AGkALgBnAG8AdgAuAGMAbgAFABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 08:59:09 GMT

4.3.9.    客户端发送使用前面输入账户的密码加密后的质询码
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAHYAAAAYABgAjgAAAAoACgBIAAAAGgAaAFIAAAAKAAoAbAAAAAAAAACmAAAABYKIogUCzg4AAAAPSgBJAE4ASgBaAGEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIASgBJAE4ASgBaAIP0UwZaV4tAAAAAAAAAAAAAAAAAAAAAAMS9l9MtVOFPSz/JmjD+/7W2ssAdBrkvwQ==

4.3.10.     服务端验证通过，返回资源
HTTP/1.1 200 OK

Content-Length: 167

Content-Type: text/html

Last-Modified: Wed, 14 Nov 2007 08:21:24 GMT

Accept-Ranges: bytes

ETag: "bf2d54589726c81:e35"

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 08:59:09 GMT

 

<html>

 

<head>

<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=gb2312">

 

</head>

 

<body bgcolor=white>

This is a simple page!

 

</body>

</html>

 

4.4.    客户端用机器名访问服务器，客户端用户以客户端本地用户登录，用户名/口令跟服务器账户匹配
4.4.1.    客户端IE申请页面
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

4.4.2.    服务端返回无授权回应
HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate

WWW-Authenticate: NTLM

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 09:11:09 GMT

4.4.3.    客户端选择NTLM验证，请求质询码
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAABAAAAB4IIogAAAAAAAAAAAAAAAAAAAAAFAs4OAAAADw==

4.4.4.    服务器返回质询码
HTTP/1.1 401 Unauthorized

Content-Length: 1251

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Negotiate TlRMTVNTUAACAAAACgAKADgAAAAFgomil8OZAC0QBhYAAAAAAAAAAHwAfABCAAAABQLODgAAAA9TAFoAQgBUAEkAAgAKAFMAWgBCAFQASQABAAgATABPAEcAUwAEABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAwAiAGwAbwBnAHMALgBzAHoAYgB0AGkALgBnAG8AdgAuAGMAbgAFABgAcwB6AGIAdABpAC4AZwBvAHYALgBjAG4AAAAAAA==

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 09:11:09 GMT

4.4.5.    客户端发送用登陆本机的账户加密后的质询码
GET /iisstart.htm HTTP/1.1

Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-silverlight, */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727)

Host: logs:81

Connection: Keep-Alive

Authorization: Negotiate TlRMTVNTUAADAAAAGAAYAHYAAAAYABgAjgAAAAoACgBIAAAAGgAaAFIAAAAKAAoAbAAAAAAAAACmAAAABYKIogUCzg4AAAAPSgBJAE4ASgBaAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIASgBJAE4ASgBaAMQdxp9OWMESAAAAAAAAAAAAAAAAAAAAAMEj775cWctAx2Csmbgfq2afsGcop92oMA==

4.4.6.    服务端验证通过，返回资源
用户端登录的用户名和密码正好能匹配到服务端的一个用户和密码，验证通过。

HTTP/1.1 200 OK

Content-Length: 167

Content-Type: text/html

Last-Modified: Wed, 14 Nov 2007 08:21:24 GMT

Accept-Ranges: bytes

ETag: "bf2d54589726c81:e35"

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

Date: Wed, 14 Nov 2007 09:11:09 GMT

 

<html>

 

<head>

<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=gb2312">

 

</head>

 

<body bgcolor=white>

This is a simple page!

 

</body>

</html>

 

5、 集成验证总结
5.1.    客户端以ip地址访问服务器
不管客户端跟服务器是否在域、也不管客户端是否以域帐号登陆，只要客户端以ip地址访问服务器，那么客户端就会选择NTLM方式验证，并且不会直接发送客户端登录用户的用户名和密码给服务器，而是会弹出一个对话框要求用户输入用户名和口令，然后发送到服务端验证。

您可以避免在使用 IP 地址或名称中包含句点的企业内部网服务器上出现这种提示，方法是，在 Internet Explorer 的“本地 Intranet”设置中，列出包含 IP 地址的服务器，或是列出包含句点的服务器名称。可以通过依次单击“工具”、“Internet 选项”、“本地 Intranet”、“站点”、“高级”来访问“本地 Intranet”设置部分。然后在“将该网站添加到区域中”输入 http://127.0.0.1 或其他相关站点的 URL。

 

下面总结的都是在客户端以机器名访问服务器的情况。

5.2.    服务器在域，客户端以域帐号登陆
如果客户端的机器在域中，同时登陆用户又是以域用户登录，那么IE选择Kerberos验证方式。

5.3.    其他情况IE都选择采用NTLM验证方式。
出来上述的两种情况，其他情况，客户端都选择NTLM验证，并首先尝试把登录客户端用户的用户名和密码传送给服务器验证，如果验证通过了，被直接授权访问；如果验证没通过，客户端弹出对话框要求输入用户名和密码，然后再传送到服务端验证，直到验证通过。

 

集成 Windows 身份验证Kerberos的验证方式是 Intranet 环境中最好的身份验证方案，在这种用户拥有 Windows 域帐户，Kerberos验证不在网络上传递用户密码，只用传送一个用户验证票。NTLM要传送用户的密码，但是密码经过处理后派生出一个8字节的key加密质询码，也是比较安全的。

 

 

四、  基本身份验证
客户端IE请求服务端IIS的一个页面iisstart.htm。

IIS服务端设置：

l         不启用匿名访问

l         只启用基本身份验证

 

1、 客户端IE申请页面
GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: logs:81

Connection: Keep-Alive

2、 服务端返回无授权回应，并告知客户端要求基本身份验证
服务端设置的基本身份验证，所以这里返回的无授权回应的http头中包含 WWW-Authenticate: Basic 头，告诉客户端，服务端要求的是基本身份验证

HTTP/1.1 401 Unauthorized

Content-Length: 1327

Content-Type: text/html

Server: Microsoft-IIS/6.0

WWW-Authenticate: Basic realm="logs"

X-Powered-By: ASP.NET

Date: Mon, 19 Nov 2007 06:15:57 GMT

3、 客户端弹出对话框要求输入用户名和密码
GET /iisstart.htm HTTP/1.1

Accept: */*

Accept-Language: zh-cn

UA-CPU: x86

Accept-Encoding: gzip, deflate

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1; .NET CLR 2.0.50727; MAXTHON 2.0)

Host: logs:81

Connection: Keep-Alive

Authorization: Basic YWRtaW5pc3RyYXRvcjpzemJ0aUAxMDA1

客户端把用户名和密码转换成base64编码后，直接发送到服务端。

发送到服务器的“Authorization: Basic”头里面的“YWRtaW5pc3RyYXRvcjpzemJ0aUAxMDA1”部分就是用户的用户名和密码，经过base64解码后是这样的：administrator:szbti@1005

4、 服务端验证通过，返回资源
HTTP/1.1 200 OK

Content-Length: 167

Content-Type: text/html

Last-Modified: Wed, 14 Nov 2007 08:21:24 GMT

Accept-Ranges: bytes

ETag: "bf2d54589726c81:e7d"

Server: Microsoft-IIS/6.0

X-Powered-By: ASP.NET

Date: Mon, 19 Nov 2007 06:16:34 GMT

 

<html>

 

<head>

<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=gb2312">

 

</head>

 

<body bgcolor=white>

This is a simple page!

 

</body>

</html>