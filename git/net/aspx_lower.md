

## HttpApplication
HttpApplication  按照以下顺序引发应用程序事件：
BeginRequest

AuthenticateRequest

PostAuthenticateRequest

AuthorizeRequest

PostAuthorizeRequest

ResolveRequestCache

PostResolveRequestCache

PostResolveRequestCache 事件之后和 PostMapRequestHandler 事件之前，将创建一个事件处理程序（与请求 URL 对应的页）。 如果服务器在集成模式下运行 IIS 7.0，并且至少 .NET Framework 版本3.0，则会引发 MapRequestHandler 事件。 如果服务器在经典模式下运行 IIS 7.0 或 IIS 的早期版本，则无法处理此事件。
PostMapRequestHandler

AcquireRequestState

PostAcquireRequestState

PreRequestHandlerExecute

执行事件处理程序。
PostRequestHandlerExecute

ReleaseRequestState

PostReleaseRequestState

引发 PostReleaseRequestState 事件之后，任何现有响应筛选器都将筛选输出。
UpdateRequestCache

PostUpdateRequestCache

LogRequest。
此事件在 IIS 7.0 集成模式下受支持，并且至少 .NET Framework 3。0
PostLogRequest

此事件支持 IIS 7.0 集成模式，并且至少支持 .NET Framework 3。0
EndRequest


https://docs.microsoft.com/zh-cn/dotnet/api/system.web.httpapplication?redirectedfrom=MSDN&view=netframework-4.8
https://www.cnblogs.com/yxxrui/p/HttpApplicationOrder.html


## System.Web.UI.Page
protected void Page_PreInit(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_PreInit<br/>");
}
protected void Page_Init(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_Init<br/>");
}
protected void Page_InitComplete(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_InitComplete<br/>");
}
protected void Page_PreLoad(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_PreLoad<br/>");
}
protected void Page_Load(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_Load<br/>");
}
protected void Page_LoadComplete(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_LoadComplete<br/>");
}
protected void Page_PreRender(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_PreRender<br/>");
}
protected void Page_PreRenderComplete(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_PreRenderComplete<br/>");
}
protected void Page_SaveStateComplete(object sender, EventArgs e)
{   //这里设置断点
    Response.Write("执行Page_SaveStateComplete<br/>");
}
protected void Page_Unload(object sender, EventArgs e)
{   //这里设置断点
    //这里是页面卸载阶段，不能使用Response.Write方法，一般该事件内执行释放本页面控制的系统资源
}

如上图所示，从Init到Unload共有10个事件，这写就是页面生命周期过程中执行的顺序事件，而像Error(发生未处理的异常时执行，可用Page_Error形式编写)、AbortTransaction(事务处理被终止)等等是页面在满足特定条件下才会触发的事件，因此本篇文章后续都不会再涉及。

    本文所谓页面生命周期的阶段，就是从触发一个事件到触发下一个事件之间的运行时方法。根据这种划分方法，对页面生命周期的各阶段主要内容进行较详细的说明：

    1，启动阶段：设置页面基本属性，如 Request 和 Response。在此阶段，页面还将确定请求是回发请求还是新请求，并设置 IsPostBack 属性。
    2，预初始化阶段(启动阶段完成到触发PreInit事件)：设置页面一些最基本的特性，如加载个性化信息和主题、运行时Culture。
    3，初步化阶段(触发PreInit事件到触发Init事件)：根据页面的服务器标签及其属性设置，生成各个服务器控件的实例和给这些服务器控件的实例的属性进行赋值。（这里值得注意的是，服务器控件的大多数属性都是使用ViewState存储的，这时这些属性值将存入ViewState，但因为本阶段的赋值行为优先于ViewState的TrackViewState被调用，所以这些视图的值都将不会存入最终呈现的视图状态隐藏字段中，具体说明请参考我的关于视图状态的博客文章）
    4, 完成初始化阶段(触发Init事件到触发InitComplete事件)：这是一个典型的过渡阶段，该阶段的结束标志整个初始化阶段的完成。该阶段内只调用一个方法，及ViewState的TrackViewState方法，开启对视图状态更改的跟踪。（注意：在1、2、3阶段对ViewState的赋值都不会记录到视图状态变更，因此都不会保留视图状态，下次PostBack将丢失；而从4阶段到后续阶段中调用SaveViewState之前所有视图状态的赋值都会保留状态。）
    5，预加载阶段(触发InitComplete事件到触发PreLoad事件)：这里要加载的对象主要包括视图状态值、控件状态值以及回传数据（通过表单传递的所有值，实际上视图状态值和控件状态值本质上都是表单传值）。页面方法调用LoadViewState、LoadControlState、ProcessPostData，服务器控件对应调用LoadViewState和实现IPostBackDataHandler接口的LoadPostData方法，仅从上面两个方法名称中就可以判断出它们的功能。
    6，加载阶段(触发PreLoad事件到触发Load事件)：这个阶段是一个标志阶段，该阶段结束后将进入页面及各个控件的Load事件。
    7，完成加载阶段(触发Load事件到触发LoadComplete事件)：先调用Page的OnLoad方法，然后递归调用各个服务器控件的OnLoad方法；如果是PostBack，调用RaisePostBackEvent，即调用引起该Postback的控件的方法。这个一个重要的中间阶段，这时服务器控件和页面已经加载完毕（主要指各个属性都已经初始化赋值），可以按照需求对Page和这些控件进行重新逻辑处理，所以大多数的页面后台代码都是写在这个阶段并执行的。
    8，预呈现阶段(触发LoadComplete事件到触发PreRender事件)：这也是一个标志阶段，标志各个控件都即将通过调用PreRender方法。
    9，预呈现完成阶段(触发PreRender事件到触发PreRenderComplete事件)：先调用Page的PreRender方法，然后递归地调用各个服务器控件内的PreRender方法。在服务器控件编程中，PreRender是非常重要的方法，因为可在该方法内控件最终呈现的内容进行最后更改。
    10，保存状态阶段(触发PreRenderComplete事件到触发SaveStateComplete事件)：这个阶段用于页和所有控件保存视图状态和控件状态，调用SaveViewState(Private)保存视图状态，调用SaveControlState(Private)保存视图状态。
    11，呈现阶段(触发SaveStateComplete事件之后)：该阶段用于最终生成html代码，先调用Page的Render方法，然后递归调用服务器控件的Render，最终组合成完整的html代码。这个阶段是服务器控件完成任务的表现阶段，就像是蚂蚁们先出去找食物，最后回到蚁巢将食物拿出来一样，每个控件都拿出自己特定的“工作成果”。
    12，清理阶段：服务器控件调用完Render方法之后，就会调用Unload方法，该方法内部执行最后清理，如关闭控件特定数据库连接等等操作，所有服务器控件都清理完之后，再调用Page的Unload，同样也是用于执行最后清理工作，当然还可以做一些额外的项纪录操作历史等等自定义类的工作。最后，Page和服务器控件的实例都将被.NET的垃圾回收器回收，页面和控件在呈现阶段生成的文本将形成字符流响应给客户端。需要注意的是：在这个阶段，页及其控件已被呈现，不能再使用如Response.Write的呈现方法来对响应文本流做进一步修改了。

