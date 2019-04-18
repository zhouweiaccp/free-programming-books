

https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/debugger-download-tools
https://www.cnblogs.com/gaochundong/p/windbg_cheat_sheet.html#buildin_help_cmds


http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools/dbg_x86.msi
http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools_amd64/dbg_amd64.msi
https://download.microsoft.com/download/5/C/3/5C3770A3-12B4-4DB4-BAE7-99C624EB32AD/windowssdk/winsdksetup.exe win10


https://docs.microsoft.com/zh-cn/dotnet/framework/tools/sos-dll-sos-debugging-extension   .net调试命令
https://www.cnblogs.com/bluesummer/p/8125013.html
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