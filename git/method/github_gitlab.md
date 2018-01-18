github和gitlab仓库一起使用 

github是网络公有代码仓库，一般用于私人代码托管，而gitlab一般是企业搭建的内部代码仓库。工作期间，我们都会同时用到这两个仓库。可公司邮箱与个人邮箱是不同的，由此产生的 SSH key 也是不同的，这就造成了冲突 。如何在一台机器上面同时使用 Github 与 Gitlab 的服务？
1.生成秘钥
公司的GitLab生成一个SSH-Key
# 在~/.ssh/目录会生成gitlab_id-rsa和gitlab_id-rsa.pub私钥和公钥。我们将gitlab_id-rsa.pub中的内容粘帖到公司GitLab服务器的SSH-key的配置中。
$ ssh-keygen -t rsa -C "注册的gitlab邮箱" -f ~/.ssh/gitlab_id-rsa
公网github生成一个SSH-Key
# 在~/.ssh/目录会生成github_id-rsa和github_id-rsa.pub私钥和公钥。我们将github_id-rsa.pub中的内容粘帖到github服务器的SSH-key的配置中。
$ ssh-keygen -t rsa -C "注册的github邮箱" -f ~/.ssh/github_id-rsa
 
2.添加config
 在~/.ssh下添加config配置文件,内容如下：

# github key
Host github
    Port 22
    User git
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/github_id-rsa
Host gitlab
    Port 22
    User git
    HostName gitlab.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/gitlab_id-rsa

  下面对上述配置文件中使用到的配置字段信息进行简单解释：

Host
    它涵盖了下面一个段的配置，我们可以通过他来替代将要连接的服务器地址。
    这里可以使用任意字段或通配符。
    当ssh的时候如果服务器地址能匹配上这里Host指定的值，则Host下面指定的HostName将被作为最终的服务器地址使用，并且将使用该Host字段下面配置的所有自定义配置来覆盖默认的`/etc/ssh/ssh_config`配置信息。
Port
    自定义的端口。默认为22，可不配置
User
    自定义的用户名，默认为git，可不配置
HostName
    真正连接的服务器地址
PreferredAuthentications
    指定优先使用哪种方式验证，支持密码和秘钥验证方式
IdentityFile
    指定本次连接使用的密钥文件

 
 3.配置仓库
 假设gitlab与jgithub的工作目录分别如下所示：
github工作仓库:~/workspace/github
gitlab工作仓库:~/workspace/gitlab
则配置如下：

#gitlab
cd ~/workspace/gitlab
git init
git config --global user.name 'gitlab'
git config --global user.email 'gitlab@company.com'

#github
cd ~/workspace/github
git init
git config --local user.name 'personal'
git config --local user.email 'personal@163.com'

4.测试
# 测试github
$ ssh -T git@github.com
 
# 测试gitlab
$ ssh -T git@gitlab.com