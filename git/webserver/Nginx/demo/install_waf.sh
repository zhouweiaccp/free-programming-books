#!/bin/bash
#https://github.com/loveshell/ngx_lua_waf
# https://github.com/unixhot/waf
# 支持IP白名单和黑名单功能，直接将黑名单的IP访问拒绝。
# 支持URL白名单，将不需要过滤的URL进行定义。
# 支持User-Agent的过滤，匹配自定义规则中的条目，然后进行处理（返回403）。
# 支持CC攻击防护，单个URL指定时间的访问次数，超过设定值，直接返回403。
# 支持Cookie过滤，匹配自定义规则中的条目，然后进行处理（返回403）。
# 支持URL过滤，匹配自定义规则中的条目，如果用户请求的URL包含这些，返回403。
# 支持URL参数过滤，原理同上。
# 支持日志记录，将所有拒绝的操作，记录到日志中去。
# 日志记录为JSON格式，便于日志分析，例如使用ELKStack进行攻击日志收集、存储、搜索和展示。
mkdir -p /data/src
cd /data/src
if [ ! -x "LuaJIT-2.0.0.tar.gz" ]; then  
wget http://luajit.org/download/LuaJIT-2.0.0.tar.gz
fi
tar zxvf LuaJIT-2.0.0.tar.gz
cd LuaJIT-2.0.0
make
make install PREFIX=/usr/local/lj2
ln -s /usr/local/lj2/lib/libluajit-5.1.so.2 /lib64/
cd /data/src
if [ ! -x "v0.2.17rc2.zip" ]; then  
wget https://github.com/simpl/ngx_devel_kit/archive/v0.2.17rc2.zip
fi
unzip v0.2.17rc2
if [ ! -x "v0.7.4.zip" ]; then  
wget https://github.com/chaoslawful/lua-nginx-module/archive/v0.7.4.zip
fi
unzip v0.7.4
cd /data/src
if [ ! -x "pcre-8.10.tar.gz" ]; then
wget http://blog.s135.com/soft/linux/nginx_php/pcre/pcre-8.10.tar.gz
fi
tar zxvf pcre-8.10.tar.gz
cd pcre-8.10/
./configure
make && make install
cd ..
if [ ! -x "nginx-1.2.4.tar.gz" ]; then
wget 'http://nginx.org/download/nginx-1.2.4.tar.gz'
fi
tar -xzvf nginx-1.2.4.tar.gz
cd nginx-1.2.4/
export LUAJIT_LIB=/usr/local/lj2/lib/
export LUAJIT_INC=/usr/local/lj2/include/luajit-2.0/
./configure --user=daemon --group=daemon --prefix=/usr/local/nginx/ --with-http_stub_status_module --with-http_sub_module --with-http_gzip_static_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module  --add-module=../ngx_devel_kit-0.2.17rc2/ --add-module=../lua-nginx-module-0.7.4/
make -j8
make install 
#rm -rf /data/src
cd /usr/local/nginx/conf/
wget https://github.com/loveshell/ngx_lua_waf/archive/master.zip --no-check-certificate
unzip master.zip
mv ngx_lua_waf-master/* /usr/local/nginx/conf/
rm -rf ngx_lua_waf-master
rm -rf /data/src
mkdir -p /data/logs/hack
chmod -R 775 /data/logs/hack