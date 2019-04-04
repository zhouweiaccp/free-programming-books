https://github.com/dbcli/mssql-cli/blob/master/doc/installation/windows.md#windows-installation
https://docs.microsoft.com/zh-cn/sql/linux/sql-server-linux-setup?view=sql-server-2017#system
https://docs.microsoft.com/zh-cn/sql/linux/quickstart-install-connect-ubuntu?view=sql-server-2017

安装 SQL Server
若要在 Ubuntu 上配置 SQL Server ，在终端中运行以下命令安装mssql server包。
导入公共存储库 GPG 密钥：
bash

复制
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
注册 Microsoft SQL Server Ubuntu 存储库：
bash

复制
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
 提示

如果你想要试用 SQL Server 2019，则必须改为注册预览版 (2019) 存储库。 对于 SQL Server 2019 安装中使用以下命令：
bash

复制
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-preview.list)"
运行以下命令，安装 SQL Server：
bash

复制
sudo apt-get update
sudo apt-get install -y mssql-server
程序包安装完成后，请运行 mssql-conf setup 命令并按提示设置 SA 密码，然后选择版本。
bash

复制
sudo /opt/mssql/bin/mssql-conf setup
 提示

以下 SQL Server 2017 版本自由地授予使用许可：评估、 开发人员版和 Express。
 备注

请确保为 SA 帐户指定强密码（最少 8 个字符，包括大写和小写字母、十进制数字和/或非字母数字符号）。
配置完成后，请验证服务是否正在运行：
bash

复制
systemctl status mssql-server
如果你打算远程连接，你可能还需要打开防火墙上的 SQL Server TCP 端口 （默认值为 1433）。
在此情况下，SQL Server 在 Ubuntu 计算机上运行并已准备好使用 ！
安装 SQL Server 命令行工具
若要创建数据库，需要使用一个能够在 SQL Server 上运行 Transact-SQL 语句的工具进行连接。 以下步骤安装 SQL Server 命令行工具： sqlcmd和bcp。
使用以下步骤来安装mssql 工具Ubuntu 上。
导入公共存储库 GPG 密钥。
bash

复制
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
注册 Microsoft Ubuntu 存储库。
bash

复制
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
更新源列表，并使用 unixODBC 开发人员包运行安装命令。
bash

复制
sudo apt-get update 
sudo apt-get install mssql-tools unixodbc-dev
 备注

若要更新到最新版mssql 工具运行以下命令：
bash

复制
sudo apt-get update 
sudo apt-get install mssql-tools 
可选:添加/opt/mssql-tools/bin/为你路径bash shell 中的环境变量。
若要使sqlcmd/bcp可从登录会话的 bash shell 访问修改你路径中 ~/.bash_profile文件使用以下命令：
bash

复制
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
若要使sqlcmd/bcp能从交互式/非登录会话，bash shell 访问修改路径中 ~/.bashrc文件使用以下命令：
bash

复制
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
本地连接
以下步骤使用 sqlcmd 本地连接到新的 SQL Server 实例。
使用 SQL Server 名称 (-S)，用户名 (-U) 和密码 (-P) 的参数运行 sqlcmd。 在本教程中，用户进行本地连接，因此服务器名称为 localhost。 用户名为 SA，密码是在安装过程中为 SA 帐户提供的密码。
bash

复制
sqlcmd -S localhost -U SA -P '<YourPassword>'
 提示

可以在命令行上省略密码，以收到密码输入提示。
 提示

如果以后决定进行远程连接，请指定 -S 参数的计算机名称或 IP 地址，并确保防火墙上的端口 1433 已打开。
如果成功，应会显示 sqlcmd 命令提示符：1>。
如果连接失败，请首先尝试根据错误消息诊断问题。 然后查看连接故障排除建议。
创建和查询数据
下面各部分将逐步介绍如何使用 sqlcmd 新建数据库、添加数据并运行简单查询。
新建数据库
以下步骤创建一个名为 TestDB 的新数据库。
在 sqlcmd 命令提示符中，粘贴以下 Transact-SQL 命令以创建测试数据库：
SQL

复制
CREATE DATABASE TestDB
在下一行中，编写一个查询以返回服务器上所有数据库的名称：
SQL

复制
SELECT Name from sys.Databases
前两个命令没有立即执行。 必须在新行中键入 GO 才能执行以前的命令：
SQL

复制
GO
 提示

若要详细了解如何编写 Transact-SQL 语句和查询，请参阅教程：编写 Transact-SQL 语句。
插入数据
接下来创建一个新表 Inventory，然后插入两个新行。
在 sqlcmd 命令提示符中，将上下文切换到新的 TestDB 数据库：
SQL

复制
USE TestDB
创建名为 Inventory 的新表：
SQL

复制
CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
将数据插入新表：
SQL

复制
INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
要执行上述命令的类型 GO：
SQL

复制
GO
选择数据
现在，运行查询以从 Inventory 表返回数据。
通过 sqlcmd 命令提示符输入查询，以返回 Inventory 表中数量大于 152 的行：
SQL

复制
SELECT * FROM Inventory WHERE quantity > 152;
执行命令：
SQL

复制
GO
退出 sqlcmd 命令提示符
要结束 sqlcmd 会话，请键入 QUIT：
SQL
