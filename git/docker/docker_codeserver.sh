

docker run -it -p 192.168.251.119:8181:8080 \
      -v "$PWD:/home/coder/project" \
        -u "$(id -u):$(id -g)" \
          codercom/code-server:latest


# https://github.com/cdr/code-server
# https://github.com/bboysoulcn/awesome-dockercompose/blob/master/code-server/docker-compose.yaml