



cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
EOF


sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
#安装kubelet和docker

yum install -y docker kubelet kubeadm kubectl kubernetes-cni
systemctl enable docker
systemctl start docker
systemctl enable kubelet


cat > /etc/systemd/system/kubelet.service.d/20-pod-infra-image.conf <<EOF
[Service]
Environment="KUBELET_EXTRA_ARGS=--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/centos-bz/pause-amd64:3.0"
EOF
systemctl daemon-reload
systemctl restart kubelet
reboot


# ipv4 conver ipv6
cat <<EOF > /etc/sysctl.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p



export KUBE_REPO_PREFIX=registry.cn-hangzhou.aliyuncs.com/centos-bz
kubeadm init --pod-network-cidr 10.244.0.0/16 --kubernetes-version=v1.6.2



#配置KUBECONFIG环境变量
cp -f /etc/kubernetes/admin.conf $HOME/
chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >>  ~/.bash_profile

允许master运行pod
如果需要master作为worker运行pod，执行

kubectl taint nodes --all node-role.kubernetes.io/master-
添加node
在worker1和worker2执行。

kubeadm join --token a30d18.1600388a52b3b472 192.168.83.133:6443
以上命令为在master初始化成功后在控制台输出的命令。
查看pod运行情况:

kubectl get pods -n kube-system
安装flannel
kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
curl -sSL "https://github.com/coreos/flannel/blob/master/Documentation/kube-flannel.yml?raw=true" | kubectl create -f -
安装dashboard
curl -sSL https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml | sed 's#gcr.io/google_containers#registry.cn-hangzhou.aliyuncs.com/centos-bz#' | kubectl create -f -
执行如下命令来找到dashboard的端口:

[root@master ~]# kubectl get service  -n kube-system | grep kubernetes-dashboard
kubernetes-dashboard   10.100.79.47   <nodes>       80:32574/TCP    4h
如上端口为32574，可以在浏览器打开http://worker1:32574访问控制面板。

安装nginx ingress controller
安装default backend
curl -sSL https://raw.githubusercontent.com/kubernetes/ingress/nginx-0.9.0-beta.5/examples/deployment/nginx/default-backend.yaml | sed 's#gcr.io/google_containers#registry.cn-hangzhou.aliyuncs.com/centos-bz#' |  kubectl apply -f -
安装nginx ingress controller
新建ingress-rbac.yaml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: ingress
  namespace: kube-system
 
---
 
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: ingress
subjects:
  - kind: ServiceAccount
    name: ingress
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
新建nginx-ingress.yml:

apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: nginx-ingress-lb
  labels:
    name: nginx-ingress-lb
  namespace: kube-system
spec:
  template:
    metadata:
      labels:
        name: nginx-ingress-lb
      annotations:
        prometheus.io/port: '10254'
        prometheus.io/scrape: 'true'
    spec:
      terminationGracePeriodSeconds: 60
      serviceAccountName: ingress
      hostNetwork: true
      containers:
      - image: registry.cn-hangzhou.aliyuncs.com/centos-bz/nginx-ingress-controller:0.9.0-beta.5
        name: nginx-ingress-lb
        readinessProbe:
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
        livenessProbe:
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          timeoutSeconds: 1
        ports:
        - containerPort: 80
          hostPort: 80
        - containerPort: 443
          hostPort: 443
        env:
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
        args:
        - /nginx-ingress-controller
        - --default-backend-service=$(POD_NAMESPACE)/default-http-backend
创建nginx ingress controller

kubectl create -f ingress-rbac.yaml
kubectl apply -f nginx-ingress.yml
在worker1和worker2使用ss -nlpt命令查看80和443端口是否已经监听。

测试
测试ingress
部署echo server

kubectl run echoheaders --image=registry.cn-hangzhou.aliyuncs.com/centos-bz/echoserver:1.4 --replicas=1 --port=8080
新建service

kubectl expose deployment echoheaders --port=80 --target-port=8080 --name=echoheaders-x
kubectl expose deployment echoheaders --port=80 --target-port=8080 --name=echoheaders-y
新建ingress.yaml:

# An Ingress with 2 hosts and 3 endpoints
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echomap
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: echoheaders-x
          servicePort: 80
  - host: bar.baz.com
    http:
      paths:
      - path: /bar
        backend:
          serviceName: echoheaders-y
          servicePort: 80
      - path: /foo
        backend:
          serviceName: echoheaders-x
          servicePort: 80
新建规则

kubectl create -f ingress.yaml
使用curl测试：

curl 192.168.83.135/foo -H 'Host: foo.bar.com'
curl 192.168.83.135/other -H 'Host: foo.bar.com'


#https://www.cnblogs.com/lonelyxmas/p/10621663.html
# 原文链接：https://blog.csdn.net/maliao1123/article/details/79379390