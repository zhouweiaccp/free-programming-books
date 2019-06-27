https://www.cnblogs.com/ly-radiata/articles/6119374.html

使用 Let's Encrypt（Certbot） 配置 HTTPS
今天又折腾了一下 Let's Encrypt，发现距离上次不久就已经忘了怎么做了。不得不再扒一遍文档。 这次记录下来。

上次折腾时，Let's Encrypt 还叫 Let's Encrypt ，这次已经改名为 Certbot 了。 并且上次是使用 git 下载，这次可以直接 wget 了。

安装

$ wget https://dl.eff.org/certbot-auto
$ chmod a+x ./certbot-auto
$ ./certbot-auto
这个小工具会自动下载并安装相关依赖和 Python 包。稍等一下就完成了。

生成证书

生成证书过程中需要鉴权。有多种方式，比如 webroot 、 standalone 、 apache、 nginx 、 manual 等。我使用过前两种。 这两种中，简单一点的是 standalone。不过，这种方式需要把现有的 WebServer 停掉，因为这种方式下 certbot 需要占用 80 端口。

# ./certbot-auto certonly --text --agree-tos --email webmaster@example.com --standalone -d example.com -d www.example.com -d service.example.com
-d 参数指定域名，可多个。一般第一个是主域名。

webroot 方式稍微繁琐一些，但好处是不需要关停现有的 WebServer 。此方法需要在域名对应的根目录下新建 .well-known 目录并写入若干文件供验证服务访问。 因此需要配置 WebServer 允许外部访问 http://example.com/.well-known 路径。配置方法请参考相应 WebServer 的文档。Nginx 的默认配置应该不用修改，Apache 就不知道了。 另外，不同的域名的根路径可能不同，下面的例子中可以看到为不同的域名指定不同的根路径。

# ./certbot-auto certonly --text --agree-tos --email webmaster@excample.com --webroot -w /var/www/example -d example.com -d www.example.com -w /var/service/example -d service.ulefa.com
无论使用那种方式，运行以上命令后都会在 /etc/letsencrypt 生成一堆东西，包括证书。

修改 WebServer 配置以提供 HTTPS 服务

这里以 Nginx 作例子吧。

打开 Nginx 的配置文件（默认为： /etc/nginx/nginx.conf ），在需要提供 HTTPS 的 server 下新增以下三行，并把 listen 80; 删掉：
listen 443 ssl;
ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
新增以下 server 使所有 HTTP 请求都跳转至 HTTPS ：
server {
listen   80;
server_name example.com www.example.com service.example.com;
return 301 https://$host$request_uri;
}
定期 renew

Let's Encrypt 的证书有效期为 90 天，所以需要在到期前 renew 一下证书。 使用以下命令即可。

# ./certbot-auto renew --text --agree-tos --email webmaster@excample.com --webroot -w /var/www/example -d example.com -d www.example.com -w /var/service/example -d service.ulefa.com
或者直接运行以下命令，此时 certbot 会使用默认参数（此例为： /etc/letsencrypt/renewal/example.com.conf ）：

# ./certbot-auto renew
又或者在 crontab 里加入定时任务，每隔 80 天的凌晨 4 点执行一次 renew：

0 4 */80 * * /path/to/certbot-auto renew &>> /dev/null