

 apt install -y xdg-utils
apt-get install python3-pip
#apt-get remove python3-pip
pip install --upgrade pip
pip install requests[security]  --user


## 修改pip默认安装目录
python -m site -help
/usr/lib/python2.7/site.py 


## install Scrapy
sudo yum groupinstall development tools 
sudo yum install python34-devel epel-release libxslt-devel libxml2-devel 

pip3 install Scrapy
sudo apt-get install build-essential python3-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev zlib1g-dev