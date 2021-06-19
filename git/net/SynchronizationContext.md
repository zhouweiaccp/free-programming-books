

# link
- [奇妙的SynchronizationContext](https://www.cnblogs.com/Kevin-moon/archive/2009/01/16/1376812.html)
- [](https://devblogs.microsoft.com/dotnet/configureawait-faq/)
- [Understanding-the-SynchronizationContext](https://www.codeproject.com/Articles/5274751/Understanding-the-SynchronizationContext-in-NET-wi)
- [Durable](https://github.com/Azure/durabletask)Durable Task Framework allows users to write long running persistent workflows in C# using the async/await capabilities.
- [Durable](https://abhikmitra.github.io/blog/dotnet-app1/)
- []()



# ExecutionContext
注意: 本篇文章讲述的是在 .Net Framework 环境下的分析， 但是我相信这与 .Net Core 设计思想是一致，但在实现上一定优化了很多。

下面开始本次讲述：

ExecutionContext 实际上只是线程相关其他上下文的容器。

有些上下文起辅助作用
有些上下文对 .Net 执行模型至关重要
ExecutionContext 与周围环境的信息有关，这意味着，代码正在运行时，它存储了与 当前环境 或 “context” 有关的数据。
周围环境: 代码执行处，可以访问到的变量、方法、属性等等。
https://docs.microsoft.com/zh-cn/dotnet/api/system.threading.executioncontext?view=net-5.0

The details of ExecutionContext are very obscure, buried deep inside features like .NET Remoting and WCF. What is part of it is:
HostExecutionContext
IllogicalCallContext, a repository of thread specific data used by Remoting
LogicalContext, as above
SecurityContext
SynchronizationContext


# 介绍
 上一篇中已经讲了SynchronizationContext 的一些内容，现在让我们更加深入地去了解它！
     继上篇中的问题"在UI线程上对SynchronizationContext的使用，可以适用于其他线程呢？"
     OK，我们把它放置在非UI线程上，这是你用SynchronizationContext.Current的属性来获取，你会发现你得到的是null，这时候，你可能会说，既然它不存在，那么我自己创建一个SynchronizationContext对象，这样就没问题了吧！？可是，最后它并不会像UI线程中那样去工作。
    让我们看下面的例子：
复制代码
class Program
{
    private static SynchronizationContext mT1 = null;

    static void Main(string[] args)
    {
        // log the thread id
        int id = Thread.CurrentThread.ManagedThreadId;
        Console.WriteLine("Main thread is " + id);

        // create a sync context for this thread
        var context = new SynchronizationContext();
        // set this context for this thread.
        SynchronizationContext.SetSynchronizationContext(context);

        // create a thread, and pass it the main sync context.
        Thread t1 = new Thread(new ParameterizedThreadStart(Run1));
        t1.Start(SynchronizationContext.Current);
        Console.ReadLine();
    }

    static private void Run1(object state)
    {
        int id = Thread.CurrentThread.ManagedThreadId;
        Console.WriteLine("Run1 Thread ID: " + id);

        // grab  the sync context that main has set
        var context = state as SynchronizationContext;

        // call the sync context of main, expecting
        // the following code to run on the main thread
        // but it will not.
        context.Send(DoWork, null);

        while (true)
            Thread.Sleep(10000000);
    }

    static void DoWork(object state)
    {
        int id = Thread.CurrentThread.ManagedThreadId;
        Console.WriteLine("DoWork Thread ID:" + id);
    }
}
复制代码
输出的结果：
Main thread is 10
Run1 Thread ID: 11
DoWork Thread ID:11
     注意上面的输出结果，DoWork和Run1是运行在同一线程中的，SynchronizationContext并没有把DoWork带入到主线程中执行，为什么呢？！
我们可以先看SynchronizationContext的原码（SynchronizationContext原代码）:

namespace System.Threading
{
    using Microsoft.Win32.SafeHandles;
    using System.Security.Permissions;
    using System.Runtime.InteropServices;
    using System.Runtime.CompilerServices;
    using System.Runtime.ConstrainedExecution;
    using System.Reflection;

    internal struct SynchronizationContextSwitcher : IDisposable
    {
        internal SynchronizationContext savedSC;
        internal SynchronizationContext currSC;
        internal ExecutionContext _ec;

        public override bool Equals(Object obj)
        {
            if (obj == null || !(obj is SynchronizationContextSwitcher))
                return false;
            SynchronizationContextSwitcher sw = (SynchronizationContextSwitcher)obj;
            return (this.savedSC == sw.savedSC &&
                    this.currSC == sw.currSC && this._ec == sw._ec);
        }

        public override int GetHashCode()
        {
            return ToString().GetHashCode();
        }

        public static bool operator ==(SynchronizationContextSwitcher c1,
                                       SynchronizationContextSwitcher c2)
        {
            return c1.Equals(c2);
        }

        public static bool operator !=(SynchronizationContextSwitcher c1,
                                       SynchronizationContextSwitcher c2)
        {
            return !c1.Equals(c2);
        }

        void IDisposable.Dispose()
        {
            Undo();
        }

        internal bool UndoNoThrow()
        {
            if (_ec  == null)
            {
                return true;
            }

            try
            {
                Undo();
            }
            catch
            {
                return false;
            }
            return true;
        }

        public void Undo()
        {
            if (_ec  == null)
            {
                return;
            }

            ExecutionContext  executionContext =
              Thread.CurrentThread.GetExecutionContextNoCreate();
            if (_ec != executionContext)
            {
                throw new InvalidOperationException(Environment.GetResourceString(
                          "InvalidOperation_SwitcherCtxMismatch"));
            }
            if (currSC != _ec.SynchronizationContext)
            {
                throw new InvalidOperationException(Environment.GetResourceString(
                          "InvalidOperation_SwitcherCtxMismatch"));
            }
            BCLDebug.Assert(executionContext != null, " ExecutionContext can't be null");
            // restore the Saved Sync context as current
            executionContext.SynchronizationContext = savedSC;
            // can't reuse this anymore
            _ec = null;
        }
    }

    public delegate void SendOrPostCallback(Object state);

    [Flags]
    enum SynchronizationContextProperties
    {
        None = 0,
        RequireWaitNotification = 0x1
    };

    public class SynchronizationContext
    {
        SynchronizationContextProperties _props = SynchronizationContextProperties.None;

        public SynchronizationContext()
        {
        }

        // protected so that only the derived sync
        // context class can enable these flags
        protected void SetWaitNotificationRequired()
        {
            // Prepare the method so that it can be called
            // in a reliable fashion when a wait is needed.
            // This will obviously only make the Wait reliable
            // if the Wait method is itself reliable. The only thing
            // preparing the method here does is to ensure there
            // is no failure point before the method execution begins.

            RuntimeHelpers.PrepareDelegate(new WaitDelegate(this.Wait));
            _props |= SynchronizationContextProperties.RequireWaitNotification;
        }

        public bool IsWaitNotificationRequired()
        {
            return ((_props &
              SynchronizationContextProperties.RequireWaitNotification) != 0);
        }

        public virtual void Send(SendOrPostCallback d, Object state)
        {
            d(state);
        }

        public virtual void Post(SendOrPostCallback d, Object state)
        {
            ThreadPool.QueueUserWorkItem(new WaitCallback(d), state);
        }

        public virtual void OperationStarted()
        {
        }

        public virtual void OperationCompleted()
        {
        }

        // Method called when the CLR does a wait operation
        public virtual int Wait(IntPtr[] waitHandles,
                       bool waitAll, int millisecondsTimeout)
        {
            return WaitHelper(waitHandles, waitAll, millisecondsTimeout);
        }

        // Static helper to which the above method
        // can delegate to in order to get the default
        // COM behavior.
        protected static extern int WaitHelper(IntPtr[] waitHandles,
                         bool waitAll, int millisecondsTimeout);

        // set SynchronizationContext on the current thread
        public static void SetSynchronizationContext(SynchronizationContext syncContext)
        {
            SetSynchronizationContext(syncContext,
              Thread.CurrentThread.ExecutionContext.SynchronizationContext);
        }

        internal static SynchronizationContextSwitcher
          SetSynchronizationContext(SynchronizationContext syncContext,
          SynchronizationContext prevSyncContext)
        {
            // get current execution context
            ExecutionContext ec = Thread.CurrentThread.ExecutionContext;
            // create a switcher
            SynchronizationContextSwitcher scsw = new SynchronizationContextSwitcher();

            RuntimeHelpers.PrepareConstrainedRegions();
            try
            {
                // attach the switcher to the exec context
                scsw._ec = ec;
                // save the current sync context using the passed in value
                scsw.savedSC = prevSyncContext;
                // save the new sync context also
                scsw.currSC = syncContext;
                // update the current sync context to the new context
                ec.SynchronizationContext = syncContext;
            }
            catch
            {
                // Any exception means we just restore the old SyncCtx
                scsw.UndoNoThrow(); //No exception will be thrown in this Undo()
                throw;
            }
            // return switcher
            return scsw;
        }

        // Get the current SynchronizationContext on the current thread
        public static SynchronizationContext Current
        {
            get
            {
                ExecutionContext ec = Thread.CurrentThread.GetExecutionContextNoCreate();
                if (ec != null)
                    return ec.SynchronizationContext;
                return null;
            }
        }

        // helper to Clone this SynchronizationContext,
        public virtual SynchronizationContext CreateCopy()
        {
            // the CLR dummy has an empty clone function - no member data
            return new SynchronizationContext();
        }

        private static int InvokeWaitMethodHelper(SynchronizationContext syncContext,
            IntPtr[] waitHandles,
            bool waitAll,
            int millisecondsTimeout)
        {
            return syncContext.Wait(waitHandles, waitAll, millisecondsTimeout);
        }
    }
}
注意Send和Post的部分:
复制代码
public virtual void Send(SendOrPostCallback d, Object state)
{
    d(state);
}

public virtual void Post(SendOrPostCallback d, Object state)
{
    ThreadPool.QueueUserWorkItem(new WaitCallback(d), state);
}
复制代码
     Send就是简单在当前的线程上面去调用委托来实现，而Post是通过线程池来实现。
     这时候你也许会奇怪，为什么UI线程上，SynchronizationContext就发挥了不同的作用呢！其实在UI线程中使用的并不是SynchronizationContext这个类，而是WindowsFormsSynchronizationContext这个东东。

     它重写了Send和Post方法。至于它是如何重写实现的，这个我也不是很了解，也没有找到相关的文章，只是知道通过"消息泵"来实现的，但是细节就不清楚了，如果大家知道的话，可以告诉下我，我很想了解下！呵呵
     最后，我画了一副图，让我们更加清楚地了解SynchronizationContext在UI线程和一般线程之间的不同，