




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

## 常用命令
kubectl --kubeconfig=/home/pimrec/it-ufm-zxdev.kubeconfig delete -f /home/edoc2/dockercompose/ci/dev/dev-master/edoc2.yml
kubectl --kubeconfig=/home/pimrec/it-ufm-zxdev.kubeconfig apply -f /home/edoc2/dockercompose/ci/dev/dev-master/edoc2.yml

kubectl-dev -n it-ufm logs -f edoc2-76f4c4c875-kztl8
kubectl-dev get pods
kubectl-dev exec -it edoc2-76f4c4c875-kztl8  -n it-ufm  /bin/sh

 kubectl get pods -o wide  #查看所有的pods（详细）
 kubectl get pod --all-namespaces

## link
- [concepts](https://kubernetes.io/zh/docs/concepts/)
- [k8s-deploy](https://github.com/cookcodeblog/k8s-deploy/blob/master/kubeadm_v1.13.0/03_install_kubernetes.sh) kubernetes 安装手册
- [kubeadm-playbook](https://github.com/ReSearchITEng/kubeadm-playbook/tree/master/demo)
- [Longhorn](https://github.com/longhorn/longhorn) 存储 Longhorn is a distributed block storage system for Kubernetes
- [Rancher](https://rancher.com/docs/rancher/v1.6/en/catalog/)Rancher是一个用于部署和管理生产环境的容器的开源平台,
- []()
- []()
- []()
- []()
- []()
- []()