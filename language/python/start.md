

 apt install -y xdg-utils
apt-get install python3-pip
#apt-get remove python3-pip
pip install --upgrade pip
pip install requests[security]  --user


## 修改pip默认安装目录
python -m site -help
/usr/lib/python2.7/site.py 