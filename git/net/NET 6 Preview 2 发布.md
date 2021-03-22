https://www.cnblogs.com/hez2010/p/dotnet-6-preview-2.html
在 2021 年 3 月 11 日， .NET 6 Preview 2 发布，这次的改进主要涉及到 MAUI、新的基础库和运行时、JIT 改进。

.NET 6 正式版将会在 2021 年 11 月发布，支持 Windows、macOS、Linux、Android 和 iOS 等系统以及 x86、x86_64、ARM 和 ARM64 架构。另外，.NET 6 是 LTS 版本，将提供长达至少三年的支持。

那么一起来看看都有哪些内容吧。
主题：改进内部循环性能#

过去的几个 .NET 版本针对提升吞吐量、减少内存消耗等性能方面做了很多工作。而在 .NET 6 将会针对内部循环性能做出改进：不仅仅追求在应用和服务上做到最佳的性能，还要追求在应用模型、工具链和工作流程上的最佳性能。

其中一些工作看起来与过去的传统吞吐量优化工作非常相似，但实际上这里不关注稳态性能，而是关注运行时、应用模型、命令行、msbuild 等的启动性能，以及工具的端到端性能（特别是对于较小的解决方案）。

这种优化所涉及的思维方式通常与针对稳态吞吐量进行优化时所使用的思维方式大不相同。对于稳态工作，您可能会专注于缓存将来可以重用的值，但是对于启动性能而言，通常您将注意力集中在只能被调用一次的操作上，而第一次调用的成本很重要。

但是，这里涉及的工作确实与许多其他性能工作一样，都有一个典型的测量-分析-修复循环：分析要优化的应用程序的相关区域，分析结果数据以查找最主要的原因和瓶颈，然后为它们提出解决方案，然后重新开始寻找下一个有影响力的项目的过程。

我们仍然处于 .NET 6 开发周期的初期，但是我们已经成功地削减了开发人员内部循环所涉及的关键领域的开销，重点关注各种 dotnet 命令，例如 new，build 和 run。

目前已包含的改进例如：

    避免工具出现意料之外的 JIT：https://github.com/dotnet/installer/pull/9635
    避免未启用日志时产生日志相关的昂贵开销：https://github.com/dotnet/aspnetcore/pull/27956
    优化 MSBuild：https://github.com/dotnet/msbuild/pull/6151
    使用代码生成器替换原 Razor 编译器以加快编译速度：https://github.com/dotnet/sdk/pull/15756
    优化访问文件的方式以减少触发反病毒软件的扫描：https://github.com/dotnet/runtime/pull/48774

当然，最佳性能优化之一是避免完成全部的工作，这是 .NET 6 主题另一半的重点：.NET 热重载。通过允许在运行应用程序时甚至在未连接调试器的情况下对代码进行编辑，热重载将在所有受支持的操作系统和硬件平台上提高开发人员的生产率。开发人员修改代码后不需要重新编译和启动程序，更改将立即生效，如此可以跳过整个更改-构建-运行周期。此特性有望从根本上改善 .NET 开发人员编写应用和服务的方式。

.NET 6 编译速度改进

上图展示了 .NET 5 和 .NET 6 Preview 2 的 razor 编译时间对比。
主题：.NET 拥有优秀的客户端开发体验#

.NET 6 最令人兴奋的部分之一是移动开发，目前作为单独的Xamarin 产品提供。随着时间的流逝，我们一直在使 Xamarin 更类似于主线 .NET。现在是时候为 .NET 提供完全统一的移动产品了。使用 .NET 6，iOS，Android 和 macOS 开发将集成到 .NET SDK 中，并使用 .NET 库。在过去的两年中，我们一直在努力将 Mono 集成到 .NET 中，因此开发人员可以利用这两种运行时的优势，而不必针对不同的 .NET 版本，也不必担心兼容性问题。在 .NET 5 中，我们将 Blazor WebAssembly 移了过来，并在 Xamarin 中使用了相同的模型。.NET 6 是这种统一努力的最高潮，涵盖了主题的关键部分：Xamarin 开发人员可以升级到现有应用程序并使用最新的 .NET SDK。

现在，您所有的 .NET 应用程序都将在相同的库上运行，我们希望增加在 PC 和移动平台上共享的代码量。Xamarin 的跨平台 UI 框架 Xamarin.Forms 正在演变为 .NET MAUI，使您可以使用相同的代码库轻松编写适用于 iOS，Android，Windows 和 macOS 的应用程序。.NET MAUI 作为 .NET 6 的一部分提供，同时还进行了一系列性能和工具改进，例如 .NET/C# 热重载、在跨不同平台共享更多的资源和代码，以及具有一组更灵活的 UI 控件的更好的页面呈现性能。

