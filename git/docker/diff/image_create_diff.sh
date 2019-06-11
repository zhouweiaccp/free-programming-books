#!/bin/bash

IMAGE1=${1}
IMAGE2=${2}
DIR_NAME=${IMAGE1##*:}-to-${IMAGE2##*:}

install_dependency(){
    grep Ubuntu /etc/issue &> /dev/null 
    if [ $? = 0 ];then
        dpkg -i Packages/*.deb
    else 
        yum localinstall Packages/*.rpm
    fi

}

get_images(){
    docker pull ${1}
    docker save ${1} -o ${1##*:}.tar
    if [ $? -ne 0 ];then
         echo "${1} images download failed"
         exit 1
    fi
}


create_dir(){
    rm -rf ${DIR_NAME}
    mkdir ${DIR_NAME}/${IMAGE1##*:} -p
    mkdir ${DIR_NAME}/${IMAGE2##*:} -p
    echo "image1 ${IMAGE1}" >> ${DIR_NAME}/image.txt
    echo "image2 ${IMAGE2}" >> ${DIR_NAME}/image.txt
}

image_layer_save(){
    tar -xvf ${1}.tar manifest.json
    cat manifest.json |jq  .[].Layers|jq -r .[] | sed  's#/layer.tar##g' > ${DIR_NAME}/${1}.layer
}

layer_comparison(){
    for LAYER in $(cat ${DIR_NAME}/${IMAGE2##*:}.layer)
    do
        grep "${LAYER}" ${DIR_NAME}/${IMAGE1##*:}.layer
        if  [ $? -ne 0 ];then
           LAYER_NUM=$(sed -n -e "/${LAYER}/=" ${DIR_NAME}/${IMAGE2##*:}.layer)
           layer_diff ${LAYER_NUM}
        fi 
    done
}

layer_diff(){
    local IMAGE1_LAYER
    local IMAGE2_LAYER
    IMAGE1_LAYER=$(sed -n "${1}p" ${DIR_NAME}/${IMAGE1##*:}.layer)
    IMAGE2_LAYER=$(sed -n "${1}p" ${DIR_NAME}/${IMAGE2##*:}.layer)
    tar -xvf ${IMAGE2##*:}.tar ${IMAGE2_LAYER}
    mv ${IMAGE2_LAYER} ${DIR_NAME}/${IMAGE2##*:}/
    tar -xvf ${IMAGE1##*:}.tar ${IMAGE1_LAYER}/layer.tar
    xdelta3 -v -e -s ${IMAGE1_LAYER}/layer.tar ${DIR_NAME}/${IMAGE2##*:}/${IMAGE2_LAYER}/layer.tar ${DIR_NAME}/${IMAGE2_LAYER}.tar
    rm -rf ${DIR_NAME}/${IMAGE2##*:}/${IMAGE2_LAYER}/layer.tar
    rm -rf ${IMAGE1_LAYER}
    echo "${IMAGE1_LAYER} ${IMAGE2_LAYER}" >> ${DIR_NAME}/layer_list.txt
}

image1_dec(){
    local LAST_LAYER_SOURCE
    LAST_LAYER_SOURCE=$(grep --binary-files=text ${IMAGE1##*:} ${IMAGE1##*:}.tar | grep --binary-files=text repositorie) 
    IMAGE1_LAST_LAYER=${LAST_LAYER_SOURCE:0-67:64}
    tar xf ${IMAGE1##*:}.tar "${IMAGE1_LAST_LAYER}/layer.tar"
}

image2_dec(){
    tar -xf ${IMAGE2##*:}.tar repositories && mv repositories ${DIR_NAME}/${IMAGE2##*:}/
    tar --wildcards -xf ${IMAGE2##*:}.tar *.json && mv *.json ${DIR_NAME}/${IMAGE2##*:}/
}

copy_dependency(){
    cp -rf Packages ${DIR_NAME}/
    cp image_recover.sh ${DIR_NAME} && chmod +x ${DIR_NAME}/image_recover.sh
}


clean_data(){
    rm -rf ${IMAGE1##*:}.tar
    rm -rf ${IMAGE2##*:}.tar
    rm -rf manifest.json
}

compression(){
   tar -zcvf ${IMAGE1##*:}-to-${IMAGE2##*:}.tar.gz ${IMAGE1##*:}-to-${IMAGE2##*:}
}

main(){
    install_dependency
    get_images ${IMAGE1}
    get_images ${IMAGE2}
    create_dir
    image2_dec
    image_layer_save ${IMAGE1##*:}
    image_layer_save ${IMAGE2##*:}
    layer_comparison
    copy_dependency
    clean_data
    compression
    
}

main
