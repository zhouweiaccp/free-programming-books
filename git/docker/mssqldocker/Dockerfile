# php-mssql https://github.com/rastasheep/ubuntu-sshd/blob/master/16.04/Dockerfile
# PHP runtime with pdo_sqlsrv to connect to SQL Server https://github.com/Microsoft/mssql-docker/blob/master/oss-drivers/php-mssql/Dockerfile
FROM microsoft/mssql-server-linux:latest
#MAINTAINER Aleksandar Diklic "https://github.com/rastasheep"
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main" > /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/ubuntu/ xenial universe" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list \
&&  apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
         libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
		openssh-server \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
        vim \
        procps \
        net-tools \
        curl \
        gnupg \
        wget \
        unzip \
        libgdiplus \
		tzdata \ 
		cron \ 
        apt-transport-https \
        gcc \
        build-essential \
        g++-5 \
    && rm -rf /var/lib/apt/lists/*
	
RUN mkdir /var/run/sshd


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
dpkg-reconfigure -f noninteractive tzdata
#RUN chkconfig cron on
RUN echo 'root:root' |chpasswd

RUN sed -ir 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD [ "/opt/mssql/bin/sqlservr" ]

