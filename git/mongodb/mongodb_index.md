1. 创建／重建索引
MongoDB全新创建索引使用ensureIndex()方法，对于已存在的索引可以使用reIndex()进行重建。

1.1 创建索引ensureIndex()
MongoDB创建索引使用ensureIndex()方法。



语法结构

db.COLLECTION_NAME.ensureIndex(keys[,options])
keys，要建立索引的参数列表。如：{KEY:1}，其中key表示字段名，1表示升序排序，也可使用使用数字-1降序。
options，可选参数，表示建立索引的设置。可选值如下：
background，Boolean，在后台建立索引，以便建立索引时不阻止其他数据库活动。默认值 false。
unique，Boolean，创建唯一索引。默认值 false。
name，String，指定索引的名称。如果未指定，MongoDB会生成一个索引字段的名称和排序顺序串联。
dropDups，Boolean，创建唯一索引时，如果出现重复删除后续出现的相同索引，只保留第一个。
sparse，Boolean，对文档中不存在的字段数据不启用索引。默认值是 false。
v，index version，索引的版本号。
weights，document，索引权重值，数值在 1 到 99,999 之间，表示该索引相对于其他索引字段的得分权重。
如，为集合sites建立索引：

> db.sites.ensureIndex({name: 1, domain: -1})
{
  "createdCollectionAutomatically" : false,
  "numIndexesBefore" : 1,
  "numIndexesAfter" : 2,
  "ok" : 1
}
注意：1.8版本之前创建索引使用createIndex()，1.8版本之后已移除该方法

 

1.2 重建索引reIndex()
db.COLLECTION_NAME.reIndex()
如，重建集合sites的所有索引：

> db.sites.reIndex()
{
  "nIndexesWas" : 2,
  "nIndexes" : 2,
  "indexes" : [
    {
	  "key" : {
		"_id" : 1
	  },
	  "name" : "_id_",
		"ns" : "newDB.sites"
	},
	{
	  "key" : {
		"name" : 1,
		"domain" : -1
	  },
	  "name" : "name_1_domain_-1",
	  "ns" : "newDB.sites"
	}
  ],
  "ok" : 1
}
 

2. 查看索引
MongoDB提供了查看索引信息的方法：getIndexes()方法可以用来查看集合的所有索引，totalIndexSize()查看集合索引的总大小，db.system.indexes.find()查看数据库中所有索引信息。

 

2.1 查看集合中的索引getIndexes()
db.COLLECTION_NAME.getIndexes()
如，查看集合sites中的索引：

>db.sites.getIndexes()
[
  {
	"v" : 1,
	"key" : {
	  "_id" : 1
	},
	"name" : "_id_",
	"ns" : "newDB.sites"
  },
  {
	"v" : 1,
	"key" : {
	  "name" : 1,
	  "domain" : -1
	},
	"name" : "name_1_domain_-1",
	"ns" : "newDB.sites"
  }
]
 

2.2 查看集合中的索引大小totalIndexSize()
db.COLLECTION_NAME.totalIndexSize()
如，查看集合sites索引大小：

> db.sites.totalIndexSize()
16352
 

2.3 查看数据库中所有索引db.system.indexes.find()
db.system.indexes.find()
如，当前数据库的所有索引：

> db.system.indexes.find()
 

3. 删除索引
不在需要的索引，我们可以将其删除。删除索引时，可以删除集合中的某一索引，可以删除全部索引。

3.1 删除指定的索引dropIndex()
db.COLLECTION_NAME.dropIndex("INDEX-NAME")
如，删除集合sites中名为"name_1_domain_-1"的索引：

> db.sites.dropIndex("name_1_domain_-1")
{ "nIndexesWas" : 2, "ok" : 1 }
 

3.3 删除所有索引dropIndexes()
db.COLLECTION_NAME.dropIndexes()
如，删除集合sites中所有的索引：

> db.sites.dropIndexes()
{
  "nIndexesWas" : 1,
  "msg" : "non-_id indexes dropped for collection",
  "ok" : 1
}