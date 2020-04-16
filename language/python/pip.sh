#!/bin/bash
#https://blog.csdn.net/sinat_21591675/article/details/82770360
# (b) windows下，直接在user目录中创建一个pip目录，如：C:\Users\xx\pip，然后新建文件pip.ini，即 %HOMEPATH%\pip\pip.ini，在pip.ini文件中输入以下内容（以豆瓣镜像为例）：

# [global]
# index-url = http://pypi.douban.com/simple
# [install]
# trusted-host = pypi.douban.com
mkdir ~/.pip
cat > ~/.pip/pip.conf<<efo
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
efo
#Windows更换pip/pip3源
#打开目录：%appdata%
#新增pip文件夹，新建pip.ini文件
#给pip.ini添加内容
#[global]
#timeout = 6000
#index-url = https://pypi.tuna.tsinghua.edu.cn/simple
#trusted-host = pypi.tuna.tsinghua.edu.cn



# 以下可以选用其一

# # 清华：
# pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# # 阿里：
# pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
# # 华为：
# pip config set global.index-url https://mirrors.huaweicloud.com/repository/pypi/simple
# # 豆瓣：
# pip config set global.index-url https://pypi.douban.com/simple
