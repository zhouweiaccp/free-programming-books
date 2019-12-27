#!/bin/ksh
#
set -e
SERVER=http://192.168.251.126
TMPDIR=/tmp
LOG=/tmp
#分块大小,单位字节
BS=134217728

user_login(){

while true; do
    echo "#####开始登陆系统####"
    echo -n 请输入用户名及密码['username passwd']:
    read username passwd
    curl -s -X POST "$SERVER/api/services/Org/UserLogin" \
    -H "accept: application/json" -H "Content-Type: application/json-patch+json" -d "{ \"UserName\": \"$username\", \"Password\": \"$passwd\"}" \
    -w "\n" > $LOG/login.log
    
    token=`awk -F'[:,]+' '{print $2}' $LOG/login.log | sed s@\"@@g`
    if [ x$token != x ]; then
        echo "登陆成功！！"
        rm -f $LOG/login.log
         break
    else
        echo "登陆失败！！"
        continue
    fi
done

}


get_info(){

while true; do
   echo -n "获取文件列表,请输入文件夹ID,默认为1:"
   read id

   if [ x$id == 'x' ];then
      id=1
   fi

   curl -s -X GET "$SERVER/api/services/Doc/GetFileAndFolderList?token=$token&folderId=$id&sortDesc=false&sortField=basic%3Aname&docViewId=0" \
   -H "accept: application/json" -w "\n" > $LOG/info.log

   echo '-----------------------文件夹列表---------------------------'
   cat  $LOG/info.log | grep -Po '\"FolderId\":\d+,\S+\"FolderName\":\S+?\"' | awk -F'[":,]+' '{print $3,$(NF-1)}'
   echo '-----------------------文件列表----------------------------'
   cat $LOG/info.log | grep -Po '\"FileId\":\d+,\S+\"FileName\":\".+?\"' | awk -F'[":,]+' '{print $3,$(NF-1)}'

   echo -n "是否继续列出文件列表[y/n]:"
   read c
   case $c in
   y|Y)
      clear
      continue
    ;;
   n|N)
      break
    ;;
   esac
done




}


download(){

while true; do
    echo -n 请输入fileid:
    read fileid

    curl -s -X GET "$SERVER/api/services/File/GetFileInfoById?token=$token&fileId=$fileid" \
    -H "accept: application/json" -w "\n" > $LOG/download.log

    filename=`awk -F'[:,]' '{print $5}' $LOG/download.log | sed s@\"@@g`
    
    if [ $filename == 'result' ]; then
       echo "文件id ${fileid} 不存在！！！"
       break
    fi

    curl -s -L "$SERVER/downLoad/index?fileIds=$fileid&token=$token" -o $filename
    
    echo "文件 ${filename} 保存至$PWD"

    echo -n 是否继续下载[y/n]:
    read choose

    case $choose in
    y|Y)
        continue
        ;;
    n|N)
        break
        ;; 
    *)
        echo "不合法的输入!!!"
        break
    esac

done

}


