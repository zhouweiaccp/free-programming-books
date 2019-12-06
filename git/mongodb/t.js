db.getCollection('LogOperationDataEntity').aggregate([
{$match : { UserId : 2 }},//过滤数据，只输出符合结果的文档
     {
       $project: {//$project	修改输入文档的结构(例如重命名，增加、删除字段，创建结算结果等)
           "_id":1,
           "OptTime":1,
           "UserId":1
       }
     }
,{ $sort: { Time: -1 } }//$sort	将结果进行排序后输出
,{ $limit:220}//$limit	限制管道输出的结果个数
]).forEach(function(doc){
   //  print(doc["_id"].toString()); 
	 //print(( doc["OptTime"].toLocaleString()));
	// print( doc["OptTime"].toISOString());
	 //print(typeof( doc["OptTime"].toString()));
	 try{
	 var t=new Date(doc["OptTime"].toISOString());
	// print(t.getHours());
	var hours=t.getHours();
	   if(hours>0 && hours<=6){
         print('del:'+doc["_id"]+",hours:"+hours);
          db.LogOperationDataEntity.deleteOne({"_id":doc["_id"]});
        }else{
            print('else');
            }
	 }catch(e){
		 print(e)
	 }
   
    })