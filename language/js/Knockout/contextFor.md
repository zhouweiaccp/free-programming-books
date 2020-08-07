
在前几篇中我们已经说了，对于每个具有声明式绑定的dom元素，ko都会为其设置一个绑定上下文(bindingContext)和一个绑定对象。而每个绑定上下文中都包含$parent和$data俩个属性，$data属性就是该dom元素的绑定对象，$parent属性是上级元素的绑定对象。也就是说如果我们要向访问绑定对象，首先要获得绑定上下文，在通过绑定上下文来访问绑定对象：bingingContext.$data.属性名、bingingContext.$parent.属性名。而我们以前的例子中都是只用$data.属性名、$parent.属性名就可以访问，这是因为在ko内部(准确说是在binding组件)已经帮我们获得了bingingContext。如果我们想在ko外部直接访问绑定对象或绑定上下文，可以使用：ko.dataFor(element)、ko.contextFor(element)。


基本语法：访问$data

Html代码

<span data-bind="text: myName" id="111"></span><br/>
<a href="javascript:void(0)"  onClick="toBingingData()">查看绑定对象</a>

Js代码


<script type="text/javascript">
ko.applyBindings({        
		myName:"张三"
    });

</script>
<script type="text/javascript">
function toBingingData(){
    var bindingContext = ko.contextFor(document.getElementById("111"));//获得绑定上下文
    alert(bindingContext['$data'].myName);//访问绑定对象
	//var bindingData = ko.dataFor(document.getElementById("111"));//直接获得绑定对象
	//alert(bindingData.myName);
}
</script>

基本语法：访问$parent

Html代码


<table data-bind="foreach: people"  id="333">
        <tr>
            <td data-bind="text: firstName" id="111"></td>
            <td data-bind="text: lastName" id="222"></td>
        </tr>
</table>
<a href="javascript:void(0)"  onClick="toBindingData()">查看绑定对象</a>

Js代码


<script type="text/javascript">
ko.applyBindings({
        people: [
            { firstName: 'Bert', lastName: 'Bertington' }
        ],
		myName:"zuoliangzhu"
    });

</script>
<script type="text/javascript">
function toBindingData(){
    var bindingContext = ko.contextFor(document.getElementById("111"));
	alert(bindingContext['$parent'].myName);//访问上级绑定对象
	alert(bindingContext['$data'].firstName);//访问自身绑定对象
	//var parentBindingContext = ko.contextFor(document.getElementById("333"));//直接获得上级绑定上下文
	//alert(parentBindingContext['$data'].myName);
}
</script>

结合jquery使用

Html代码

<span data-bind="text: myName" id="111"></span><br/>

Js代码


<script type="text/javascript">
ko.applyBindings({        
		myName:"张三"
    });

</script>
<script type="text/javascript">
$("#111").click(function () {
   var bindingData = ko.dataFor(this);//获得绑定对象
   alert(bindingData.myName);//访问绑定对象
});
</script>

注意：要引入jquery库

来自：http://www.see-source.com/front/front!index 