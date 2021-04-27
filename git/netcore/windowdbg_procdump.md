

## windbg独立安装包下载
0x02 适用操作系统：
windows 7
windows xp
0x03 官方下载地址
x64
http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools_amd64/dbg_amd64.msi
x86
http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools/dbg_x86.msi
 win10 https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/debugger-download-tools

## procdump 用法
procdump -ma -c 50 -s 3 -n 2 5844(Process Name or PID)
-ma 生成full dump, 即包括进程的所有内存. 默认的dump格式包括线程和句柄信息.
-c 在CPU使用率到达这个阀值的时候, 生成dump文件.
-s CPU阀值必须持续多少秒才抓取dump文件.
-n 在该工具退出之前要抓取多少个dump文件.

-[如何在 NET 程序万种死法中有效的生成 Dump (上)](https://www.cnblogs.com/huangxincheng/p/14661031.html)
!address -summary
!dumpheap -stat -min 1024
!dumpheap -type System.String -min 10240
!gcroot 4a855060