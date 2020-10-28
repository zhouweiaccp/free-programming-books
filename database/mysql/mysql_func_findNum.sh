#!/bin/bash
pwd="1qaz2WSX1111"
tables=`mysql -h localhost -ueform -p$pwd edoc2v5 -e "select table_name from information_schema.tables where table_schema='edoc2v5'" 2>>/dev/null`
if [ !$tables 2>> /dev/null ];then
        echo '数据库未找到表，请联系研发同事！'
        return;
else
#       for i in $tables
#       do
#               echo "update table $i ROW_FORMAT......"
#               updateRowFormat=`mysql -h localhost -ueform -p$pwd edoc2v5 -e "ALTER TABLE $i ROW_FORMAT = DYNAMIC" 2>>/dev/null`
#       done
mysql -h localhost -ueform -p$pwd -Dedoc2v5<~/mysql_func_findNum.sql
       echo "升级完成！"
fi