.NET MAUI 不仅适用于客户端应用程序开发人员。得益于重构的控件集以及可以在 .NET 6 库上运行的功能，您现有的 Blazor 应用程序可以通过 .NET MAUI 在 Windows 和 macOS 上原生运行。您将能够与 Blazor 代码库无缝结合原生控件和功能，包括特定于平台的功能。

此主题的最后一部分是关于打包，部署和发布您的跨平台客户端应用程序。由于开发应用程序的开发人员/目标平台/方式太多，因此每天结束时您必须分发许多不同的应用程序包。尤其是对于 Blazor 桌面，我们希望使体验尽可能无缝。我们正在研究改善本地和云中发行和版本控制的策略。

总结一下，在 .NET 6，你将能够：

    用 .NET 库构建 iOS、Android 和 macOS 应用
    借助 .NET MAUI 使用相同的代码创建 iOS、Android、Windows 和 macOS 客户端应用
    在不同平台之间共享代码和资源
    在 macOS 和 Windows 上原生运行 Blazor 应用
    轻松打包和分发你的程序

MAUI 的 GitHub 仓库：http://github.com/dotnet/maui
MAUI 更新#

MAUI 的示例程序已经针对 .NET 6 Preview 2 更新：https://github.com/dotnet/net6-mobile-samples ，你可以直接使用 dotnet 的命令行构建和启动应用。
Mac Catalyst#

现在可以添加如下代码到项目属性中构建 macOS 的桌面应用：

Copy
<TargetFrameworks>net6.0-android;net6.0-ios</TargetFrameworks>
<TargetFrameworks Condition=" '$(OS)' != 'Windows_NT' ">$(TargetFrameworks);net6.0-maccatalyst</TargetFrameworks>

单个多平台应用项目#

.NET MAUI 的单个项目体验已经启用，你可以通过一个项目文件同时适配 Android、iOS 和 macOS；对于 Windows 的支持将会取决于 WinUI 3，因此这部分在未来会加入。

VS Solution

上图展示了单个项目中包含多个平台的开发体验。
共享字体、图片和应用图标#

字体和图片也可以放到你的项目中的同一个位置，.NET MAUI 将允许你在所有平台上访问它们，例如：

Copy
<ItemGroup>
    <SharedImage Include="appicon.svg" ForegroundFile="appiconfg.svg" IsAppIcon="true" />
    <SharedFont Include="Resources\Fonts\ionicons.ttf" />
 </ItemGroup>

除了指定特定文件之外，还支持使用 wild-card 按照路径匹配所有的文件作为共享图片或者字体：

Copy
<ItemGroup>
    <SharedImage Include="appicon.svg" ForegroundFile="appiconfg.svg" IsAppIcon="true" />
    <SharedImage Include="Resources\Images*" />
    <SharedFont Include="Resources\Fonts*" />
</ItemGroup>

MAUI 应用使用 HostBuilder 启动程序#

利用类似 ASP.NET Core 配置的体验配置 MAUI 程序，并支持依赖注入。例如：

Copy
public class Application : MauiApp
{
    public override IAppHostBuilder CreateBuilder() => 
        base.CreateBuilder()
            .RegisterCompatibilityRenderers()
            .ConfigureServices((ctx, services) =>
            {
                services.AddTransient<MainPage>();
                services.AddTransient<IWindow, MainWindow>();
            })
            .ConfigureFonts((hostingContext, fonts) =>
            {
                fonts.AddFont("ionicons.ttf", "IonIcons");
            });

    public override IWindow CreateWindow(IActivationState state)
    {
        Microsoft.Maui.Controls.Compatibility.Forms.Init(state);
        return Services.GetService<IWindow>();
    }
}

新的控件处理器#

.NET MAUI 引入了全新的控件处理机制，Preview 2 中包含第一组利用这些机制的控件：Button、Label、Entry、Slider 和 Switch。如果想要加速实现其他控件，也欢迎社区 PR，具体可见：https://github.com/dotnet/maui/wiki/Handler-Property-PR-Guidelines 。

.NET MAUI 的示例程序现在从同一个项目运行在 macOS、iOS 和 Android 上，以下是运行效果：

macOS：

macOS

iOS：

iOS

Android：

Android
移动 SDK 更新#
Android#

    将默认库设置为 Android X

