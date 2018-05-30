
::https://www.cnblogs.com/mq0036/p/6761684.html
::下面的命令计划安全脚本 Sec.vbs 每 20 分钟运行一次。由于命令没有包含起始日期或时间，任务在命令完成 20 分钟后启动，此后每当系统运行它就每 20 分钟运行一次。请注意，安全脚本源文件位于远程计算机上，但任务在本地计算机上计划并执行
schtasks /create /sc minute /mo 20 /tn "Security scrīpt" /tr \\central\data\scrīpts\sec.vbs


::下面的命令将计划 MyApp 程序从午夜过后五分钟起每小时运行一次。因为忽略了/mo参数，命令使用了小时计划的默认值，即每 (1) 小时。如果该命令在 12:05 A.M 之后生成，程序将在第二天才会运行。
schtasks /create /sc hourly /st 00:05:00 /tn "My App" /tr c:\apps\myapp.exe

::计划命令每五小时运行一次
::下面的命令计划 MyApp 程序从 2001 年 3 月的第一天起每五小时运行一次。它使用/mo参数来指定间隔时间，使用/sd参数来指定起始日期。由于命令没有指定起始时间，当前时间被用作起始时间。
schtasks /create /sc hourly /mo 5 /sd 03/01/2001 /tn "My App" /tr c:\apps\myapp.exe

::下面的命令计划任务每隔一周在周五运行。它使用/mo参数来指定两周的间隔，使用/d参数来指定是一周内的哪一天。如计划任务在每个周五运行，要忽略/mo参数或将其设置为 1。
schtasks /create /tn "My App" /tr c:\apps\myapp.exe /sc weekly /mo 2 /d FRI
schtasks create monthly







::计划任务在每月的第一天运行
::下面的命令计划 MyApp 程序在每月的第一天运行。因为默认修饰符是 none（即：没有修饰符），默认天是第一天，默认的月份是每个月，所以该命令不需要任何其它的参数。
schtasks /create /tn "My App" /tr c:\apps\myapp.exe /sc monthly

::计划任务在每月的最后一天运行
::下面的命令计划 MyApp 程序在每月的最后一天运行。它使用/mo参数指定在每月的最后一天运行程序，使用通配符 (*) 与/m参数表明在每月的最后一天运行程序。
schtasks /create /tn "My App" /tr c:\apps\myapp.exe /sc monthly /mo lastday /m *

::计划任务每三个月运行一次
::下面的命令计划 MyApp 程序每三个月运行一次。.它使用/mo参数来指定间隔。
schtasks /create /tn "My App" /tr c:\apps\myapp.exe /sc monthly /mo 3




::下面的命令计划 MyApp 程序在计算机空闲的时候运行。它使用必需的/i参数指定在启动任务之前计算机必需持续空闲十分钟。
schtasks /create /tn "My App" /tr c:\apps\myapp.exe /sc onidle /i 10





::下面的命令计划批处理文件在用户（任何用户）每次登录到远程计算机上的时候运行。它使用/s参数指定远程计算机。因为命令是远程的，所以命令中所有的路径，包括批处理文件的路径，都指定为远程计算机上的路径。
schtasks /create /tn "Start Web Site" /tr c:\myiis\webstart.bat /sc onlogon /s Server23
schtasks create onidle




::下面的命令将 Virus Check 任务运行的程序由 VirusCheck.exe 更改为 VirusCheck2.exe。此命令使用/tn参数标识任务，使用/tr参数指定任务的新程序。（不能更改任务名称。）
schtasks /change /tn "Virus Check" /tr C:\VirusCheck2.exe