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
