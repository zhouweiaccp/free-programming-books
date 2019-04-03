netcore2.2-centos
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum update
sudo yum install dotnet-sdk-2.2

2.2-ubuntu.16.0.4
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2


The SSL connection could not be established on Ubuntu #32300 https://github.com/dotnet/corefx/issues/32300 
export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt 
export SSL_CERT_DIR=/dev/null

nuget install
rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo'
yum install mono-devel

 curl -o /usr/local/bin/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
 alias nuget="mono /usr/local/bin/nuget.exe"

https://www.mono-project.com/download/stable/#download-lin-centos
https://docs.microsoft.com/zh-cn/nuget/install-nuget-client-tools


dotnet nuget 用法
dotnet nuget add package NLog
dotnet pack   #运行 dotnet pack 命令，它也会自动生成项目
dotnet nuget push AppLogger.1.0.0.nupkg -k qz2jga8pl3dvn2akksyquwcs9ygggg4exypy3bhxy6w6x6 -s https://api.nuget.org/v3/index.json


https://docs.microsoft.com/zh-cn/dotnet/core/tools/global-json   
dotnet --list-sdks
dotnet new global.json --sdk-version 2.1.402
