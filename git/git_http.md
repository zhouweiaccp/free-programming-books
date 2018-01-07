1.安装git
[html] view plain copy
sudo apt-get install git git-core  

2.配置git的http代理
①安装apache
[html] view plain copy
sudo apt-get install apache2 apache2-utils  

②激活下面的模块
[html] view plain copy
sudo a2enmod cgi alias env rewrite  

③修改apache的配置文件
[html] view plain copy
sudo vi /etc/apache2/sites-enabled/000-default.conf  

之后往里面加入如下内容
[html] view plain copy
SetEnv GIT_PROJECT_ROOT /var/www/html/git  
SetEnv GIT_HTTP_EXPORT_ALL  
ScriptAlias /git/ /usr/lib/git-core/git-http-backend/  
   
RewriteEngine On  
RewriteCond %{QUERY_STRING} service=git-receive-pack [OR]  
RewriteCond %{REQUEST_URI} /git-receive-pack$  
RewriteRule ^/git/ - [E=AUTHREQUIRED]  
   
<Files "git-http-backend">  
    AuthType Basic  
    AuthName "Git Access"  
    AuthUserFile /var/www/html/.htpasswd(此处位置与下文创建用户验证一致)  
    Require valid-user  
    Order deny,allow  
    Deny from env=AUTHREQUIRED  
    Satisfy any  
</Files>  

④创建用户验证
[html] view plain copy
sudo htpasswd –c /var/www/html/.htpasswd zwj(用户名)  
首次添加的时候要加-c选项,之后添加的时候去掉-c选项,不然会将原有的账户删除  


(1)进入部署web项目的目录,如/var/www/html/

(2)新建git文件夹
[html] view plain copy
sudo mkdir git  
cd git  

(3)初始化git仓库
[html] view plain copy
sudo git init --bare zwj.git (最后面的名字随意取,为了命名规范,一般使用.git结尾)  

4.修改/var/www/目录的所属者和所有者权限
[html] view plain copy
chown -R www-data: www-data /var/www/  

5.启动apache
[html] view plain copy
sudo service apache2 restart  

根据以上步骤配置好之后,就可以使用http的方式去同步git项目,路径为
http://ip/git/zwj.git(最后的名字自行替换成你新建git仓库时候的名字)

软硬件环境

Pentium Dual-Core CPU，32 bits
ubuntu 12.04 LTS
apache 2.4.7
git 1.9.1
apache2、git、gitweb的安装：

apt-get install git
apt-get install gitweb
apt-get install apache2
2、创建git库

我选择在/srv/目录下创建一个bare repo，叫test.git，并把该目录下所有文件的所有者和组都改成www-data（apache2的默认所有者和默认组），以便apache2有权限访问它。

cd /srv
git init --bare test.git
chown -R www-data:www-data test.git
3、配置apache2

apache2的总配置文件是/etc/apache2/apache2.conf，它会读取/etc/apache2/sites-enabled/下的配置文件。而该目录下的文件，一般是/etc/apache2/sites-available/下配置文件的软链接。

打开/etc/apache2/apache2.conf，在最后添加如下内容。每条命令的解释，见注释。

# 默认apache2只对两个目录（/usr/share和/var/www）有访问权限，如下指令赋予apache2对/srv的访问权限。
<Directory /srv/>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

# 如果没有这句，在其他机器上执行git clone等命令会返回403错误，参照最后一条“参考”
<Location />
    Options +ExecCGI
    Require all granted
</Location>

# 设置git的工程目录
SetEnv GIT_PROJECT_ROOT /srv/
# 默认情况下，含有git-daemon-export-ok文件的目录才可以被导出（用作git库目录）。设置这个环境变量以便所有目录都可以被导出
SetEnv GIT_HTTP_EXPORT_ALL

# 虚拟主机，匹配80端口的任何ip地址的请求，访问gitweb
<virtualhost *:80>
    # 顺便在/etc/hosts里添加上一句：127.0.0.1 git.example.com。这样，在服务器上可以通过该名字访问这个页面
    ServerName git.example.com
    DocumentRoot /usr/share/gitweb
    ErrorLog ${APACHE_LOG_DIR}/git_error.log
    CustomLog ${APACHE_LOG_DIR}/git_access.log combined
</virtualhost>

# gitweb目录添加ExecCGI的功能
<Directory /usr/share/gitweb>
    Options FollowSymLinks ExecCGI
    AddHandler cgi-script .cgi
    DirectoryIndex gitweb.cgi
</Directory>

# 对git库的各种请求，执行git-http-backend.cgi
ScriptAliasMatch \
    "(?x)^/(.*/(HEAD | \
    info/refs | \
    objects/(info/[^/]+ | \
     [0-9a-f]{2}/[0-9a-f]{38} | \
     pack/pack-[0-9a-f]{40}\.(pack|idx)) | \
    git-(upload|receive)-pack))$" \
    /usr/lib/git-core/git-http-backend/$1
# 其余的请求，执行gitweb.cgi
ScriptAlias / /usr/share/gitweb/gitweb.cgi

# 设置git push等操作的认证方式为文件认证，/var/www/git-auth后面会创建。
<LocationMatch "^/.*/git-receive-pack$">
    AuthType Basic
    AuthName "Git Access"
    Require valid-user
    AuthBasicProvider file
    AuthUserfile /var/www/git-auth
</LocationMatch>
4、push操作的认证

默认git-http-backend的upload-pack是被置为真的，即可以执行git clone/pull/fetch。但是，默认receive-pack是被置为false，即不能git push。为了支持带认证的git push，需要两步操作。

第一步，打开/srv/test.git/config，添加如下内容：

[http]
    receivepack = true
如果不加上面这句，git clone下来的版本库，git push时会提示403错误，即没有授权。

第二步，生成一个包含用户名和密码的文件，该文件能被apache2读取，作为文件认证的依据。假设我要添加两个用户mashu和ouyang，密码在提示下输入，我要执行如下命令：

cd /var/www
htpasswd -c git-auth mashu
htpasswd git-auth ouyang 
有了这个文件，添加到上面的apache2的配置文件中即可。

5、gitweb的配置

修改/etc/gitweb.conf中的一句：

$projectroot = "/srv"
6、重启apache2

service apache2 restart
7、客户端检查

在客户端电脑上，找一个目录，执行如下命令

git clone http://server-ip/test.git test-repo
cd test-repo
echo "aaa" > file
git add file && git commit -am "first commit"
git push
然后，在浏览器上输入http://server-ip，查看刚才的操作是否记录到gitweb上了