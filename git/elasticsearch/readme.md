
## link
-[查询语句](https://blog.csdn.net/u014646662/article/details/89010759)
-[查询语句](https://www.cnblogs.com/UUUz/p/11170833.html)


## Elasticsearch 常用查询命令汇总
一、_cat操作

_cat系列提供了一系列查询elasticsearch集群状态的接口。你可以通过执行

curl -XGET localhost:9200/_cat
获取所有_cat系列的操作
/_cat/allocation
/_cat/shards
/_cat/shards/{index}
/_cat/master
/_cat/nodes
/_cat/indices
/_cat/indices/{index}
/_cat/segments
/_cat/segments/{index}
/_cat/count
/_cat/count/{index}
/_cat/recovery
/_cat/recovery/{index}
/_cat/health
/_cat/pending_tasks
/_cat/aliases
/_cat/aliases/{alias}
/_cat/thread_pool
/_cat/plugins
/_cat/fielddata
/_cat/fielddata/{fields}
以上的命令中，你也可以后面加一个v，让输出内容表格显示表头
二：_cluster系列

1、查询设置集群状态

curl -XGET localhost:9200/_cluster/health?pretty=true
pretty=true表示格式化输出
level=indices 表示显示索引状态
level=shards 表示显示分片信息
2、curl -XGET localhost:9200/_cluster/stats?pretty=true
显示集群系统信息，包括CPU JVM等等
3、curl -XGET localhost:9200/_cluster/state?pretty=true
集群的详细信息。包括节点、分片等。
3、curl -XGET localhost:9200/_cluster/pending_tasks?pretty=true
获取集群堆积的任务
3、修改集群配置
举例：
 
curl -XPUT localhost:9200/_cluster/settings -d ‘{
“persistent” : {
“discovery.zen.minimum_master_nodes” : 2
}
}’
transient 表示临时的，persistent表示永久的
4、curl -XPOST ‘localhost:9200/_cluster/reroute’ -d ‘xxxxxx’
对shard的手动控制，参考http://zhaoyanblog.com/archives/687.html
5、关闭节点
关闭指定192.168.1.1节点
curl -XPOST ‘http://192.168.1.1:9200/_cluster/nodes/_local/_shutdown’
curl -XPOST ‘http://localhost:9200/_cluster/nodes/192.168.1.1/_shutdown’
关闭主节点
curl -XPOST ‘http://localhost:9200/_cluster/nodes/_master/_shutdown’
关闭整个集群
$ curl -XPOST ‘http://localhost:9200/_shutdown?delay=10s’
$ curl -XPOST ‘http://localhost:9200/_cluster/nodes/_shutdown’
$ curl -XPOST ‘http://localhost:9200/_cluster/nodes/_all/_shutdown’
delay=10s表示延迟10秒关闭
三：_nodes系列

1、查询节点的状态

curl -XGET ‘http://localhost:9200/_nodes/stats?pretty=true’
curl -XGET ‘http://localhost:9200/_nodes/192.168.1.2/stats?pretty=true’
curl -XGET ‘http://localhost:9200/_nodes/process’
curl -XGET ‘http://localhost:9200/_nodes/_all/process’
curl -XGET ‘http://localhost:9200/_nodes/192.168.1.2,192.168.1.3/jvm,process’
curl -XGET ‘http://localhost:9200/_nodes/192.168.1.2,192.168.1.3/info/jvm,process’
curl -XGET ‘http://localhost:9200/_nodes/192.168.1.2,192.168.1.3/_all
curl -XGET ‘http://localhost:9200/_nodes/hot_threads
四、索引操作

1、获取索引
curl -XGET ‘http://localhost:9200/{index}/{type}/{id}’
2、索引数据
curl -XPOST ‘http://localhost:9200/{index}/{type}/{id}’ -d’{“a”:”avalue”,”b”:”bvalue”}’
3、删除索引
curl -XDELETE ‘http://localhost:9200/{index}/{type}/{id}’
4、设置mapping
curl -XPUT http://localhost:9200/{index}/{type}/_mapping -d ‘{
“{type}” : {
“properties” : {
“date” : {
“type” : “long”
},
“name” : {
“type” : “string”,
“index” : “not_analyzed”
},
“status” : {
“type” : “integer”
},
“type” : {
“type” : “integer”
}
}
}
}’
5、获取mapping
curl -XGET http://localhost:9200/{index}/{type}/_mapping
6、搜索
 
curl -XGET ‘http://localhost:9200/{index}/{type}/_search’ -d '{
“query” : {
“term” : { “user” : “kimchy” } //查所有 “match_all”: {}
},
“sort” : [{ “age” : {“order” : “asc”}},{ “name” : “desc” } ],
“from”:0,
“size”:100
}
curl -XGET ‘http://localhost:9200/{index}/{type}/_search’ -d '{
“filter”: {“and”:{“filters”:[{“term”:{“age”:“123”}},{“term”:{“name”:“张三”}}]},
“sort” : [{ “age” : {“order” : “asc”}},{ “name” : “desc” } ],
“from”:0,
“size”:100
}


