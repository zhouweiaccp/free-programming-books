http://www.cnblogs.com/a2211009/p/4265225.html

apt-get install software-properties-common
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
apt-get install oracle-java8-installer


3.设置系统默认jdk
JDk7
sudo update-java-alternatives -s java-7-oracle
JDK8
sudo update-java-alternatives -s java-8-oracle
如果即安装了jdk7,又安装了jdk8,要实现两者的切换,可以:
　　jdk8 切换到jdk7
sudo update-java-alternatives -s java-7-oracle
　　jdk7 切换到jdk8
sudo update-java-alternatives -s java-8-oracle
4.测试jdk 是是否安装成功:
java -version
javac -version