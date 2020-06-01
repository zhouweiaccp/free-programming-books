




## install

centos7.4 系统
swapoff -a  # 关闭swap
sytemctl stop firewalld
systemctl disable firewalld
sed -i 's/enforcing/disabled' /etc/selinux/config
setenfore 0


### 1.minkube
- [](https://kubernetes.io/zh/docs/tasks/tools/install-minikube/)

### 2.kubeadm
- [kubeadmin](kubeadm)


###　3二进制
- [二进制](https://www.cnblogs.com/lonelyxmas/p/10621762.html)



### window minikube
- [](https://minikube.sigs.k8s.io/docs/drivers/hyperv/)
- [](https://minikube.sigs.k8s.io/docs/start/)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install minikube
minikube start

## link
- [concepts](https://kubernetes.io/zh/docs/concepts/)
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()