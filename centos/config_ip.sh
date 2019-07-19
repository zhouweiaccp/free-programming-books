#!/bin/bash
cp /etc/sysconfig/network-scripts/ifcfg-eth0{,_bak}
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="yes"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth0"
UUID="5733d241-f0ea-4b7e-88d8-abdc79d9ecb8"
DEVICE="eth0"
ONBOOT="yes"
IPADDR="192.168.252.108"
PREFIX="24"
GATEWAY="192.168.252.1"
DNS1="202.96.209.133"
IPV6_PRIVACY="no"
EOF

systemctl restart network