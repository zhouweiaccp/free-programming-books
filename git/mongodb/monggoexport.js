// 备份指定月份数据，并导出
print('start  ...........'+(new Date().toString()))
var start='1970-01-01T00:00:00';
var endt='2020-01-01T00:00:00';
var tabnew='LogOperationDataEntitynew';//+(Math.random()*10000).toString().substr(0,3);
var nu=db.LogOperationDataEntity.find({"OptTime":{ $gte: new Date(start), $lte: new Date(endt) }}).count();
print('total:'+nu);
var pagesize=10000;
var repeatnum=nu/pagesize+1;

print('bak table...'+tabnew +'....');
for(i=0;i<=repeatnum;i++){

print('start insert ...i:'+i+",total_num:"+repeatnum);
db.getCollection('LogOperationDataEntity').aggregate([
{
$match : { OptTime : { $gt: new Date(start), $lt: new Date(endt) } }},
{$limit:10000}

]).forEach(function(doc){
	try{
db.getCollection(tabnew).insertOne(doc);
print(doc["_id"]);

	}catch(ee){print(ee);}

})

}

print('bak table...'+tabnew +'....done');

print('del history data.......');
//db.LogOperationDataEntity.deleteMany({"OptTime":{ $gte: new Date(start), $lt: new Date(endt)}});

print('end del .  ..........'+(new Date().toString()))


