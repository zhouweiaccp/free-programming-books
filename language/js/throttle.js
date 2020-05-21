
//函数防抖（debounce）：当持续触发事件时，一定时间段内没有再触发事件，事件处理函数才会执行一次

// 防抖
function debounce(fn, wait) {    
    var timeout = null;    
    return function() {        
        if(timeout !== null)   clearTimeout(timeout);        
        timeout = setTimeout(fn, wait);    
    }
}
// 处理函数
function handle() {    
    console.log(Math.random()); 
}
// 滚动事件
window.addEventListener('scroll', debounce(handle, 1000));


// https://underscorejs.net/#functions
//函数节流（throttle）：当持续触发事件时，保证一定时间段内只调用一次事件处理函数
function throttle(func,delay){
    let timer;
    let last;//上一次执行事件的时间
    return function (args){
       let now = new Date();//当前时间
       if(!last){
           func(args)
           last = now;
       }else{
            if(now-last>=delay){
                //当上一次的执行事件和现在时间差大于延迟时间就立即执行
                func(args);
                last = now;
            }else{
                //主要是为了处理在小于延迟事件内的触发事件
                clearTimeout(timer);
                //最后一次按键事件
                //当最后一次 可能会出现 当前时间减上一次时间小于delay，也就是说 可能到了最后的时候，不会执行函数，也就无法获取到完整的数据，
                //所以，对最后一次触发事件进行延迟，延迟一个周期就可以了
                timer = setTimeout(function(){
                    func(args);
                   // last = now;
                },delay);

            }
       }
      
        
    }
}
function ajax(element){
      console.log(element+'  '+(new Date()));
}
var demo = throttle(ajax,1000);
//监听事件
$(document).bind('click',function(){
    //执行事件
    demo('ss');
    
})