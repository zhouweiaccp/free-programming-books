排查过程:
1.数据库没有任何备份，查看binlog日志的数量发现binlog数量并不完整,无法从binlog恢复数据,单机环境，binlog类型为row格式，可以使用binlog2sql回滚update操作
show binary logs;

2.备份现在的数据库
容器里执行:
mysqldump --master-data=2 --single-transaction --flush-logs --user=repl --password=1qaz2WSX -A > /var/lib/mysql/dbbackup.sql
3.单独run一个新的数据库，把备份的数据导入进新启动的数据库
mkdir  /data/mysql   // 新数据库的持久化数据目录
docker run -it -d --name mysql --net host -p 3306:3306 -v /data/mysql:/var/lib/mysql -e MODE=standalone registry.edoc2.com:5000/edoc2v5/mysql:v8.0.17.9
进入到容器里恢复备份的数据
docker exec -it $(docker ps | grep mysql | awk ‘{print $1}’) bash
mysql -urepl -p1qaz2WSX -e “source /var/lib/mysql/dbbackup.sql”
4.使用binlog2sql恢复数据库
## 安装python2-pip
wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg  --no-check-certificate
chmod +x setuptools-0.6c11-py2.7.egg
sh setuptools-0.6c11-py2.7.egg
wget https://pypi.python.org/packages/source/p/pip/pip-1.3.1.tar.gz --no-check-certificate
tar zxvf pip-1.3.1.tar.gz
cd pip-1.3.1
python setup.py install
## 下载binlog2sql
git clone https://github.com/danfengcao/binlog2sql.git && cd binlog2sql
pip install -r requirements.txt

通过binlog文件并指定开始时间解析出回滚SQL:
python binlog2sql --flushback \
-h “192.168.x.x” \
-urepl -p1qaz2WSX \
-P 30001 \
--start-datetime=”2021-01-18 17:30:00” \
--start-file=’/home/edoc/macrowing/edoc2v5/data/mysql/binlog.000011’
-d edoc2v5 >> rollback.sql 