## Elasticsearch常用命令
https://blog.ct99.cn/2020/07/09/elasticsearch_chang_yong_ming_ling.html

1.查询所有索引：
curl -XGET http://127.0.0.1:9200/_cat/indices?v

2.删除索引
curl -XDELETE http://guilin:9200/corp-data-v5
#删除多个指定索引，中间用逗号隔开
curl -XDELETE http://localhost:9200/acc-apply-2018.08.09,acc-apply-2018.08.10

#模糊匹配删除

curl -XDELETE  http://localhost:9200/acc-apply-*
{"acknowledged":true}
#使用通配符,删除所有的索引

curl -XDELETE http://localhost:9200/_all
或 curl -XDELETE http://localhost:9200/*
    _all ,* 通配所有的索引
    通常不建议使用通配符，误删了后果就很严重了，所有的index都被删除了
    禁止通配符为了安全起见，可以在elasticsearch.yml配置文件中设置禁用_all和*通配符
    action.destructive_requires_name = true
    这样就不能使用_all和*了

3.获取mapping
GET http://guilin:9200/corp-data/_mapping/corp-type

如果存储不够可以设置定时删除，下面是保留3天的日志

30 2 * * * /usr/bin/curl -XDELETE  http://localhost:9200/*-$(date -d '-3days' +'%Y.%m.%d') >/dev/null 2>&1
以下是定时删除脚本：

#!/bin/bash
time=$(date -d '-3days' +'%Y.%m.%d')
curl -XDELETE  http://localhost:9200/*-${time}

4.别名
POST http://guilin:9200/_aliases
{
    "actions": [{
            "add": {
                "index": "corp-data-v5",
                "alias": "corp-data"
            }
        }
    ]
}

5.查看分词情况
GET http://guilin:9200/corp-data/_analyze?pretty&analyzer=ik_smart&text=橙子互联

6.搜索
POST http://guilin:9200/corp-data/_search?pretty
    1)指定字段{
        "query": {
            "match": {
                "name": "橙子互联"
            }
        }
    }
    2)搜索全部{
        "query": {
            "match": {
                "_all": "橙子互联"
            }
        }
    }

    3)搜索返回高亮{
        "query": {
            "match": {
                "name": "橙子互联"
            }
        },
        "highlight": {
            "pre_tags": ["<tag1>", "<tag2>"],
            "post_tags": ["</tag1>", "</tag2>"],
            "fields": {
                "name": {}
            }
        }

7.全文搜索
GET http://guilin:9200/corp-data/_search?q='橙子互联'

8.新建索引和mapping---- 相当于mysql  数据库  表 表结构
PUT http://guilin:9200/test-index5
POST http://guilin:9200/test-index5/fulltext5/_mapping
{
    "properties": {
        "content": {
            "type": "text",
            "analyzer": "ik_max_word",
            "search_analyzer": "ik_max_word"
        }
    }
}

9.添加记录
POST http://guilin:9200/test-index5/fulltext5/1
{
    "content": "美国疫情"
}

10.时间聚合查询
ES默认会将时间戳认为是UTC时间，所以时间聚和的时候要指定time_zone，否则会不准确（默认 + 8h）
long字段不支持time_zone,
用offset代替，参考：https: //www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-datehistogram-aggregation.html

POST http://guilin:9200/corp-data/_search
{
    "size": 0,
    "aggs": {
        "days_count": {
            "date_histogram": {
                "field": "updatetime",
                "interval": "day",
                "offset": "-8h",
                "format": "yyyy-MM-dd"
            }
        }
    }
}

11.时间范围查询
POST http://guilin:9200/corp-data/_search
{
    "query": {
        "constant_score": {
            "filter": {
                "range": {
                    "updatetime": {
                        "gte": 1519833600000,
                        "lt": 1619862400000
                    }
                }
            }
        }
    }
}

12.bool查询
POST http://guilin:9200/corp-data/_search
{
    "query": {
        "bool": {
            "must": [{
                    "term": {
                        "level": "2"
                    }
                }
            ],
            "must_not": [{
                    "term": {
                        "code": ""
                    }
                }
            ],
            "must": [{
                    "term": {
                        "reg_num": ""
                    }
                }
            ]
        }
    }
}

13.bool + 聚合查询
POST http://guilin:9200/corp-data/_search
{
    "query": {
        "bool": {
            "must_not": [{
                    "term": {
                        "founded_date": ""
                    }
                }
            ]
        }
    },
    "size": 0,
    "aggs": {
        "data_level": {
            "terms": {
                "field": "level"
            }
        }
    }
}

14.设置最大返回记录数
PUT http://guilin:9200/corp-data/_settings
{
    "index": {
        "max_result_window": "50000000"
    }
}

15.更新所有索引参数
curl - XPUT 'http://localhost:9200/_all/_settings?preserve_existing=true' - d '{
"index.cache.field.expire" : "10m",
"index.cache.field.max_size" : "50000",
"index.cache.field.type" : "soft"
}'

