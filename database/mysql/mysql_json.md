



## json select
SELECT dept_remark->'$.Leader' account FROM org_department

## json json_replace
 UPDATE tab_base_info 
 SET content = json_replace(content, '$.author', "tom") 
 WHERE id = 1;






























https://dev.mysql.com/doc/refman/5.7/en/json-function-reference.html