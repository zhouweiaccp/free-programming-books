安装

支持类库

sudo apt-get install python python-dev python-distribute python-pip libcurl4-openssl-dev libxml2-dev libxslt1-dev python-lxml libpcap-dev libpq-dev
安装pip

sudo apt-get install python-pip
安装phantomjs

sudo apt-get install phantomjs
安装pyspider

pip install pyspider
运行程序

pyspider all
然后在浏览器打开 http://localhost:5000，出现下面的图片代表正常安装
图片描述

自己安装中遇到的错误

error: command 'x86_64-linux-gnu-gcc' failed with exit status 1

执行以下命令解决

sudo apt-get install libpcap-dev libpq-dev

# https://segmentfault.com/a/1190000007539099