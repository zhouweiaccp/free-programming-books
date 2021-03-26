

curl http://192.168.251.67:30003/signlog/_search?pretty -H "Content-Type:application/json" -d '{"size":0,"query":{"query_string":{"query":"*"}},"aggs":{"login_times":{"terms":{"field":"userIdentityId"}}}}'


curl http://192.168.251.67:30003/signlog/_search?pretty -H "Content-Type:application/json" -d '{"size":0,"query":{"query_string":{"query":"signInTime:[2021-01-01 TO 2021-03-30] AND clientType:(128)"}},"aggs":{"login_times":{"terms":{"field":"userIdentityId"}}}}'



curl http://192.168.251.67:30003/signlog/_search?pretty -H "Content-Type:application/json" -d '{"size":0,"query":{"query_string":{"query":"signInTime:[2021-03-01 TO 2021-03-30] AND clientType:(128)"}},"aggs":{"login_times":{"terms":{"field":"userIdentityId"}}}}'



# 查询特定匹配
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"match":{}}}'
 
# bool过滤 
# must :: 多个查询条件的完全匹配,相当于 and 。
# must_not :: 多个查询条件的相反匹配，相当于 not 。
# should :: 至少有一个查询条件匹配, 相当于 or 。
# 但是当should和must共用时should不生效
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"bool":{"must":{"match":{}}}}}'
 
#multi_match 允许你做 match 查询的基础上同时搜索多个字段：
curl -XPOST 127.0.0.1:9200/signlog/_search-d '{"query":{"multi_match":{"query":"","fields":[""]}}}'
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"bool":{"must_not":{"match":{}}}}}'
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"bool":{"shold":{"match":{}}}}}'
 
#term过滤
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"term":{"tag":"1"}}}'
 
#terms允许查询多个
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"terms":{"tag":["1","2"]}}}'
 
#range 过滤 gt:大于 gte:大于等于 lt:小于 lte:小于等于
 
curl -XPOST 127.0.0.1:9200/signlog/_search -d '{"query":{"range":{"age":{"gte":20,"lt":30}}}}'



基础知识
bucket 其实就是分组 相当于msql 中 group by
metric 就是统计 相当于 mysql 中的count

案例
以一个家电卖场中的电视销售数据为背景，来对各种品牌，各种颜色的电视的销量和销售额，进行各种各样角度的分析

GET /tvs/sales/_search
{
  "size": 0,
  "aggs": {
    "ppp": {
      "terms": {
        "field": "color"
      }
    }
  }
}

size:0 只获取统计之后的结果,统计用到的原始数据不显示
aggs:固定语法聚合统计的标志
ppp:为聚合后的字段随便起一个名字
terms:需要分组的字段


对每种颜色的家电求平均值

GET /tvs/sales/_search
{
  "size": 0,
  "aggs": {
    "colors": {
      "terms": {
        "field": "color"
      },
      "aggs": {
        "avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    }
  }
}
根据color分bucket之后 每个bucket再求平均值
在第一个aggs 里面 平级的json结购再添加一个aggs

每种颜色的平均价格，以及找到每种颜色每个品牌的平均价格
我们可以进行多层次的下钻
比如说，现在红色的电视有4台，同时这4台电视中，有3台是属于长虹的，1台是属于小米的
红色电视中的3台长虹的平均价格是多少？
红色电视中的1台小米的平均价格是多少？


GET /tvs/sales/_search
{
  "size": 0,
  "aggs": {
    "colors": {
      "terms": {
        "field": "color"
      },
      "aggs": {
        "avg_price": {
          "avg": {
            "field": "price"
          }
        },
        "group_brand":{
            "terms": {
              "field": "brand"
            },
            "aggs": {
              "b_avg_p": {
                "avg": {
                  "field": "price"
                }
              }
            }
          }    
      }
    }
  }
}
一次bucket之后多次metric 多次计算 取最大 最小 平均 求和

GET /tvs/sales/_search
{
   "size" : 0,
   "aggs": {
      "colors": {
         "terms": {
            "field": "color"
         },
         "aggs": {
            "avg_price": { "avg": { "field": "price" } },
            "min_price" : { "min": { "field": "price"} }, 
            "max_price" : { "max": { "field": "price"} },
            "sum_price" : { "sum": { "field": "price" } } 
         }
      }
   }
}

histogram:区间分组,0-2000 ,2000-4000 来分组

统计各个价格区间内的家电的销售总和

GET /tvs/sales/_search
{
 "size": 0,
 "aggs": {
   "price": {
     "histogram": {
       "field": "price",
       "interval": 2000
     },
     "aggs": {
       "revenue": {
         "sum": {
           "field": "price"
         }
       }
     }
   }
 }
}


date histogram，按照我们指定的某个date类型的日期field，以及日期interval，按照一定的日期间隔，去划分bucket

GET /tvs/sales/_search
{
   "size" : 0,
   "aggs": {
      "sales": {
         "date_histogram": {
            "field": "sold_date",
            "interval": "month", 
            "format": "yyyy-MM-dd",
            "min_doc_count" : 0, 
            "extended_bounds" : { 
                "min" : "2016-01-01",
                "max" : "2017-12-31"
            }
         }
      }
   }
}

min_doc_count：即使某个日期interval，2017-01-01~2017-01-31中，一条数据都没有，那么这个区间也是要返回的，不然默认是会过滤掉这个区间的
extended_bounds，min，max：划分bucket的时候，会限定在这个起始日期，和截止日期内
————————————————
版权声明：本文为CSDN博主「程序员小单」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/sswltt/article/details/105820222