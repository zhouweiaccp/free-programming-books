

//$('.cnblogs_code').jquerySpwialog({title:'222'})
https://www.cnblogs.com/sunpengwei/p/6934307.html
(function($){
    var __INFO__ = {
        plug:'jquerySpwialog',
        ver:'1.0.1.2',
        author:'sunpengwei'
    };
    var defaults = {
        title:"",
        tips:"",
        txt:null,
        ok:"确定",
        cancel:"",
        callback:function(){},
        htmls:'<div id="jquery_dn_dialog_mask" style="background:rgba(0,0,0,0.3);width:100%;height:100%;position:fixed;top:0;left:0;z-index:2147483647">\
                <div id="jqurey_dn_dialog_main" style="background:#dedede;left:50%;top:50%;position:absolute;transform:translate(-50%,-50%);border-radius:10px;overflow:hidden;min-width:270px">\
                      <h1 id="jqdndialog_title" style="text-align:center;font-size:22px;padding:10px 0 0 0;magring:10px 5px">弹窗标题</h1>\
                      <div id="jqdndialog_tips" style="font-size:18px;margin:0 17px;padding:0 0 20px 0">弹窗内容</div>\
                    <p style="margin:5px 20px">\
                        <input id="jqdndialog_txt" type="text" style="border-radius:5px;width:100%;line-height:30px;font-size:20px;border:0px">\
                    </p>\
                    <div id="jqdndialog_button" style="border-top:1px solid #b8b8b8;display:flex;justify-content:space-around;">\
                        <a href="javascript:;" style="color:#007aff;font-weight:bold;display:inline-block;height:44px;line-height:44px;text-align:center;text-decoration:none;width:100%">按钮</a>\
                        <a href="javascript:;" style="color:#007aff;font-weight:bold;display:inline-block;height:44px;line-height:44px;text-align:center;text-decoration:none;width:100%;border-left: 1px solid #b8b8b8" >按钮</a>\
                    </div>\
                </div>\
            </div>'
    };

    $.fn[__INFO__.plug] = $[__INFO__.plug] = function(options){
        var settings = $.extend({},defaults,options);

        //初始化
        var initDOM = function(conf){
            if(conf) settings = $.extend({},settings,conf);
            //获取元素
            var $mask = $(settings.htmls).appendTo(document.body);
            var $main = $mask.children("#jqurey_dn_dialog_main");
            var $title = $main.children("#jqdndialog_title");
            var $tips = $main.children("#jqdndialog_tips");
            var $txt = $main.find("#jqdndialog_txt");
            var $ok = $main.find("#jqdndialog_button a:first");
            var $cancel = $main.find("#jqdndialog_button a:last");
            //赋值
            $title.html(settings.title);
            $tips.html(settings.tips);
            if(settings.txt === null){
                $txt.hide();
            }else{
                $txt.val(settings.txt).focus();
            }

            $ok.html(settings.ok);
            if(settings.cancel){
                $cancel.html(settings.cancel);
            }else{
                $cancel.hide();
            }

            $main.find("#jqdndialog_button a").bind("touchstart click",function(e){
                console.log(e.type);
                e.preventDefault();
                e.stopPropagation();
                var res = {result:$(this).text()};
                if(settings.txt !== null) res.texts = $txt.val();

                if(settings.callback) settings.callback(res);
                $mask.remove();

            }).hover(function(){
                $(this).css("background","#d2d2d2");
            }, function(){
                $(this).css("background","transparent");
            });
        };

        this.bind("touchstart click",function(e){
            e.preventDefault();
            e.stopPropagation();
            initDOM();
        });

        if($.isFunction(this)) initDOM();
        this.showSpwialog  = function(options){
            initDOM(options);
        }

        return this;
    };
})(jQuery);