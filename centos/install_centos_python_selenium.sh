#!/bin/bash

cat > /etc/yum.repos.d/google.repo <<efo
[google]
name=Google-x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
 
enabled=1
gpgcheck=0
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
efo


yum update
yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y unzip
#3、下载安装包

wget -N http://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip
#4、解压缩+添加执行权限

unzip chromedriver_linux64.zip
#5、移动
/usr/bin/google-chrome -version
sudo mv -f chromedriver /usr/local/share/chromedriver
#6、建立软连接

sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

pip3 install selenium

cat >test.py <<efo 
#!/usr/local/python3/bin/python3
 
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
 
 
 
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--no-sandbox')
url="https://www.west.cn/login.asp"
brower=webdriver.Chrome(executable_path="./chromedriver", chrome_options=chrome_options)
brower.get(url)
name=brower.find_element_by_xpath('//input[@name="u_name"]')
name.send_keys('******')
mima=brower.find_element_by_xpath('//input[@name="u_password"]')
mima.send_keys('******')
button=brower.find_element_by_xpath('//button[@class="g-commo"]')
button.click()
brower.refresh()
brower.get("https://www.west.cn/Manager/")
brower.quit()
efo
python3 test.py