iOS#

    Windows 上的开发者可以使用远程 iOS 模拟器
    Windows 上的开发者可以连接到远程的 macOS 上构建应用
    AOT 已经被添加和启用以支持部署和分发 iOS 应用

.NET 库更新#

.NET 的库在 Preview 2 中也有不少更新。
System.Text.Json 忽略循环引用#

System.Text.Json 现在支持忽略循环引用了，对于循环引用，可以不再抛出异常，而是像 Newtonsoft.Json 那样简单的设置成 null：

Copy
class Node
{
    public string Description { get; set; }
    public object Next { get; set; }
}

void Test()
{
    var node = new Node { Description = "Node 1" };
    node.Next = node;

    var opts = new JsonSerializerOptions { ReferenceHandler = ReferenceHandler.IgnoreCycles };

    string json = JsonSerializer.Serialize(node, opts);
    Console.WriteLine(json); // 输出 {"Description":"Node 1","Next":null}
}

优先队列 PriorityQueue#

.NET 6 Preview 2 加入了新的优先队列： System.Collections.Generic.PriorityQueue<TElement, TPriority>。

Copy
// 创建一个 int 作为优先级的 string 队列
var pq = new PriorityQueue<string, int>();

// 各种元素入队
pq.Enqueue("A", 3);
pq.Enqueue("B", 1);
pq.Enqueue("C", 2);
pq.Enqueue("D", 3);

pq.Dequeue(); // 返回 "B"
pq.Dequeue(); // 返回 "C"
pq.Dequeue(); // 返回 "A" 或者 "D"

改进的数值格式解析#

对于标准数值格式，我们改进了其解析器，尤其是针对 .ToString 和 .TryFormat 的改进。精度大于小数点后 99 位时的结果现在已被改进，并且还提供了对尾部 0 的更好支持：

    32.ToString("C100")：
        .NET 6：32.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
        .NET 5：存在 99 位精度的限制
    32.ToString("H99") 和 32.ToString("H100")：
        .NET 6：抛出 FormatException
        .NET 5：H 是一个无效的格式修饰，但是没有抛出异常而是返回了错误结果
    double.Parse("9007199254740997.0")：
        .NET 6：9007199254740996
        .NET 5：9007199254740998

SignalR 的可空类型标注#

SingleR 现在已经完成了可空类型的标注。
运行时更新#

.NET 6 Preview 2 在运行时上也有不少改进。
框架程序集使用 Crossgen2 预编译#

所有的 .NET 库现在已经使用 crossgen 2 进行预编译，目前只限于 .NET 的基础库，对于其他的库比如 ASP.NET Core 和 Windows Desktop，则会在后续的预览版本逐渐迁移到 crossgen 2。

Crossgen 2 本身并不是关注于性能改善的，而是用于启用新的性能特性（如 PGO）。不过 crossgen 2 带来了一些硬盘占用空间的改进：

Copy
Size [MB] FullName
--------- --------
64.22     C:Program FilesdotnetsharedMicrosoft.NETCore.App5.0.3
63.31     C:Program FilesdotnetsharedMicrosoft.NETCore.App6.0.0-preview.1.21102.12
63.00     C:Program FilesdotnetsharedMicrosoft.NETCore.App6.0.0-preview.2.21118.6

PGO#

.NET 6 Preview 2 添加了以下改进：

    Allow CSE & hoisting of vtable lookups for the indirections — dotnet/runtime #47808
    Block counts in tiered compilation — dotnet/runtime #13672
    Allow Inlinee profile scale-up — dotnet/runtime #48280
    Efficient profiling scheme (e.g., spanning tree with efficient edge instrumentation) — dotnet/runtime #46882, dotnet/runtime #47509, dotnet/runtime #47476, dotnet/runtime #47072, dotnet/runtime #47597, dotnet/runtime #47723, dotnet/runtime #47876, dotnet/runtime #47959

JIT 改进#

.NET 6 Preview 2 包含以下针对 JIT 的改进：

    Not aligning cloned loops — dotnet/runtime #48090
    MultiplyHigh intrinsics (smulh/umulh) — dotnet/runtime #47362

这些改进的结果分析可以在这里查看：

    2021 年 1 月 26 日：https://github.com/dotnet/runtime/issues/43227#issuecomment-767967603
    2021 年 2 月 3 日：https://github.com/dotnet/runtime/issues/43227#issuecomment-772914110

另外，对 ARM64 的优化也在不断和 ARM 工程师一起进行中。
结语#

以上就是 .NET 6 Preview 2 中的改进内容了。

.NET 6 的功能改进将会在 7 月之前全部完成，之后就会专注于质量上的改进了。
