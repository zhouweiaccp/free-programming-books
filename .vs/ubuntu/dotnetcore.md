

[url](https://www.microsoft.com/net/download/linux-package-manager/ubuntu16-04/sdk-current)
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
Install .NET SDK
Update the products available for installation, then install the .NET SDK.

In your command prompt, run the following commands:

sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.1