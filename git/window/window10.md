## fsutil  10G
fsutil file createnew y:\10G.dat 10737418240

## Windows 10任务栏右键快速跳转列表显示数量修改
HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced
选择Advanced项目，然后在右边空白处右键新建一个 32位的DWORD值。
改名为JumpListItems_Maximum

## windows cmd中查看某个命令所在的路径
where python

## 关闭hypervi
关闭
bcdedit /set hypervisorlaunchtype off
启用

bcdedit /set hypervisorlaunchtype auto


## 因为在此系统上禁止运行脚本。有关详细信息
set-executionpolicy remotesigned

## 远程登录-出现身份验证错误[可能是由于CredSSP加
解决方法1
运行 gpedit.msc 本地组策略，“计算机配置”->“管理模板”->“系统”->“凭据分配”但是我的却找不到“加密Oracle修正”选项，选择启用并选择易受攻击。

解决方法2
运行 regedit，打开注册表，HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters在 System（之后没有的文件夹，需自己创建
）然后在最底部文件夹Parameters里面，新建 DWORD（32）位值（D）。文件名 “AllowEncryptionOracle” ，值 : 2，保存，重启


## forfile
https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/forfiles
forfiles /p "E:\pictures" /m * /d -1 /c "cmd /c  del /Q @file" 
大致意思就是删除E:\pictures目录以及其子目录下的修改时间为一天前的文件（此处用了通配符适配所有文件）

添加项
Windows Registry Editor Version 5.00

[HKEY_CURRENT_CONFIG\System\CurrentControlSet\SERVICES\TSDDD\DEVICE0]
"Attach.ToDesktop"=dword:00000001

移除项
Windows Registry Editor Version 5.00

[-HKEY_CURRENT_CONFIG\System\CurrentControlSet\SERVICES\TSDDD\DEVICE0]
"Attach.ToDesktop"=dword:00000001

移除子项
Windows Registry Editor Version 5.00

[HKEY_CURRENT_CONFIG\System\CurrentControlSet\SERVICES\TSDDD\DEVICE0]
"Attach.ToDesktop"=-

修改项
Windows Registry Editor Version 5.00

[HKEY_CURRENT_CONFIG\System\CurrentControlSet\SERVICES\TSDDD\DEVICE0]
"Attach.ToDesktop"=dword:00000000

规则

字符串值S表示："字符串"=""
二进制值B表示："二进制"=hex:
DWORD（64-位）值Q表示："DWORD（64-位）"=hex(b):00,00,00,00,00,00,00,00
多字符（32-位）值D表示："DWORD（32-位）"=dword:00000000
DWORD串值M表示："多字符串"=hex(7):00,00
可扩充字符串值E表示："可扩充字符串"=hex(2):00,00

注册表有五个分支，下面是这五个分支的名称及作用：
名称                                          作用
HKEY_CLASSES_ROOT         存储Windows可识别的文档类型的详细列表，以及相关联的程序
HKEY_CURRENT_USER        存储当前用户设置的信息
HKEY_LOCAL_MACHINE       包括安装在计算机上的硬件和软件的信息
HKEY_USERS                         包含使用计算机的用户的信息
HKEY_CURRENT_CONFIG    这个分支包含计算机当前的硬件配置信息


类型介绍
二进制值 REG_BINARY原始二进制数据。大多数硬件组件信息作为二进制数据存储，以十六进制的格式显示在注册表编辑器中。

DWORD 值 REG_DWORD由 4 字节长（32 位整数）的数字表示的数据。设备驱动程序和服务的许多参数都是此类型，以二进制、十六进制或十进制格式显示在注册表编辑器中。与之有关的值是 DWORD_LITTLE_ENDIAN（最不重要的字节在最低位地址）和 REG_DWORD_BIG_ENDIAN（最不重要的字节在最高位地址）。

可扩展字符串值 REG_EXPAND_SZ长度可变的数据字符串。这种数据类型包括程序或服务使用该数据时解析的变量。
多字符串值 REG_MULTI_SZ多字符串。包含用户可以阅读的列表或多个值的值通常就是这种类型。各条目之间用空格、逗号或其他标记分隔。

字符串值 REG_SZ长度固定的文本字符串。

二进制值 REG_RESOURCE_LIST一系列嵌套的数组，用于存储硬件设备驱动程序或它控制的某个物理设备所使用的资源列表。此数据由系统检测并写入 \ResourceMap 树，作为二进制值以十六进制的格式显示在注册表编辑器中。

二进制值 REG_RESOURCE_REQUIREMENTS_LIST一系列嵌套的数组，用于存储设备驱动程序或它控制的某个物理设备可以使用的可能的硬件资源列表，系统将此列表的子集写入 \ResourceMap 树。此数据由系统检测，作为二进制值以十六进制的格式显示在注册表编辑器中。

二进制值 REG_FULL_RESOURCE_DESCRIPTOR一系列嵌套的数组，用于存储物理硬件设备使用的资源列表。此数据由系统检测并写入 \HardwareDescription 树，作为二进制值以十六进制的格式显示在注册表编辑器中

无 REG_NONE没有具体类型的数据。此数据由系统或应用程序写到注册表，作为二进制值以十六进制的格式显示在注册表编辑器中

链接 REG_LINK 一个 Unicode 字符串，它命名一个符号链接。
QWORD值 REG_QWORD由 64 位整数数字表示的数据。此数据作为二进制值显示在注册表编辑器中，最初用在 Windows 2000 
