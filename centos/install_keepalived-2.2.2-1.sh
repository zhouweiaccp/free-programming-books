#!/bin/bash
#
# -a 必须选项，一定要指定一个参数值。需要指定一个脚本动作.
# 	'install': 		安装keepalived
# 	'update':  		升级docker
# 	'uninstall': 	卸载docker
# 	'bond':			网卡绑定
# KEEPALIVED_CONFIG_FILE="/tmp/keepalived.conf"
# CHECK_STATUS_SCRIPT_FILE="/tmp/chk_status.sh"


function show_help()
{
cat<<EOF
This script can help you 
    Uninstall or upgrade your docker.
    Network interface bonded.
    Install keepalived on localhost. 
You can use -a to assign which action you want to do.

    -a                      Assign an action. Availiable value 'install','update','uninstall','bond'.
    -p                      Parse path of docker rpm package
    -k                      Parse path of keepalived rpm package
    -h                      Show help

EOF
}

function gen_conf() {
cat >${KEEPALIVED_CONFIG_FILE}<<EOF
! Configuration File for keepalived
global_defs {
    router_id EDOC_HA
}
vrrp_script chk_80 {
    script "/etc/keepalived/chk_status.sh"
    interval 1
    weight -3
}

vrrp_instance VI_1 {
    interface _INTFS
    state _ROLE
    priority _PRIORITY
    virtual_router_id 71
    garp_master_delay 1
    authentication {
        auth_type PASS
        auth_pass password
    }
    track_interface {
        _INTFS
    }
    virtual_ipaddress {
        _VIP/32
    }

    track_script {
        chk_80
    }
}
EOF

cat >${CHECK_STATUS_SCRIPT_FILE}<<'EOF'
#!/bin/bash

SCHEME=http
PORT=80

curl -s -L -k -i ${SCHEME}://localhost:${PORT}/api/values|grep "200 OK" > /dev/null
if [ $? -eq 0 ]; then
    exit 0
else
    exit 1
fi
EOF
}

