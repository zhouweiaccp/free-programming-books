yum install -y zip unzip git
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum install docker-ce-18.03.1.ce &&systemctl start docker && systemctl enable docker
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm && yum update && yum install -y dotnet-sdk-2.2