三，服务器控件生命周期详解

    所有服务器控件的基类都可以追溯到System.Web.UI.Control类，和页面一样，也先通过对象浏览器查看Control类的事件成员，截图如下：



    可以看到，与Page相比，Control只有Init、Load、PreRender及Unload这四个“常务”周期事件（DataBinding为特定条件事件，Disposed与Unload功能基本相似）。从执行角度上看，服务器控件的生命周期是“依附于”页面生命周期的，即服务器控件内的方法是被页面周期过程中调用才导致服务器控件周期的生长。

    一般的ASP.NET开发者对服务器控件的生命周期不太关注，也无需关注，只要会正确使用就OK了。而对于服务器控件开发者而言，对服务器控件的生命周期的知识是至关重要的，在开发特定控件时，既要保证正确又要保证效率，还要保证在对控件设置尽量简略的基础上提供尽量高的适用度。因此，在我看来，开发一个复杂而优秀的服务器控件的难度要比开发一个逻辑复杂度相近的ASPX页面要困难许多。

    本节将分阶段简单介绍服务器控件生命周期，因为服务器控件生命周期与页面生命周期是“互动的”，因此下面提到的某些方法和事件可能已经在页面生命周期介绍中就已经涉及：

    1，  初始化阶段：
        A， 根据ASPX页面上的设置生成该控件的实例，并给相应的属性进行赋值，所有服务器控件都完成初始化之后，页面将调用TrackViewState方法以最终视图状态的赋值。
       B， 如页面上<asp:ButtonID="aspbtn_TestPostBack" runat="server" Text="点击提交"/>的代码将导致生成System.Web.UI.WebControls.Button类的初始化，并设置属性ID=“aspbtn_TestPostBack”和属性Text=” 点击提交”。
       C， 该阶段完成之后，将触发Init事件。
       D， 可通过重写(override)OnInit方法或者给Init事件绑定方法来执行当初始化阶段完成后需要执行的代码。
   2，  加载阶段：
       A， 该阶段将加载视图状态、控件状态和回传数据，服务器控件根据这些数据重新给属性赋值。
       B， 如回传的视图状态值中包括Label1服务器控件的Text为”””text1”，那么在本阶段Label1控件的Text属性将被重新赋值为””text1”，并且因为页面的TrackViewState方法已经在初始化阶段被调用，所以这时Text属性的视图状态值将被添加到最终的视图状态输出字符流中。
       C， 这里需要注意的是：并不是所有控件的所有属性都是使用视图状态保存的，像TextBox的Text属性实现过程是这样的：获取PostBack回传的TextBox呈现的Input标签的value值，然后给Text赋值，这时Text中的视图状态ViewState[“Text”]会变成“dirty”，但在SaveViewState方法中将会调用this.ViewState.SetItemDirty("Text", false)来手动去除Text视图状态的“Dirty”标志。
       D， 该阶段完成之后，将触发Load事件。
       E，  可通过重写(override)OnLoad方法或者给Load事件绑定方法来执行当加载阶段完成后需要执行的代码。
   3，  处理回发事件RaisePostDataChangedEvent：
       A， 只有该服务器控件实现了IPostBackDataHandler接口，且本次请求为PostBack时才执行该方法。该接口用于当控件的关键属性发生变化时需要执行的代码，如TextBox控件的OnTextChanged和CheckBox控件的OnCheckedChanged。
       B， 执行过程是：如果控件状态因回发而更改，则该控件的LoadPostData()返回true；否则返回false。页面跟踪所有返回true的控件并在这些控件上调用RaisePostDataChangedEvent()。例如，当因为TextBox控件的OnTextChanged事件而触发的PostBack，那么该TextBox控件的LoadPostData()方法将返回true，页面调用TextBox控件的LoadPostData方法发现为true时就会调用TextBox控件的RaisePostDataChangedEvent方法。
   4，  处理回发事件RaisePostBackEvent：
       A， 这个方法与RaisePostIataChangedEvent类执行情况类似，都是用于请求为PostBack时，执行引起本次PostBack的控件对应的事件。
       B， 只有该服务器控件实现了IPostBackEventHandler接口，且本次请求为PostBack时才执行该方法。该接口用于由于对控件的某些操作导致Postback后需要执行的代码，最典型的就是Button控件的OnClick。
       C， 这里可能需要解释的就是如何找到这个引起PostBack的控件了。有两种情况，一种是像Button控件(默认属性设置)转化成类型为submit的input标签，本身就能引起PostBack不需要额外的方法；另一种是需要借助__doPostBack（你懂的）方法实现，需要传入__EVENTTARGET(控件ID)和__EVENTARGUMENT(事件参数)则两个参数。对于第二种情况，页面是很容易找到引起PostBack的控件的，只需要根据str = postData["__EVENTTARGET"]调用FindControl(str)就OK了；而对于第一种情况则稍微复杂一下，需要“曲折”地使用注册机制，通过调用Page.RegisterRequiresRaiseEvent(IPostBackEventHandler control)函数实现。例如Button控件引起的PostBack，Page会在ProcessPostData方法中对回传的字符串依次通过FindControl方法尝试找到控件，如果找到控件并且该控件实现了IPostBackEventHandler，则调用Page.RegisterRequiresRaiseEvent对该控件进行注册。
       D， 查找这个目标控件的顺序是，先查找Page.RegisterRequiresRaiseEvent注册的控件，如果有则将该控件确定为目标控件；如果没有，则通过__EVENTTARGET参数查找目标控件。
       E，  找到这个目标控件之后就简单了，只需要页面的完成加载阶段调用这个控件的RaisePostBackEvent方法就OK了。
   5，  预呈现阶段：
       A， 一般此阶段用于完成在控件保存视图状态和控件状态和最终呈现之前所需要的任何工作。
       B， 该阶段完成之后，将触发PreRender事件。
       C， 可通过重写(override)OnPreRender方法或者给PreRender事件绑定方法来执行当预呈现阶段完成后需要执行的代码。
   6，  保存状态阶段SaveViewState：
       A， 该阶段用于保存服务器控件内的所有视图状态和控件状态。
       B， 保存视图状态的“原则”是：所有被标志为“Dirty”的键/值才会加载到视图状态最终输出流中。
       C， 控件状态的保存与视图状态类似，但有一个最大地区别就是，控件状态不能被禁止，而视图状态可以，目的在于让服务器控件开发者更好地控制该控件的可靠性（不会因为页面开发者禁止了视图状态而使控件变的不可用）。
   7，  呈现阶段：
       A， 生成呈现给客户端的输出，可通过重写 Render()方法使其在输出流上自定义标记文本。
       B， 各个服务器控件将被“解析”为html代码，最终与整个ASPX页面组合成完整的HTML文本流，并返回给客户端。
    8，  清理阶段：
       A， 与页面生命周期的清理阶段类似，执行最后清理工作，如关闭控件特定数据库连接等等操作。
       B， 之后该服务器控件的实例将被垃圾回收器回收。



四，页面生命周期与服务器控件生命周期综合分析
    经过对ASP.NET的生命周期的较详细了解后，不得不承认，微软在ASP.NET上的设计是非常精妙的，从ASPX页面源代码经过页面周期、各个服务器控件的生命周期，最终转化为html代码。这些生命周期的各个阶段功能相对独立、明确，ASP.NET开发者可以通过在特定阶段添加相关代码，以达到特定的目的。下面将页面生命周期与服务器控件生命周期在一张图上(从MSDN中复制)综合展示：



    从上面的示图可以教完整地反映整个页面生命周期（控件的生命周期包含在页面周期之中）的执行流程，调用某些方法之后触发对应的生命周期事件，标志开始进入下一个生命周期阶段
————————————————
版权声明：本文为CSDN博主「NewClass」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/mlcactus/article/details/8564347













https://blog.csdn.net/mlcactus/article/details/8564347
https://www.cnblogs.com/xhwy/archive/2012/05/20/2510178.html