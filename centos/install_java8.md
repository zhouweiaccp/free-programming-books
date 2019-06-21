	
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"

mkdir -p /usr/java
tar -zxvf jdk-8u141-linux-x64.tar.gz
cp -r /home/root1/logdemo/jdk1.8.0_141 /usr/java/jdk1.8.0_141

vim /etc/profile
JAVA_HOME=/usr/java/jdk1.8.0_141
CLASSPATH=$JAVA_HOME/lib/
PATH=$PATH:$JAVA_HOME/bin
export PATH JAVA_HOME CLASSPATH

source /etc/profile