upload(){

while true; do
echo -n -e 请输入文件路径['/opt/filename']:
read File
if [ ! -f $File ]; then
    echo "文件 $File 不存在！！"
    continue
fi
fileName=`basename $File`
filesize=`du -b $File | cut -f 1`

echo -n -e "请输入文件夹ID:"
read folderId

curl -s -X POST "$SERVER/WebCore?module=RegionDocOperationApi&fun=CheckAndCreateDocInfo" \
-d "folderId=$folderId&token=$token&fileName=$fileName&size=$filesize&attachType=0&fileModel=UPLOAD" > $LOG/upload.log

regionhash=`cat $LOG/upload.log  | grep -Po 'RegionHash\":\"\S+\",' | awk -F'[:"]' '{print $4}'`
regionId=`cat $LOG/upload.log | grep -Po 'RegionId\":\d' | awk -F':' '{print $2}'`

if [ x$regionhash == x ]; then
   echo "上传文件失败! 请检查是否有同名文件及文件夹ID是否正确！！"
   continue   
fi

uploadId=`uuidgen`

echo "开始上传文件......"

if [ $filesize -gt $BS ]; then
    chunkSize=$BS
    module=$((filesize%chunkSize))
    [ ! -d $TMPDIR ] && mkdir -p $TMPDIR

    if [ $module -eq 0 ]; then
        count=$((filesize/chunkSize))
        blockSize=$chunkSize
        for ((ct=0;ct<$count;ct++)); do
            dd if=$File of=${TMPDIR}/${fileName}_${ct} bs=$chunkSize skip=$ct  count=1 2> /dev/null
            echo "开始上传文件块 ${fileName}_${ct}"
            curl -s -X POST "$SERVER/document/upload?code=&token=$token" -F "uploadId=$uploadId" \
            -F "regionHash=$regionhash" -F "regionId=$regionId" -F "fileName=$fileName" -F "size=$filesize" \
            -F "chunks=$count" -F "chunk=$ct" \
            -F "chunkSize=$chunkSize" -F "blockSize=$blockSize" -F "file=@/tmp/${fileName}_${ct}" > $LOG/upload2.log
            rm -f ${TMPDIR}/${fileName}_${ct}
        done
    else
        end_size=$module
        size=$((filesize-end_size))
        count=$((size/chunkSize))
        counts=$((count+1))
        blockSize=$chunkSize
        for ((ct=0;ct<$counts;ct++)); do
            if [ $ct -ne $((counts-1)) ]; then
                 dd if=$File of=${TMPDIR}/${fileName}_${ct} bs=$chunkSize skip=$ct   count=1 2> /dev/null
                 echo "开始上传文件块 ${fileName}_${ct}"
                 curl -s -X POST "$SERVER/document/upload?code=&token=$token" -F "uploadId=$uploadId" \
                 -F "regionHash=$regionhash" -F "regionId=$regionId" -F "fileName=$fileName" -F "size=$filesize" \
                 -F "chunks=$counts" -F "chunk=$ct" \
                 -F "chunkSize=$chunkSize" -F "blockSize=$blockSize" -F "file=@/tmp/${fileName}_${ct}" > $LOG/upload2.log
                 rm -f ${TMPDIR}/${fileName}_${ct}
            else
                 dd if=$File of=${TMPDIR}/${fileName}_${ct} ibs=$chunkSize obs=$end_size skip=$ct  count=1 2> /dev/null
                 echo "开始上传文件块 ${fileName}_${ct}"
                 curl -s -X POST "$SERVER/document/upload?code=&token=$token" -F "uploadId=$uploadId" \
                 -F "regionHash=$regionhash" -F "regionId=$regionId" -F "fileName=$fileName" -F "size=$filesize" \
                 -F "chunks=$counts" -F "chunk=$ct" \
                 -F "chunkSize=$chunkSize" -F "blockSize=$end_size" -F "file=@/tmp/${fileName}_${ct}" > $LOG/upload2.log
                 rm -f ${TMPDIR}/${fileName}_${ct}
            fi
       done 
    fi
else
    curl -s -X POST "$SERVER/document/upload?code=&token=$token" -F "uploadId=$uploadId" \
    -F "regionHash=$regionhash" -F "regionId=$regionId" -F "fileName=$fileName" -F "size=$filesize" \
    -F "chunkSize=$filesize" -F "blockSize=$filesize" -F "file=@$File"  > $LOG/upload2.log
fi
rest=`cat $LOG/upload2.log | grep -Po 'status\":\"\S+\",' | awk -F'[":]' '{print $4}'`

if [ x$rest == 'xEnd' ]; then
   echo "文件 $fileName 上传成功！！"
else
   echo "文件 $fileName 上传失败！！"
   continue
fi

echo -n '是否继续上传文件[y/n]:'
read C

case $C in 
  y|Y)
     continue
     ;;
  n|N)
     break
     ;;
  *)
     echo '不合法的输入!!'
     break
     ;;
esac

done
}


menu(){


while true; do
echo -n -e "请选择要执行的操作
1) 下载
2) 上传
3) 退出
:"

read chooses

case $chooses in 
  1)
    get_info 
    download
  ;;
  2)
    get_info
    upload
  ;;
  3)
    break
    ;;
esac

done

}


user_login
menu
