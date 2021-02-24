



Elasticsearch基础数据架构的主要概念

index：索引,相当于关系型数据库中的database。
type：类型,相当于关系型数据库中的table。
document：文档,相当于关系型数据库中的一行数据。
mapping：映射,相当于关系型数据库中的schema。
id：主键,相当于关系型数据库的id。
Elasticsearch与Mysql对比


1.创建一个索引
curl -XPUT "http://localhost:9200/blog01/"

2.插入一个文档 -XPUT
要在 /blog01 索引下创建一个类型，可插入一个文档。
curl -XPUT "http://localhost:9200/blog01/article/1" -d "{"""id""": """1""", """title""": """Whatiselasticsearch"""}"

3.查看文档 -XGET
curl -XGET "http://localhost:9200/blog01/article/1"

4.更新文档
curl -XPUT "http://localhost:9200/blog01/article/1" -d "{"""id""": """1""", """title""": """Whatislucene"""}"

7.删除文档 -XDELETE
curl -XDELETE "http://localhost:9200/blog01/article/1"

8.删除索引
curl -XDELETE "http://localhost:9200/blog01"

### demo1

C:\Users\Administrator>curl localhost:9200/_cat/indices?pretty=true
yellow open signlog_1      zddV5sqsRjSyZ1oLKzAgFg 5 1 1 0  8.8kb  8.8kb
yellow open folder_1       eOIBOorrQs-yf9xLD7X6bg 5 1 1 0  8.4kb  8.4kb
yellow open filepublish    lpziHz8PQSyZERJDNPA_UQ 5 1 0 0  1.2kb  1.2kb
yellow open eformoptlog_1  PbYrCwv6TIKWKlsW49FWZw 5 1 2 0 19.4kb 19.4kb
yellow open authlog        5hv2DhbtRiyDHSNcEfT9Mg 5 1 0 0  1.2kb  1.2kb
yellow open hotword_1      MW8lpY9cTyCWMbaUbT7f8Q 5 1 0 0  1.2kb  1.2kb
yellow open file_1         lem4SNkNT_23rMu8O3jZPw 5 1 1 0 13.1kb 13.1kb
yellow open synwatchfile_1 L-kCuBEgSRK4Td-_BN--lA 5 1 2 0 16.9kb 16.9kb
yellow open folderpublish  ntWykSWuS1ymrCtcLfqMAw 5 1 0 0  1.2kb  1.2kb
yellow open dmssharelog    iWzjQveWRuSBem_mnhZAAw 5 1 0 0  1.2kb  1.2kb
yellow open orglog_1       L_mnbtwQTXqX7y1m1NusLw 5 1 2 0 15.4kb 15.4kb
yellow open operation_log  VALJAW6JQgqPIEBgOiq6bg 5 1 2 0 21.9kb 21.9kb
yellow open filelog_1      Hcxop9K4Qm2fU3aqPT8dUg 5 1 2 0 22.7kb 22.7kb

C:\Users\Administrator>curl localhost:9200/orglog_1
{"orglog_1":{"aliases":{"orglog":{}},"mappings":{"_doc":{"properties":{"account":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"iP":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"id":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"operationContent":{"type":"keyword"},"operationTime":{"type":"date","format":"yyyy-MM-dd HH:mm:ss"},"operationType":{"type":"long"},"operatorId":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"operatorName":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}}}}},"settings":{"index":{"refresh_interval":"1s","number_of_shards":"5","provided_name":"orglog_1","max_result_window":"2000000000","creation_date":"1614148279810","analysis":{"filter":{"pinyin_filter":{"keep_joined_full_pinyin":"true","none_chinese_pinyin_tokenize":"false","keep_none_chinese_in_joined_full_pinyin":"true","keep_original":"true","remove_duplicated_term":"true","keep_first_letter":"false","type":"pinyin","keep_full_pinyin":"false"},"stop_filter":{"type":"stop","stopwords_path":"dic/stopword.dic"},"synonym_filter":{"type":"synonym","synonyms_path":"dic/synonym.dic"}},"char_filter":{"backslash_char_filter":{"pattern":"\\\\","type":"pattern_replace","replacement":" "},"comma_char_filter":{"pattern":",","type":"pattern_replace","replacement":" "}},"analyzer":{"text_path":{"filter":["lowercase"],"char_filter":["backslash_char_filter"],"type":"custom","tokenizer":"whitespace"},"text_facetpath":{"filter":["lowercase"],"char_filter":["comma_char_filter"],"type":"custom","tokenizer":"whitespace"},"text_suggest_ngram":{"filter":["stop_filter","lowercase","asciifolding","classic","edge_ngram"],"type":"custom","tokenizer":"uax_url_email"},"text_suggest":{"filter":["stop_filter","lowercase","asciifolding","classic"],"type":"custom","tokenizer":"uax_url_email"},"text_code_synonym":{"filter":["stop_filter","synonym_filter","lowercase"],"type":"custom","tokenizer":"standard"},"text_ik":{"filter":["synonym_filter"],"type":"custom","tokenizer":"ik_max_word"},"text_pinyin":{"filter":["synonym_filter","pinyin_filter"],"type":"custom","tokenizer":"ik_max_word"},"text_tag":{"filter":["lowercase"],"type":"custom","tokenizer":"whitespace"},"text_str":{"filter":["lowercase"],"type":"custom","tokenizer":"ngram_tokenizer"},"text_code":{"filter":["stop_filter","lowercase"],"type":"custom","tokenizer":"standard"}},"tokenizer":{"ngram_tokenizer":{"token_chars":["letter","digit"],"min_gram":"1","type":"ngram","max_gram":"20"}}},"number_of_replicas":"1","uuid":"L_mnbtwQTXqX7y1m1NusLw","version":{"created":"6070199"}}}}}

## 索引所有数据
C:\Users\Administrator>curl localhost:9200/orglog/_search
{"took":0,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},"hits":{"total":2,"max_score":1.0,"hits":[{"_index":"orglog_1","_type":"_doc","_id":"dbab234c440547d78157baaea2a26850","_score":1.0,"_source":{"id":"dbab234c440547d78157baaea2a26850","operationType":4,"operationContent":"鍒涘缓鐢ㄦ埛:aa","operationTime":"2021-02-24 14:36:25","operatorId":"90eb0c6350ce4284828e633304decc01","operatorName":"Administrator","iP":"127.0.0.1","account":"admin"}},{"_index":"orglog_1","_type":"_doc","_id":"9091eebc7e4240619b0990184c240d06","_score":1.0,"_source":{"id":"9091eebc7e4240619b0990184c240d06","operationType":4,"operationContent":"鍒涘缓鐢ㄦ埛:ad","operationTime":"2021-02-24 14:36:36","operatorId":"90eb0c6350ce4284828e633304decc01","operatorName":"Administrator","iP":"127.0.0.1","account":"admin"}}]}}



## 索引字段
C:\Users\Administrator>curl localhost:9200/orglog/_mapping
{"orglog_1":{"mappings":{"_doc":{"properties":{"account":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"iP":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"id":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"operationContent":{"type":"keyword"},"operationTime":{"type":"date","format":"yyyy-MM-dd HH:mm:ss"},"operationType":{"type":"long"},"operatorId":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"operatorName":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}}}}}}}


## 查询id=9091eebc7e4240619b0990184c240d06
curl  -XGET "localhost:9200/orglog/_search?q=id:'9091eebc7e4240619b0990184c240d06'"
{"took":4,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},"hits":{"total":1,"max_score":0.2876821,"hits":[{"_index":"orglog_1","_type":"_doc","_id":"9091eebc7e4240619b0990184c240d06","_score":0.2876821,"_source":{"id":"9091eebc7e4240619b0990184c240d06","operationType":4,"operationContent":"鍒涘缓鐢ㄦ埛:ad","operationTime":"2021-02-24 14:36:36","operatorId":"90eb0c6350ce4284828e633304decc01","operatorName":"Administrator","iP":"127.0.0.1","account":"admin"}}]}}

## 查询id=9091eebc7e4240619b0990184c240d06   _doc 来源于 "_type":"_doc"
C:\Users\Administrator>curl  -XGET "localhost:9200/orglog/_doc/_search?q=id:'9091eebc7e4240619b0990184c240d06'"
{"took":3,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},"hits":{"total":1,"max_score":0.2876821,"hits":[{"_index":"orglog_1","_type":"_doc","_id":"9091eebc7e4240619b0990184c240d06","_score":0.2876821,"_source":{"id":"9091eebc7e4240619b0990184c240d06","operationType":4,"operationContent":"鍒涘缓鐢ㄦ埛:ad","operationTime":"2021-02-24 14:36:36","operatorId":"90eb0c6350ce4284828e633304decc01","operatorName":"Administrator","iP":"127.0.0.1","account":"admin"}}]}}

### demo2
获取所有索引信息
curl -XGET localhost:9200/_cat/indices?v


获取单个索引信息
[root@C20-23U-10 ~]# curl -XGET http://localhost:9200/fei?pretty
{
  "fei" : {
    "aliases" : { },
    "mappings" : {
      "gege" : {
        "properties" : {
          "name" : {
            "type" : "string"
          },
          "sex" : {
            "type" : "string"
          }
        }
      }
    },
    "settings" : {
      "index" : {
        "creation_date" : "1559447228188",
        "number_of_shards" : "5",
        "number_of_replicas" : "1",
        "uuid" : "ti03rgsETR6JaX-uwfiTTQ",
        "version" : {
          "created" : "2040599"
        }
      }
    },
    "warmers" : { }
  }
}

获取所有type类型信息
curl -XGET http://localhost:9200/_mapping?pretty=true



获取指定索引的type类型信息
curl -XGET http://localhost:9200/fei/_mapping?pretty=true

{
  "fei" : {
    "mappings" : {
      "gege" : {
        "properties" : {
          "age" : {
            "type" : "long"
          },
          "name" : {
            "type" : "string"
          },
          "sex" : {
            "type" : "string"
          }
        }
      }
    }
  }
}
增：添加一个文档，同时索引、类型、文档id也同时生成
如果id不指定，则ES会自动帮你生成一个id，就不再演示了。

curl -XPUT http://localhost:9200/fei/gege/1?pretty -d'{
"name":"feigege",
"sex":"man"
}'
结果：
{
  "_index" : "fei",
  "_type" : "gege",
  "_id" : "1",
  "_version" : 1,
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "created" : true
}

查：根据index，type，id查询文档信息
查询索引为fei,类型为gege, id为1的文档信息。

curl -XGET http://localhost:9200/fei/gege/1?pretty
结果：
{
  "_index" : "fei",
  "_type" : "gege",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "name" : "feigege",
    "sex" : "man"
  }
}

查：根据index，type，其他字段查询文档信息
#查询名字里有fei的人。
-XGET http://localhost:9200/fei/gege/_search?pretty=true&q=name:fei
改：修改原有的数据，注意文档的版本！
curl -XPOST http://localhost:9200/fei/gege/1?pretty -d '{
"name":"feigege",
"sex":"woman"
}'
结果(注意版本变化)：
{
  "_index" : "fei",
  "_type" : "gege",
  "_id" : "1",
  "_version" : 2,
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "created" : false
}

删：删除文档，删除类型，删除索引！
删除文档：
curl -XDELETE http://localhost:9200/fei/gege/1?pretty
结果：
{
  "found" : true,
  "_index" : "fei",
  "_type" : "gege",
  "_id" : "1",
  "_version" : 4,
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  }
}

删除类型：
现在的Elasticsearch已经不支持删除一个type了。
要么从新设置index，要么删除类型下的所有数据。

##删除索引
curl -XDELETE -u elastic:changeme http://localhost:9200/fei?pretty
{
  "acknowledged" : true
}