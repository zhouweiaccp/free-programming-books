
#https://minikube.sigs.k8s.io/docs/drivers/docker/
#https://kubernetes.io/docs/setup/learning-environment/minikube/#specifying-the-vm-driver

curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.9.2/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
minikube start --image-mirror-country cn \
    --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.9.0.iso \
    --registry-mirror=https://registry.docker-cn.com
minikube start --driver=docker
minikube dashboard