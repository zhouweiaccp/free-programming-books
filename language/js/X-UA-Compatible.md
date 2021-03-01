https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/compatibility/cc288325(v=vs.85)?redirectedfrom=MSDN
https://blog.csdn.net/Lpandeng/article/details/71474196
在IE8浏览器以后版本，都有一个“兼容性视图”，让不少新技术无法使用。那么如何禁止浏览器自动选择“兼容性视图”，强制IE以最高级别的可用模式显示内容呢？下面就介绍一段HTML代码。 

X-UA-Compatible是一个设置IE浏览器兼容模式的属性，在IE8浏览器之后诞生。IE8或者IE9有很多种模式，比如，IE8有4种模式：IE5.5怪异模式、IE7标准模式、IE8几乎标准模式、IE8标准模式；而IE9有7种模式: IE5.5怪异模式、IE7标准模式、IE8几乎标准模式、IE8标准模式、IE9几乎标准模式、IE9标准模式、XML模式。 

我们常使用代码： 

<meta http-equiv="X-UA-Compatible" content="IE=8" /> 

来开启IE8的标准渲染模式。这种方式在只存在IE8浏览器的时候比较合适，但是后来又出现了IE9、IE10、IE11等等。我们就可以这样写： 

<meta http-equiv="X-UA-Compatible" content="IE=9;IE=8;IE=7;" /> 

意思就是优先最前面的IE9，没IE9就用IE8。那么如果针对每一种都写一遍，似乎就有些冗余了。 

所以我们改变方式采用代码： 

<meta http-equiv="X-UA-Compatible" content="edge" /> 

Edge模式通知IE以最高级别的可用模式显示内容，这实际上破坏了“锁定”模式。 

当然，我们还见过这样的代码： 

<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 

就是增加了chrome=1值，目的是触发Google Chrome Frame，不过现在Google已经抛弃Google Chrome Frame了，因此也不用这样写了。 

总结： 

在 <!DOCTYPE html> 下，使用代码： 

<meta http-equiv="X-UA-Compatible" content="edge" /> 

触发标准模式，这个是最有效的方法。


 


 


 


 


 


 


 


用Meta标签代码让360双核浏览器默认极速模式打开网站不是兼容模式
在head标签中添加一行代码：

<html>

<head>

<meta name="renderer" content="webkit|ie-comp|ie-stand">

</head>

<body>

</body>

</html>

content的取值为webkit,ie-comp,ie-stand之一，区分大小写，分别代表用webkit内核，IE兼容内核，IE标准内核。
若页面需默认用极速核，增加标签：<meta name="renderer" content="webkit">
若页面需默认用ie兼容内核，增加标签：<meta name="renderer" content="ie-comp">
若页面需默认用ie标准内核，增加标签：<meta name="renderer" content="ie-stand">