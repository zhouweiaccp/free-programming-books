安装:
1.安装samba
# yum install samba -y
2. 新建系统用户
# useradd user1 -s /sbin/nologin -M
3. 创建目录,更改权限
# mkdir /share && chown -R user1:user1 /share
4. 编辑配置文件
cat > /etc/samba/smb.conf <<EOF
[global]
workgroup = user1
server string = SAMBA SERVER
security = user
passdb backend = tdbsam

[share]
comment = share
path = /share
valid users = user1
browseable = no
read only = yes
write list = user1
EOF
5. 启动samba服务
# systemctl restart smb
6. 新建samba用户
# smbpasswd -a user1 根据提示两次输入密码.
7. 在windows上访问
打开:运行-----> 输入:\\X.X.X.X\share ---->根据提示输入用户名密码
其中x.x.x.x为samba的IP,