function install() {
    [ -f ${KEEPALIVED_CONFIG_FILE} ] && >${KEEPALIVED_CONFIG_FILE}
    [ -f ${CHECK_STATUS_SCRIPT_FILE} ] && >${CHECK_STATUS_SCRIPT_FILE}
    gen_conf

    _intfs=($(ip -4 a | awk -F: '$2 !~ /lo|docker/{print $2}' | xargs))
    if [ ${#_intfs[@]} -gt 1 ];then 
        echo "Your localhost got many network inteface, please select one of them used for listen VRRP."
        for ((i=0; i<${#_intfs[@]}; i++));  do
            echo -e "[$(($i+1))]: ${_intfs[$i]}"
        done
        read _NUM
        _IDX=_NUM-1
        _INTFS=${_intfs[$_IDX]}
    elif [ ${#_intfs[@]} -eq 0 ]; then
        echo "Could not get any interface in you host."
        exit 104 
    else
        echo -e "You got one network interface: ${_intfs[@]}. This interface will be used for listen VRRP"
        _INTFS=${_intfs[@]}
    fi
    echo "Plase input your virtual ip address without netmask."
    read _VIP
    echo $_VIP | awk -F. '{if(NF==4 && $1>0 && $1<=255 && $2>=0 && $2<=255 && $3>=0 && $3<=255 && $4>0 && $4<255) exit 0;else exit 1}'
    if [ $? -ne 0 ]; then
        echo "Invalid IP address founded. Please check your input."
        exit 102
    fi
    echo -e "Please input role of this node.\n[1] master \n[2] backup"
    read _CHOSE
    if [ ${_CHOSE} -eq 1 ]; then 
        _ROLE=MASTER
    else 
        _ROLE=BACKUP
    fi
    echo "Please input priority of this node, 0 ~ 100"
    read _PRIORITY

    eval sed -i 's/_INTFS/${_INTFS}/g' ${KEEPALIVED_CONFIG_FILE}
    eval sed -i 's/_VIP/${_VIP}/g' ${KEEPALIVED_CONFIG_FILE}
    eval sed -i 's/_PRIORITY/${_PRIORITY}/g' ${KEEPALIVED_CONFIG_FILE}
    eval sed -i 's/_ROLE/${_ROLE}/g' ${KEEPALIVED_CONFIG_FILE}

    echo "Got ya. Now process keepalived install."
    [ ! -f ${keepalived_pkg} ] && echo "Keepalived package not found."
    rpm -ivh ${keepalived_pkg}
    if [ $? -eq 0 ]; then
        /usr/bin/cp -f ${KEEPALIVED_CONFIG_FILE} /etc/keepalived/keepalived.conf
        /usr/bin/cp -f ${CHECK_STATUS_SCRIPT_FILE} /etc/keepalived/chk_status.sh && chmod +x /etc/keepalived/chk_status.sh
        echo "Keepalived install successed. Now start keepalived."
    else 
        echo "Keepalived install failed."
        exit 103
    fi

    systemctl enable --now keepalived
    if [ $? -eq 0 ]; then 
        rm -fr ${KEEPALIVED_CONFIG_FILE}
        rm -fr ${CHECK_STATUS_SCRIPT_FILE}
    fi
}

check_valid(){
case $1 in
    card)
        if [ -z "$2" ]; then
            echo -e "The network card can not be null.\n"
            continue
        else
            echo "$3" | grep -q "\b$2\b" 
            if [ $? -ne 0 ]; then
                echo -e "Please enter the valid network card.\n"
                continue
            fi
        fi
        ;;
    net)
        if [ -z "$2" ]; then
            echo -e "The IP option can not be null.\n"
            continue
        else
            echo "$2" | grep -Po '((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}' > /dev/null
            if [ $? -ne 0 ]; then
                echo "Please enter valid IP."
                continue
            fi
        fi
        ;;
    mask)
        if [ -z "$2" ]; then
            echo -e "The netmask option can not be null.\n"
            continue
        else
            echo "$2" | grep -Po '^((128|192)|2(24|4[08]|5[245]))(\.(0|(128|192)|2((24)|(4[08])|(5[245])))){3}$' > /dev/null
            if [ $? -ne 0 ]; then
                echo "Please enter valid mask."
                continue
            fi
        fi
        ;;
    gateway|dns)
        if [ "$2" != "null" ]; then
            echo "$2" | grep -Po '((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}' > /dev/null
            if [ $? -ne 0 ]; then
                echo "Please enter valid dns/gateway.\n"
                continue
            fi
        fi
        ;;
esac
}

function bond() {
while true; do 
    echo -e "The system has multiple network cards, and you need to choose two to bind:\n"
    cards=$(ip add | awk -F'[ :]+' 'BEGIN{print "("} $2!~/lo|docker/{if ($0 ~ /[0-9]: /){a[$2]=$2}}END{for(i in a){print "\t"a[i]}print ")"}')
    echo -e "$cards\n"
    echo -n "please choose the first card: "
    read card1
    check_valid card "$card1" "$cards"
    echo -n "please choose the second card: "
    read card2
    check_valid card "$card2" "$cards"

    echo -n "Please enter the IP to bond: "
    read IP
    check_valid net $IP
    echo -n "Please enter the netmask: "
    read mask
    check_valid mask $mask
    echo -n "Please enter the gateway, default is null: "
    read gateway
    check_valid gateway ${gateway:-null}
    echo -n "Please enter the dns, default is null: "
    read dns
    check_valid dns ${dns:-null}

    echo -n "please enter the bond name, default bond0: "
    read bond

    echo -n "The network card $card1 and $card2 will be bond to ${bond:-bond0}, ipaddr: $IP [y/N]." 
    read choose
    case $choose in 
        y|Y)
            do_bonding "$IP" "$mask" "$card1" "$card2" "${gateway:-null}" "${dns:-null}" "${bond:-bond0}"
            if [ $? -eq 0 ]; then
                echo "bond network $card1 $card2 success."
                break
            else
                echo "bond network $card1 $card2 faild."
                break
            fi
            ;;
        n|N)
            break
            ;;
    esac
done
}

do_bonding(){

IPADDR="$1"
NETMASK="$2"
GATEWAY="$5"
DEVNAME1="$3"
DEVNAME2="$4"
DNS1="$6"
BOND=$7

NETDIR="/etc/sysconfig/network-scripts"


if [ ! -f "$NETDIR/ifcfg-$DEVNAME1.bak" ]; then
    cp $NETDIR/ifcfg-$DEVNAME1{,.bak}
fi

if [ ! -f "$NETDIR/ifcfg-$DEVNAME2.bak" ]; then
    cp $NETDIR/ifcfg-$DEVNAME2{,.bak}
fi

cat > $NETDIR/ifcfg-$BOND <<EOF
DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
BONDING_OPTS="mode=1 miimon=100"
NM_CONTROLLED=no
IPADDR=$IPADDR
NETMASK=$NETMASK
#GATEWAY=$GATEWAY
#DNS1=$DNS1
EOF

if [ $DNS1 != "null" ]; then 
    sed -i 's/#DNS1/DNS1/' $NETDIR/ifcfg-$BOND
fi

if [ $GATEWAY != "null" ]; then
    sed -i 's/#GATEWAY/GATEWAY/' $NETDIR/ifcfg-$BOND
fi

cat > $NETDIR/ifcfg-$DEVNAME1 <<EOF
DEVICE=$DEVNAME1
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
EOF

cat > $NETDIR/ifcfg-$DEVNAME2 <<EOF
DEVICE=$DEVNAME2
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
EOF

#echo "ifenslave bond0 $DEVNAME1 $DEVNAME2" >> /etc/rc.d/rc.local

systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl restart network.service

return $?

}

function remove(){
arry=(containerd containerd-shim ctr docker docker-compose dockerd docker-init docker-proxy runc)

command docker 2> /dev/null

if [ $? -ne 0 ]; then
    echo "docker not install"
    exit 101
fi

if [ $action == "update" ]; then
    if [ x$docker_pkg == "x" ]; then
        echo "please enter docker path."
        exit 101
    else
        if [[ $docker_pkg =~ "docker" ]] && [[ $docker_pkg =~ "rpm" ]]; then
            if [ ! -f $docker_pkg ]; then
                echo "docker path not exist."
                exit 101
            fi
        else
            echo "please enter docker rpm path"
            exit 101
        fi
    fi
fi

vers=$(dockerd  --version | awk '{print $3}')
ver=$(echo ${vers%%.*})


if [ $ver -gt 18 ]; then
    systemctl stop containerd docker 2>/dev/null
    rpm -qa | grep -q docker

    if [ $? -eq 0 ]; then
        rpm -e docker 2>/dev/null
    else
        for i in ${arry[@]}; do
            rm -f /usr/bin/$i
        done
        grep -q 'docker' /etc/group && groupdel docker
        rm -f /usr/lib/systemd/system/{containerd.service,docker.service,docker.socket}
    fi
else
    systemctl stop docker 2> /dev/null
    rpm -qa | grep -q docker

    if [ $? -eq 0 ]; then
        rpm -e docker 2>/dev/null
    else
        rm -f /usr/bin/docker*
        rm -f /usr/lib/systemd/system/docker.service
    fi
fi

systemctl daemon-reload

}


function upgrade(){
    rpm --install $docker_pkg  2> /dev/null && { echo "upgrade docker success.";systemctl restart containerd docker; } || echo 'upgrade docker failed.'
}

function main(){
while getopts "ha:p:k:" arg; do
    case $arg in
    h)
        ;;
    a)
        action=$OPTARG;;
    p)
        docker_pkg=$OPTARG;;
    k)
        keepalived_pkg=$OPTARG;;
    ?)
        echo "Invalid option!"
        exit 101;;
    esac
done

case $action in 
    update)
        remove
        upgrade
        ;;
    uninstall)
        remove
        ;;
    install)
        install
        ;;
    bond)
        bond
        ;;
    *)
        show_help
        ;;
esac
}

main $@