## linux curl es查询示例
查询 optSourceId=24
curl -XGET http://es:9200/filelog_1 -H 'Content-Type: application/json' -d "{\"query\":{\"match\":{\"optSourceId\":\"24\"}}}"

查询姓氏中包含“Smith”并且年龄大于30岁的员工：
curl -H 'Content-Type: application/json' -X GET http://es:9200/employee/_search -d '{"query":{"bool":{"filter":{"range":{"age":{"gt":30}}},"must":{"match":{"last_name":"Smith"}}}}}'



## max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```bash
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
echo "* - nofile 65535" >> /etc/security/limits.conf
sysctl -p

# 报错信息提示是数据目录读取操作没有权限，查看存储目录，es目录权限变成root ，要调整为 polkitd.input
# 停止应用，停止中间件，执行修改es目录权限：
# 先查询用户ＩＤ为999的用户名和用户组ID为999的用户组
chown -R $(cat /etc/passwd|grep 999|awk -F ":" '{print $1}').$(cat /etc/group|grep 999|awk -F ":" '{print $1}') es
chown -R polkitd.input es   #如果确定用户ID为999的用户为polkitd,用户组的ID为999用户组为input执行这个命令
```
## 解决Elasticsearch索引只读（read-only）
原因为：es 的设置默认是 85% 和 90 %，95%

当为85%时：Elasticsearch不会将碎片分配给磁盘使用率超过85%的节点（ cluster.routing.allocation.disk.watermark.low）

当为90%时：Elasticsearch尝试重新分配给磁盘低于使用率90%的节点（cluster.routing.allocation.disk.watermark.high）

当为85%时：Elasticsearch执行只读模块（cluster.routing.allocation.disk.watermark.flood_stage）

1、扩大磁盘或者删除部分历史索引

2、重置改只读索引快

复制代码
某一个索引重置只读模块
PUT /twitter/_settings
{
  "index.blocks.read_only_allow_delete": null
}
所有索引重置只读模块
PUT /_all/_settings
{
  "index.blocks.read_only_allow_delete": null
}
PUT /_cluster/settings
{
  "persistent" : {
    "cluster.blocks.read_only" : false
  }
}
复制代码
修改默认设置

复制代码
可以修改为具体的磁盘空间值，也可以修改为百分之多少
临时修改
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.disk.watermark.low": "100gb",
    "cluster.routing.allocation.disk.watermark.high": "50gb",
    "cluster.routing.allocation.disk.watermark.flood_stage": "10gb",
    "cluster.info.update.interval": "1m"
  }
}
永久修改
PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.disk.watermark.low": "100gb",
    "cluster.routing.allocation.disk.watermark.high": "50gb",
    "cluster.routing.allocation.disk.watermark.flood_stage": "10gb",
    "cluster.info.update.interval": "1m"
  }
}
https://www.elastic.co/guide/en/elasticsearch/reference/6.8/disk-allocator.html