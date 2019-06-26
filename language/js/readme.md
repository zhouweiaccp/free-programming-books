## js函数中传入的event参数
https://blog.csdn.net/sinat_27801935/article/details/75042940
如果没有传入event作为参数，在函数内部如何获取event呢？
js对于函数的定义是非常松，即使你在函数定义时未写任何参数，或者你定义的参数有多个，但是你调用时，一个参数也不填，也不会出错的。 
因为js函数内默认有个变量，保存你的入参叫：arguments， 
他是一个数组，下标从0开始， 
所以获取event可以写成

function eventTest(){
    var event = window.event||arguments[0];
    //target 就是这个对象
    target = event.srcElement||event.target,
    //这个对象的值
    targetValue = target.value;
}
当然，有的时候需要给函数传入几个参数，这时如果要用想用到event的话可以这么写

function eventTest(a,b){
    var event = window.event || arguments.callee.caller.arguments[0]
    //target 就是这个对象
    target = event.srcElement||event.target,
    //这个对象的值
    targetValue = target.value;
}
如果传入了参数却如第一种写法的话，则arguments中将会传入传入的参数，这时获取的arguments[0]就会是第一个传入的参数了