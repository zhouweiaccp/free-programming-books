一、相同点：
1.都是循环遍历数组中的每一项

2.每次执行匿名函数都支持三个参数，参数分别为item（当前每一项），index（索引值），arr（原数组）

3.匿名函数中的this都是指向window

4.只能遍历数组

二、不同点
1.map()会分配内存空间存储新数组并返回，forEach()不会返回数据。

2.forEach()允许callback更改原始数组的元素。map()返回新的数组。

1、forEach()
forEach()针对每一个元素执行提供的函数，对数据的操作会改变原数组。

var arr1 = [0,2,4,6,8];
var newArr1 = arr1.forEach(function(item,index,arr1){
  console.log(this);
  console.log(arr1);
   arr1[index] = item/2; 
},this);
console.log(arr1);
console.log(newArr1);
使用场景：并不打算改变数据的时候，而只是想用数据做一些事情 ，比如存入数据库或则打印出来。

二、map
map()不会改变原数组的值，返回一个新数组，新数组中的值为原数组调用函数处理之后的值；

var arr = [0,2,4,6,8];
 var newArr = arr.map(function(item,index,arr){
            console.log(this);
            console.log(arr);
            return item/2;
 },this);
 console.log(newArr);
使用场景：map()适用于你要改变数据值的时候。不仅仅在于它更快，而且返回一个新的数

作者：爱养多肉的前端小萌
链接：https://www.jianshu.com/p/6146bf9c614d