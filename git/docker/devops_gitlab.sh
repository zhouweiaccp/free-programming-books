
# https://www.cnblogs.com/heyixiaoran/p/9603011.html
docker pull gitlab/gitlab-ce
2.Run GitLab 
复制代码
  docker run -d 
  --name gitlab 
  --restart always 
  --hostname 192.168.0.218
  --env GITLAB_OMNIBUS_CONFIG="external_url 'http://192.168.0.218/'; gitlab_rails['lfs_enabled'] = true;" 
  -p 443:443 -p 80:80 -p 22:22 
  -v /srv/gitlab/config:/etc/gitlab 
  -v /srv/gitlab/logs:/var/log/gitlab 
  -v /srv/gitlab/data:/var/opt/gitlab  
  gitlab/gitlab-ce:latest
复制代码
 这一步很慢，要好几分钟，可以查看 log ，看到 ok 再访问，host 必须要设置，不然会是 docker 生成的一个数字，现在你就可以访问 http://localhost 看到 GitLab 了

3.生成 Token


这是留着下边用的

 

3.注册 GitLab Runner


其中第2个的 token 是在 gitlab 里 Setting——CI/CD——Runner 里给的（如下图），成功后可以在 gitlab 里看到一个 runner



4.拉取 SonarQube
docker pull sonarqube
5.Run SonarQube
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
 现在你就可以访问你的 http://localhost:9000 , 登录——用户名：admin 密码：admin

1.Token——gitlab 的 Setting——Access Tokens——Personal Access Tokens

2.选择项目语言，填写 unique project key

3.根据右边弹出提示完成步骤

下载：https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+MSBuild

命令：

SonarQube.Scanner.MSBuild.exe begin /k:"testproject2" /d:sonar.host.url="http://localhost:9000" /d:sonar.login="ae471877adee54f312188a0b5d92be11289c1436"

MsBuild.exe /t:Rebuild

SonarQube.Scanner.MSBuild.exe end /d:sonar.login="ae471877adee54f312188a0b5d92be11289c1436"

 

 为了把 SonarQube 加到 gitlab 里，需要在 SonarQube 里添加 GitLab ，方法 Administration——Marketplace 添加上 GitLab

 然后在配置里找到 GitLab 标签，右边填写上 GitLab url 和 GitLab User Token



6.配置  .gitlab-ci.yml
 由于我还不熟悉配置这个地方，先略过一下

7.拉取 Jenkins
docker pull jenkins/jenkins
8.Run Jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
这时会出现很多日志，但都不重要，最后出现的*******的位置的才重要，因为是 Unlock Jenkins 的密钥，你说重要不重要，简单截个图



如果你忘了复制这个也没关系，再用命令找回来就可以

docker logs jenkins（镜像名称）
访问 http://localhost:8800/，输入密钥，安装插件，填写 admin 密码。

 9.配置 Jenkins 
1. 安装 GitLab 插件：系统管理——插件管理——安装 GitLab 插件，重启 Jenkins

2. 配置 GitLab：系统管理——系统设置——填写 GitLab 配置

 

Add 里边选 GitLab API token，然后填上之前的 GitLab 的 Token



之后就是创建任务了，具体还是要根据你的项目需要来决定，这里先略过一下

9.拉取 Portainer
docker pull portainer/portainer
10.Run Portainer
docker run -d --name portainer -p 9090:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
注册一个用户 



点击 local  后进入到 dashboard 页面，也可以管理公有云上的，此处以单机版为例




如图所示，这里可以很轻松的创建和管理  Container ，比上边的命令好用很多，比如 Containers 菜单里的 Create Container 可以创建一个新的 Container。更多功能等待你的挖掘，此处略过，只是想告诉大家先学习基础再用工具，基础还是很重要的