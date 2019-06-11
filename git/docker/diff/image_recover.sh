#!/bin/bash 

IMAGE1=$(grep image1 image.txt|awk '{print $2}')
IMAGE2=$(grep image2 image.txt|awk '{print $2}')


get_images(){
    docker save ${1} -o ${1##*:}.tar
    if [ $? -ne 0 ];then
         echo "${1} images download failed"
         exit 1
    fi
}

install_dependency(){
    grep Ubuntu /etc/issue &> /dev/null 
    if [ $? = 0 ];then
        dpkg -i Packages/*.deb
    else 
        yum localinstall Packages/*.rpm
    fi

}

recovery_tar_file(){
    cat layer_list.txt | while read LINE
    do
        IMAGE1_LAYER=$(echo "${LINE}"|awk '{print $1}')
        IMAGE2_LAYER=$(echo "${LINE}"|awk '{print $2}')
        tar -xvf ${IMAGE1##*:}.tar ${IMAGE1_LAYER}/layer.tar
        xdelta3 -v -d -s ${IMAGE1_LAYER}/layer.tar ${IMAGE2_LAYER}.tar ${IMAGE2##*:}/${IMAGE2_LAYER}/layer.tar
        rm -rf ${IMAGE1_LAYER}
    done 

}


delete_file(){
     mkdir ${IMAGE1##*:}
     tar -xvf ${IMAGE1##*:}.tar -C ${IMAGE1##*:}
     rm -rf ${IMAGE1##*:}/${IMAGE1_LAYER}
     rm -rf ${IMAGE1##*:}/*.json
     rm -rf ${IMAGE1##*:}/repositories
}

update_file(){
    mv ${IMAGE1##*:}/* ${IMAGE2##*:}/
    cd ${IMAGE2##*:} && tar -cvf ../${IMAGE2##*:}.tar * && cd .. 

}

clean_data(){
    rm -rf ${IMAGE1##*:}  
    rm -rf ${IMAGE2##*:}
}

load_image(){
    docker load -i ${IMAGE2##*:}.tar
}

compose_file_check(){
    if [  ! -f "../docker-compose.yml" ];then
        echo "docker-compose.yml does not exist"
        exit 1
    fi
}

config_compose_file(){
    cp ../docker-compose.yml ../docker-compose.yum-$(date +%Y%m%d%H%M%S).bak
    sed -i "s#${IMAGE1}#${IMAGE2}#g" ../docker-compose.yml
}

main(){
#   compose_file_check
   install_dependency
   get_images ${IMAGE1}
   recovery_tar_file
   delete_file
   update_file
   load_image
   clean_data
#   config_compose_file
}

main
