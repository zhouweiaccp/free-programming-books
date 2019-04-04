windows下的安装：
windows下的离线安装：

nvm 的windows下载地址：https://github.com/coreybutler/nvm-windows/releases , 选择第二个nvm-setup.zip，这样安装方便些。

将下载的文件进行解压：nvm-setup.exe，单击开始安装，直接点击下一步解可以，当然我们需要注意一下两个界面：
设置nvm路径(相当于setting.txt中的root:)：
设置nvm路径
设置nvm路径(相当于setting.txt中的path:)：
设置nodejs路径
这样我们就在windows下面的nvm安装完成了！

安装完成以后需要进行配置
/**
*node下载源
*/
nvm node_mirror https://npm.taobao.org/mirrors/node/
/**
*npm下载源
*/
nvm npm_mirror  https://npm.taobao.org/mirrors/npm/
windows下nvm的命令([]中的参数可有可无)：
nvm arch                         查看当前系统的位数和当前nodejs的位数
nvm install <version> [arch]     安装制定版本的node 并且可以指定平台 version 版本号  arch 平台
nvm list [available]         
  - nvm list   查看已经安装的版本
  - nvm list installed 查看已经安装的版本
  - nvm list available 查看网络可以安装的版本
nvm on                           打开nodejs版本控制
nvm off                          关闭nodejs版本控制
nvm proxy [url]                  查看和设置代理
nvm node_mirror [url]            设置或者查看setting.txt中的node_mirror，如果不设置的默认是 https://nodejs.org/dist/
nvm npm_mirror [url]             设置或者查看setting.txt中的npm_mirror,如果不设置的话默认的是：https://github.com/npm/npm/archive/.
nvm uninstall <version>          卸载制定的版本
nvm use [version] [arch]         切换制定的node版本和位数
nvm root [path]                  设置和查看root路径
nvm version                      查看当前的版本
下面是安装和使切换nodejs的几个简单的命令使用：

nvm install 8.0.0 64-bit
nvm use 8.0.0
nvm list //查看以己经安装的
mac下的安装
mac下面的安装，其实就可以按照linux的安装就可以了！安装的命令我们可以在nvm的github的资源上面得到安装方法：
github给出的方法
mac使用的命令是：

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
在终端中执行上面的命令，安装完成以后，提示：

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
切换到$HOME下面(快速的切换：直接输入cd 回车)，查看是否有.bash_profile,如果没有的话就创建！
创建.bash_profile命令，

touch   .bash_profile
打开：

open   .bash_profile
如果在linux中最好用vi打开你需要的文件，这时候把提示的内容copy进去就可以了！
使用命令查看安装的版本：

nvm -version
这样我们就把windows端和mac端的nvm安装完成了！
mac下的nvm经常使用命令的总结：

nvm --help                          显示所有信息
nvm --version                       显示当前安装的nvm版本
nvm install [-s] <version>          安装指定的版本，如果不存在.nvmrc,就从指定的资源下载安装
nvm install [-s] <version>  -latest-npm 安装指定的版本，平且下载最新的npm
nvm uninstall <version>             卸载指定的版本
nvm use [--silent] <version>        使用已经安装的版本  切换版本
nvm current                         查看当前使用的node版本
nvm ls                              查看已经安装的版本
nvm ls  <version>                   查看指定版本
nvm ls-remote                       显示远程所有可以安装的nodejs版本
nvm ls-remote --lts                 查看长期支持的版本
nvm install-latest-npm              安装罪行的npm
nvm reinstall-packages <version>    重新安装指定的版本
nvm cache dir                       显示nvm的cache
nvm cache clear                     清空nvm的cache
nodejs具体安装过程
应为需要我们这里安装的是nodejs5.3.0版本，
windows（安装windows 32位 nodejs5.3.0）:

nvm install 5.3.0 32
mac端：

nvm install 5.3.0

npm config set registry https://registry.npm.taobao.org