#iis install
get-windowsfeature web*
install-windowsfeature web-server

Add-WindowsFeature WindowsPowerShellWebAccess


https://blog.csdn.net/toyesto/article/details/79889494?tdsourcetag=s_pcqq_aiomsg


#windowserver 2008
servermanagercmd.exe -query
servermanagercmd.exe -install FS-FileServer FS-Resource-Manager
servermanagercmd -remove FS-FileServer FS-Resource-Manager
servermanagercmd -remove FS-FileServer FS-Resource-Manager -restart

https://book.2cto.com/201301/13321.html