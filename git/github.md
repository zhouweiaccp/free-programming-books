# windows客户端安装
 - Git-2.8.1-64-bit.exe
 - 设置姓名
git config --global user.name "wei.zhou"
- 设置email
git config --global user.email " wei.zhou @qq.com"
- ssh-keygen
 直接回车，默认保存私钥到用户目录下的.ssh/id_rsa文件中，
公钥保存到用户目录下的.ssh/id_rsa.pub文件中。这时会提示要求输入密码：
Enter passphrase (empty for no passphrase):
这个是保护私钥的密码，使用私钥时需要输入这个密码。
如不输入，则不适用密码，直接回车。


关于github【Permission denied (publickey
chmod 755 ~/.ssh/  
chmod 600 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub   
chmod 644 ~/.ssh/known_hosts 



# search
(1)按照文件搜索
  android in:file
(2)按照路径检索
 andrioid in:path

(3) 按照语言检索

android language:java

(4)按照文件大小

android size:>00

(5)按照后缀名检索

android extention:css

(6)按照是否被fork过

android fork:true

（7）按照地域检索（这个猎头和hr应该用得着）

项目的github’地址。欢迎大家补充

android location:beijing