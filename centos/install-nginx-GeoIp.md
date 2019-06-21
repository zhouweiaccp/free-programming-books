https://nginx.org/en/linux_packages.html#RHEL-CentOS
 yum install yum-utils
To set up the yum repository, create the file named /etc/yum.repos.d/nginx.repo with the following contents:

[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key

By default, the repository for stable nginx packages is used. If you would like to use mainline nginx packages, run the following command:

yum-config-manager --enable nginx-mainline
yum install -y nginx



https://www.centos.bz/2018/04/nginx-%E4%BD%BF%E7%94%A8-geoip-%E6%A8%A1%E5%9D%97%E5%8C%BA%E5%88%86%E7%94%A8%E6%88%B7%E5%9C%B0%E5%8C%BA/



$ nginx -V
nginx version: nginx/1.12.2
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --user=nginx --group=nginx --with-http_geoip_module --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-file-aio
如果版本信息中包含 –with-http_geoip_module，则说明已经支持该模块，如果不支持请往下看

安装 GeoIP
首先安装依赖

$ yum -y install zlib zlib-devel
安装 GeoIP
$ wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz
$ tar -zxvf GeoIP.tar.gz
$ cd GeoIP-1.4.8
$ ./configure
$ make
$ make install
使用ldconfig将库索引到系统中

$ echo '/usr/local/lib' > /etc/ld.so.conf.d/geoip.conf
$ ldconfig
检查库是否加载成功

$ ldconfig -v | grep GeoIP
libGeoIPUpdate.so.0 -> libGeoIPUpdate.so.0.0.0
libGeoIP.so.1 -> libGeoIP.so.1.4.8
libGeoIPUpdate.so.0 -> libGeoIPUpdate.so.0.0.0
libGeoIP.so.1 -> libGeoIP.so.1.5.0
将 GeoIP 模块编译到 Nginx 中
根据你当前 Nginx 的安装参数带上 –with-http_geoip_module 重新编译

$ ./configure --user=nginx --group=nginx \
    --with-http_geoip_module \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio
$ make && make install
或者重新安装

$ wget https://nginx.org/download/nginx-1.12.2.tar.gz
$ tar zxvf nginx-1.12.2.tar.gz
$ cd nginx-1.12.2
$ ./configure --user=nginx --group=nginx \
    --with-http_geoip_module \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio
$ make && make install
使用 GeoIP
首先查看本地是否已有 GeoIP 数据库

$ cd /usr/local/share/GeoIP
$ ll
-rw-r--r--. 1 root root  1183408 Mar 31 06:00 GeoIP.dat
-rw-r--r--. 1 root root 20539238 Mar 27 05:05 GeoLiteCity.dat
如果没有这两个库，则手动下载

wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gzip GeoLiteCity.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
gzip GeoIP.dat.gz
将库地址配置到 nginx.conf 中这个位置

http{
    ...
    geoip_country /usr/local/share/GeoIP/GeoIP.dat;
    geoip_city /usr/local/share/GeoIP/GeoLiteCity.dat;
    server {
        location / {
            root /www;
            if( $geo_country_code = CN ){
                root /www/zh;
            }
        }
    }
}
其他参数

$geoip_country_code; – 两个字母的国家代码，如：”RU”, “US”。
$geoip_country_code3; – 三个字母的国家代码，如：”RUS”, “USA”。
$geoip_country_name; – 国家的完整名称，如：”Russian Federation”, “United States”。
$geoip_region – 地区的名称（类似于省，地区，州，行政区，联邦土地等），如：”30”。 30代码就是广州的意思
$geoip_city – 城市名称，如”Guangzhou”, “ShangHai”（如果可用）。
$geoip_postal_code – 邮政编码。
$geoip_city_continent_code。
$geoip_latitude – 所在维度。
$geoip_longitude – 所在经度。