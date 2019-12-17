
//关闭浏览器窗口
window.opener = null;
window.open(' ', '_self');
window.close()



var browserName = navigator.appName;
if (browserName == "Netscape") {
    window.location.href = "about:blank";                    //关键是这句话
    window.close();
} else if (browserName == "Microsoft Internet Explorer") {
    window.opener = null;
    window.close();
}