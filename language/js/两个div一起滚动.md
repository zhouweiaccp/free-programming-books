


## 两个div同步滚动
- [](https://www.cnblogs.com/pangpanghuan/p/6495158.html)
- [](https://www.kitesky.com/archives/184)

```js
    $("#div").scroll(function(){
        $("#div1").scrollTop($(this).scrollTop()); // 纵向滚动条
        $("#div1").scrollLeft($(this).scrollLeft()); // 横向滚动条
    });
    $("#div1").scroll(function(){
        $("#div").scrollTop($(this).scrollTop());
        $("#div1").scrollLeft($(this).scrollLeft());
    });   
```

```js
<div id="div1">
	// code...
</div>
<div id="div2">
	// code...
</div>
$("#div1").scroll(function(){
    $("#div2").scrollTop($(this).scrollTop()); // 纵向滚动条
    $("#div2").scrollLeft($(this).scrollLeft()); // 横向滚动条
});    
$("#div2").on("mousewheel DOMMouseScroll", function(e){
    var scroll_top = $("#div1").scrollTop();
    var scroll_left = $("#div1").scrollLeft();
    if(e.originalEvent.wheelDelta > 0 || e.originalEvent.detail < 0){
		$("#div1").scrollTop(scroll_top - 25);
		$("#div1").scrollLeft(scroll_left - 25)
	} else {
		$("#div1").scrollTop(scroll_top +25);
		$("#div1").scrollLeft(scroll_left +25)
	}
    e.preventDefault()
});
//原文链接：https://blog.csdn.net/weixin_42979149/article/details/94033787
```


## div demo2
```html
        <div id="diffBox">
            <div id="leftPane">
                <div class="diffHeader">
                    <jue:DropdownList ID="ddlLeftVer" runat="server" OnClientChange="ddlLeftVer_OnClientChange" Width="200"></jue:DropdownList>
                    <div id="compareLoadingLeft" class="compareLoading"></div>
                </div>
                <div class="diffPane"></div>
            </div>
            <div id="rightPane">
                <div class="diffHeader">
                    <jue:DropdownList ID="ddlRightVer" runat="server" OnClientChange="ddlRightVer_OnClientChange" Width="200"></jue:DropdownList>
                    <div id="compareLoadingRight" class="compareLoading"></div>
                </div>
                <div class="diffPane"></div>
            </div>
            <div class="clear">
            </div>
        </div>
```
```js

//
function InitializeDiffPanes() {
    var diffBox = $("#diffBox");
    var parent = diffBox.parent();
    var diffPane = $(".diffPane", diffBox);
    var leftTable = $(".diffTable", diffPane[0]);
    var rightTable = $(".diffTable", diffPane[1]);
    //var diffPaneLinesLeft = $("td.line", leftTable);
    //var diffPaneLineHeight = diffPaneLinesLeft.outerHeight();
    var scrollBarsActive = false;
    sizeDiffTablesEqually();
    sizeDiffPanesToWindow();

    $(diffPane[0]).scroll(onLeftDiffPaneScroll);//滚动左边
    $(diffPane[1]).scroll(onRightDiffPaneScroll);//滚动右

    $(window).resizeComplete(function () {
        sizeDiffTablesEqually();
        sizeDiffPanesToWindow();
    });

    function sizeDiffPanesToWindow() {
        //var lineCount = diffPaneLinesLeft.length;
        //var contentHeight = lineCount * diffPaneLineHeight;
        diffPane.hide();
        var parentHeight = parent.outerHeight(true);
        var parentTop = parent.offset().top;
        var windowHeight = $(window).height();
        var newHeight = windowHeight - (parentHeight + parentTop);
        diffPane.show();
        //if (contentHeight < newHeight) {
        //    newHeight = contentHeight;
        //    if (scrollBarsActive) {
        //         newHeight += diffPaneLineHeight + 3;
        //    }
        //}
        if (newHeight > 0) {
            diffPane.height(newHeight);
        }
    }

    function sizeDiffTablesEqually() {
        var maxWidth = Math.max(leftTable.width(), rightTable.width());
        var maxHeight = Math.max(leftTable.height(), rightTable.height());

        leftTable.height(maxHeight);
        rightTable.height(maxHeight);

        if (diffPane.width() < maxWidth) {
            leftTable.width(maxWidth);
            rightTable.width(maxWidth);
            scrollBarsActive = true;
        }
    }

    function onLeftDiffPaneScroll(e) {
        var left = this.scrollLeft;
        var top = this.scrollTop;
        if (top != diffPane[1].scrollTop) diffPane[1].scrollTop = top;
        if (left != diffPane[1].scrollLeft) diffPane[1].scrollLeft = left;

        var scrollH = this.scrollHeight;//滚动条的长度
        var docHeight = this.clientHeight;
        if ((scrollH - top - docHeight == 0) && top != 0) {
            if (!isLoadOver) {
                reloadFileContent();
            }
        }
    }

    function onRightDiffPaneScroll(e) {
        var left = this.scrollLeft;
        var top = this.scrollTop;
        if (top != diffPane[0].scrollTop) diffPane[0].scrollTop = top;
        if (left != diffPane[0].scrollLeft) diffPane[0].scrollLeft = left;
    }
}

jQuery.fn.resizeComplete = function (callback) {

    var element = this;
    var height = element.height();
    var width = element.width();
    var monitoring = false;
    var timer;

    function monitorResizing() {

        if (!same()) {
            height = element.height();
            width = element.width();
            timer = setTimeout(function () { monitorResizing() }, 500);
        }
        else {
            clearTimeout(timer);
            callback();
            monitoring = false;
        }
    }

    function same() {
        var newHeight = element.height();
        var newWidth = element.width();

        return newHeight == height && newWidth == width;
    }

    function onResize() {
        if (monitoring) return;
        if (same()) return;
        monitoring = true;
        monitorResizing();
    }

    if ($.browser.mozilla) {
        element.resize(callback);
    }
    else {
        element.resize(onResize);
    }
}

```