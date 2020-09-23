
## registry
- [](https://docs.docker.com/registry/)

docker run -d -p 5000:5000 --name registry registry:2
docker pull ubuntu
docker image tag ubuntu localhost:5000/myfirstimage
docker push localhost:5000/myfirstimage


## Harbor 

-[](https://goharbor.io/docs/2.1.0/install-config/installation-prereqs/)