#!/bin/bash
#https://docs.microsoft.com/zh-cn/dotnet/core/install/dependencies?tabs=netcore31&pivots=os-windows
#https://docs.microsoft.com/zh-cn/dotnet/core/install/linux-package-manager-ubuntu-1804
set -x
currentDate=`date "+%Y%m%d%H%M%S"`
cpu1=`arch`
echo $cpu1
if [ $cpu1='aarch64' ];then
	#https://dotnet.microsoft.com/download/dotnet-core/thank-you/sdk-3.1.100-linux-arm64-binaries
echo 'install bin.........'
wget https://download.visualstudio.microsoft.com/download/pr/5a4c8f96-1c73-401c-a6de-8e100403188a/0ce6ab39747e2508366d498f9c0a0669/dotnet-sdk-3.1.100-linux-arm64.tar.gz
mkdir -p /usr/share/dotnet && tar zxf dotnet-sdk-3.1.100-linux-arm64.tar.gz -C /usr/share/dotnet
cp  /etc/profile  /etc/profile_${currentDate}
rm dotnet-sdk-3.1.100-linux-arm64.tar.gz
echo "PATH=$PATH:/usr/share/dotnet" >> /etc/profile
source /etc/profile
#export DOTNET_ROOT=$HOME/dotnet
#export PATH=$PATH:$HOME/dotnet
exit 0
fi

sudo apt-get install -y gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
sudo apt-get install -y apt-transport-https
sudo apt-get update



sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
echo 'install......................................'
sudo apt-get install -y dotnet-sdk-3.1

sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install aspnetcore-runtime-3.1