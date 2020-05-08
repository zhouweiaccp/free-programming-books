
* [procdump](https://docs.microsoft.com/zh-cn/sysinternals/downloads/procdump)
https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/debugger-download-tools
https://www.cnblogs.com/gaochundong/p/windbg_cheat_sheet.html#buildin_help_cmds


http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools/dbg_x86.msi
http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools_amd64/dbg_amd64.msi
https://download.microsoft.com/download/5/C/3/5C3770A3-12B4-4DB4-BAE7-99C624EB32AD/windowssdk/winsdksetup.exe win10


https://docs.microsoft.com/zh-cn/dotnet/framework/tools/sos-dll-sos-debugging-extension   .net调试命令
https://www.cnblogs.com/bluesummer/p/8125013.html







## 一个非常效率的Windbg 插件，Mex

使用介绍：[https://www.cnblogs.com/tianqing/p/9369693.html]

https://blogs.msdn.microsoft.com/luisdem/2016/07/19/mex-debugging-extension-for-windbg-2/

下载地址：
https://www.microsoft.com/en-us/download/details.aspx?id=53304

下载之后，解压缩，有两个目录，X64和X86，大家根据自己的需要进行加载，目前我们主要用X64。当然也可以直接把这个扩展拷贝到Windbg运行目录中。

这里，我们先show一下Windbg加载mex扩展：

0:000> .load D:\Mex\x64\mex.dll
Mex External 3.0.0.7172 Loaded!


## 按例
- [Windbg程序调试系列2](https://www.cnblogs.com/tianqing/p/9875667.html)Windbg程序调试系列2-内存泄露问题

多核CPU情况下，分析每个GC托管堆的大小 !eeheap –gc
查询内存中各类对象的总个数和总内存占用 !dumpheap –stat
查询内存中大对象的个数和对象大小 !dumpheap –stat -mt -min 5000 -max 100000
如果某一类或者几类对象的内存总占用很多，分析此类对象 !dumpheap –mt ***
多次采样查看步骤4中对象的gcroot !gcroot addr
打断gcroot中任何一个链条，释放对象引用


2.命令
1.基本命令
? 获取命令提示
D 查看内存信息
K 观察栈
~ 显示和控制线程 ~number s number为线程id 如：~1s为获取1号线程的上下文
Q 退出
!runaway 查看线程占用cpu时间,可看出哪个线程占用时间最高(所有线程)
.dump /ma E:/dumps/myapp.dmp 抓取dump

2.元命令
.help 获取命令提示
.cls 清屏
.ttime 查看线程占用cpu时间,可看出哪个线程占用时间最高（当前线程）

3..扩展命令
. chain 获取命令集列表。在已经加载的动态链接库中。
.load/.unload 加载/卸载命令模块
!模块名.help 查看某个扩展库中包含的扩展命令

4..Net程序相关命令
基本
!peb或!dlls 列出进程已经加载的dll
!threadpool 查看当前CPU状况 线程数等等
!dumpheap –stat 统计堆信息
!Threads 所有托管线程 -special Crl创建的线程
!clrstack 看看这个线程再干嘛 执行那些方法
!clrstack –p addr addr：具体方法的参数值地址
!do 地址 查看参数值
!analyze –v 显示分析的详细信息
.reload /i /f 强制重新加载pdb

!help sos指令帮助
!threads 显示所有线程
!threadpool(!tp) 显示程序池信息
!ProcInfo 显示进程信息
!dumpheap 显示托管堆的信息
!dumpheap -stat 检查当前所有托管类型的统计信息
!dumpheap -type Person –stat 在堆中查找指定类型（person）对象，注意大小写敏感
!clrstack 显示调用栈
!clrstack -p 显示调用栈，同时显示参数
!clrstack 只显示托管代码，而kb只显示非托管代码
!dumpobj(!do) 显示一个对象的内容
!dumparray(!da) 显示数组
!DumpStackObjects(!dso) 当前线程对象分配过程
!syncblk 显示同步块
!runaway 显示线程cpu时间
!gcroot 跟踪对象内存引用
!pe 打印异常
!ObjSize 查看对象大小　ObjSize 用于知道对象地址时，查看该对象的大小。
!GCRoot 是一个非常有用的命令，它能够帮助我们发现某对象上目前还存在的有效引用。这也是为什么GC还不回收这个对象的原因。这个信息可以很好的帮助我们分析那些本应该没有引用，但却一直还存在有效引用的对象，由此发现我们代码中潜在的内存泄漏，同时我们也可以观察到哪些对象是目前没有引用了。
~*k 结合~和k命令，来显示所有线程的callstack
.cls 清屏
kb 显示当前线程的callstack


内存调试
!eeheap –gc 获取gc中内存信息
!eeheap –loader Loader 堆信息
!dumpheap –stat 统计GC堆的信息，统计GC堆上存活的对象
!dumpheap -mt <> 查看该地址上的对象
!gcroot <<对象地址>> 查看对象根
!dumpheap -type <<System.String >> 查看string类型在堆中的信息
!helproot -查看gcroot的帮助

在解析.Net程序时首先要加载运行环境framework版本对应的SOS.DLL：
srv*d:\debug\symbols*http://msdl.microsoft.com/download/symbols
.load C:\Windows\Microsoft.NET\Framework64\v4.0.30319\SOS.DLL
.load C:\Windows\Microsoft.NET\Framework64\v4.0.30319\clr.DLL

!dumpheap –stat 统计堆栈内存
!threads
!synblk


CPU高
-如果与业务量没有提升，有线程在长时间的处理
核心问题，找到占用CPU的线程
!runaway
~*e!clrstack

核心问题：找到锁定的线程
!threads
!syncblk
~*e!clrstack
•两条指令可以解决大部分的问题
•!dumpheap –stat
•~*e!clrstack
原文：https://blog.csdn.net/kntao/article/details/7086616 



调试dump步骤
将dump文件拖入windbg
执行.loadby sos clr或.loadby sos mscorwks加载模块
执行!analyze -v 进行异常分析
调试exe文件步骤
Open Executeable..
执行 sxe ld:clrjit
执行 g
执行.loadby sos clr
如何在IIS crash或者hang时候，dump 所有与IIS相关的memory?
当IIS发生crash或者hang之后，如果有必要获取此刻的memory dump。我们必须通过相应的debug tool来获得。相应工具很多。推荐的是windbg。安装之后，在其folder下，有一个adplus.vbs脚本工具。

dump hang模式下的iis memory：
在command console下面：
key in: adplus -hang -iis -o c:\ Path_to_Put_Files_in -quiet
则系统会listen iis。如果iis发生hang，那么会自动收集与iis相关的memory保存至Path_to_Put_Files,然后exit.

dump crash模式下的iis memory:
在command console下面：
key in: adplus -crash -iis -o c:\ Path_to_Put_Files_in -quiet
则当iis crash的时候，系统会自动收集与iis相关的memery并保存至Path_to_Put_Files,然后exit.

!sym noisy
.reload

链接：https://www.jianshu.com/p/57f0ab8702b5