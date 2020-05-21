


/* debounce监控输入框数据变化 start */
var _debounce = function(func, wait) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        func.apply(context, args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  };
  function watchLength(options) { //计算长度
    var watchDom = options.watchDom, 
        targetDom = options.targetDom;
  
    targetDom.text(watchDom.text().length);
  
    var calculateLength = function(){
      targetDom.text(watchDom.val().length);
    }
    watchDom.on('focus input propertyChange',_debounce(calculateLength, 100));
  }
  /* debounce监控输入框数据变化 end */
  
  // 函数调用
  watchLength({
    watchDom: $('.intro-inp'),
    limitLen: 200,
    targetDom: $('.edit-count span'),
  }); 