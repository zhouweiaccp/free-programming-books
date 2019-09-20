https://www.jianshu.com/p/d978d3b8f2aa
1、第一个问题，anyproxy怎么安装，首先是拿到一台云主机，先安装node(因为anyproxy需要node环境)，再安装npm(npm是用来管理node的)，然后用npm安装anyproxy，最后用npm安装pm2(pm2是用来管理anyproxy的)。下面以Ubuntu16.04为例，使用root用户，安装node，执行命令，

apt install nodejs-legacy
检查node是否安装成功，执行命令，

node --version
安装npm，执行命令，

apt install npm
检查npm是否安装成功，执行命令，

npm --version
安装anyproxy，执行命令，

npm install anyproxy -g
注意后面的-g不能少，检查anyproxy是否安装成功，执行命令，

anyproxy --version
安装pm2，执行命令，

npm install pm2 -g
后面的-g也不能少，检查pm2是否安装成功，执行命令，

pm2 --version
然后执行命令启动anyproxy，

anyproxy
这里有可能会出现TypeError: Buffer.alloc is not a function的错误，


anyproxy启动错误

这是因为node版本和npm版本不够，需要升级node和npm，升级npm，执行命令，

npm install npm -g
升级node，执行两条命令，

npm install -g n 
n stable
但是你可能会发现执行node --version和npm --version还是显示原来的版本，其实你已经升级好node和npm的了，只是当前命令行窗口还没刷新过来，如果你新开一个命令行窗口执行node --version和npm --version，就会显示升级后的版本的了。现在再启动执行命令anyproxy启动anyproxy，如果出现以下就是anyproxy启动成功，


anyproxy启动成功

进一步访问网址进行anyproxy的启动验证，访问服务器ip:8002，


anyproxy网址访问

但是这样启动anyproxy只能代理http，如果要能代理https，需要执行生成ca证书的命令，
anyproxy-ca
回车确认下去既可，然后执行以下命令来启动anyproxy，

anyproxy -i
anyproxy就可以代理https了，但是这样子无法关闭命令行，所以需要用到pm2来管理anyproxy，可以执行命令，

pm2 start anyproxy -x -- -i
通过pm2来初始化并启动一个anyproxy，启动anyproxy后可以随时关闭命令行，若要查看anyproxy启动状况，执行命令，

pm2 list
若要关闭anyproxy，执行命令，

pm2 stop anyproxy
若要再启动anyproxy，执行命令，

pm2 start anyproxy
若要重启anyproxy，执行命令，

pm2 restart anyproxy
pm2管理anyproxy
2、第二个问题，anyproxy怎么在一台机器上开多个实例，上面的第一点只说到了用pm2开一个anyproxy实例，其实anyproxy是可以开多个实例的，因为anyproxy可以指定端口指定规则文件来启动。先用回直接anyproxy启动的方式来演示怎么启动不同端口不同规则文件的anyproxy实例，启动第一个anyproxy实例，执行命令，

anyproxy -i -p 8001 -w 8002 -r /usr/local/lib/node_modules/anyproxy/lib/rule_default.js
访问服务器ip:8002检查是否成功，-p参数后面跟的代理端口即手机wifi连接anyproxy代理时的端口，-w参数后面跟的是web端口即在浏览器上查看代理情况的端口，-r参数后面跟的是rule规则文件路径，rule_default.js的文件路径默认是在/usr/local/lib/node_modules/anyproxy/lib/下，其实开多个实例主要是因为rule规则文件的不同。这里的启动你可能会发现有一点不同，


anyproxy指定rule规则文件启动i参数就失效

启动语句比平时多了一句，both "-i(--intercept)" and rule.beforeDealHttpsRequest are specified, the "-i" option will be ignored，这句话的意思就是如果rule规则文件中定义了beforeDealHttpsRequest函数, 那么是否代理https将完全由这个函数的返回来决定；如果没有定义这个函数，那么是否代理https就由启动anyproxy时是否传入i参数来决定；所以说这第一个anyproxy实例其实是不能代理https的。那么这里要开的第二个anyproxy实例的rule规则文件可以修改为注释掉beforeDealHttpsRequest函数，


注释掉beforeDealHttpsRequest函数

文件也放在/usr/local/lib/node_modules/anyproxy/lib/下，命名为rule_default2.js，执行命令，
anyproxy -i -p 8003 -w 8004 -r /usr/local/lib/node_modules/anyproxy/lib/rule_default2.js
访问服务器ip:8004检查是否成功，这里的启动就没有both "-i(--intercept)" and rule.beforeDealHttpsRequest are specified, the "-i" option will be ignored这句提示了，


anyproxy指定注释掉beforeDealHttpsRequest函数的rule规则文件的启动

证明第二个anyproxy实例是可以代理https的。那么用回pm2来启动多个anyproxy实例，就是执行两条命令，

pm2 start anyproxy --name anyproxy1 -- -i -p 8001 -w 8002 -r /usr/local/lib/node_modules/anyproxy/lib/rule_default.js
pm2 start anyproxy --name anyproxy2 -- -i -p 8003 -w 8004 -r /usr/local/lib/node_modules/anyproxy/lib/rule_default2.js
pm2多开anyproxy

--name参数后面跟的是pm2的服务名，在--参数后面添加anyproxy启动的各种参数，访问服务器ip:8002和服务器ip:8004检查是否成功。

3、第三个问题，anyproxy怎么做到开机自启动，只需执行命令，

pm2 save
pm2保存当前运行的应用

保存当前pm2运行的各个应用，重启时就会启动保存的各个应用。再执行命令，

pm2 startup
pm2生成开机服务

生成开机服务，重启云服务器检查是否成功。

4、第四个问题，怎么防止别人盗用自己搭建的anyproxy服务器，其实很简单，只要设置为只允许公司内网访问就可以了，回家想访问通过公司的vpn访问。
