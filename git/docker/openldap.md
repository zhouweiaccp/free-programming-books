https://github.com/osixia/docker-openldap
https://hub.docker.com/r/windfisch/phpldapadmin/


--demo
https://github.com/samisalkosuo/openldap-docker
Get Docker image: docker pull kazhar/openldap-demo
Run Docker image: docker run -d -p 389:389 kazhar/openldap-demo
Login to server:
Base DN: dc=farawaygalaxy,dc=net
Admin user: cn=admin,dc=farawaygalaxy,dc=net
Password: passw0rd
Or you can download/clone this repo and create and build your own image.




## test
https://www.ibm.com/support/knowledgecenter/zh/SSTFXA_6.3.0/com.ibm.itm.doc_6.3/adminuse/msad_ldap_vertools.htm

ldapsearch
使用此工具来测试命令行中的连接字符串，并验证是否指向 LDAP 用户注册表中的正确位置。图 2 显示了 ldapsearch 输出样本。
应用于 LDAP 信息的 Ldapsearch包含有关此命令及其用法和选项的更多信息。

您指定的 ldapsearch 选项（请参阅ldapsearch 命令行选项）基于站点的 Tivoli Enterprise Monitoring Server LDAP 配置：
-h
是 LDAP 主机名。
-p
是 LDAP 端口名。
-b
是 LDAP 基点值。
-D
是 LDAP 绑定标识。
-w
是 LDAP 绑定密码。
注：
如果未指定 -w 选项，那么需要从键盘输入 LDAP 绑定密码。
务必指定 ldapsearch -s sub 选项，这是因为，监视服务器的 LDAP 客户机在认证 Tivoli Monitoring 用户时将使用此选项。在指定 LDAP 用户过滤器（此字符串是 ldapsearch 命令行的最后一部分）时，请将 %v 替换为 Tivoli Monitoring 用户标识。
示例：要使用图 1 所示的监视服务器 LDAP 配置来验证用户 sysadmin，请指定以下 ldapsearch 命令：
ldapsearch -h 192.168.3.124 -p 389 -b "dc=farawaygalaxy,dc=net"
           -D "cn=admin,dc=farawaygalaxy,dc=net" -w passw0rd
           -s sub "(mail=sysadmin@bjomain.com)"

### 示例
 yum install -y openldap-clients
 ldapsearch -h 192.168.253.124 -p 389 -b "dc=farawaygalaxy,dc=net" -D "cn=admin,dc=farawaygalaxy,dc=net" -w passw0rd