// 该队列的思想是：当每次数据入队时，队列内部会调用DataAdded（）判断是否数据项已经开始被处理，如果已经开始处理则数据入到内部队列后直接返回否则开启消费者线程处理。队列内部的消费者线程(线程池)（Task内部使用线程池实现，这里就当做线程池吧）会采用采用递归的方式处理数据，也就是当前数据处理完成后再将另外一个数据放到线程池去处理，这样就形成一个处理环而且保证了每条数据都有序的进行处理。由于ConcurrentQueue的IsEmpty只是当前内存的一个快照状态，可能当前时刻为空下一个时候不为空， 所以还需要一个守护线程process_Thread定时监视队列内部的消费者线程（线程池）是否正在处理数据，否则会造成消费者线程已经判断队列为空而数据已经到达只是还没插入队列此时数据可能永远得不到处理。
//https://www.cnblogs.com/zw369/p/4021135.html
// 适用的场景：

//   1.适合多个生产者一个消费者的情景（当前如果需要多个消费者可以使用多个单独线程来实现）。

//   2.适合处理数据速度较快的情景而对于文件写入等IO操作不适合，因为线程池内部都是后台线程，当进程关闭时线程会同时关闭线程这时文件可能还没写入到磁盘。

//   3.适合作为流水线处理模型的基础数据结构，队列之间通过各自的事件处理函数进行通信（后续会专门撰写文章介绍关于流水线模型的应用）。

//   注：内部的ConcurrentQueue队列还可以使用阻塞队列(BlockingCollection)来替代，虽然使用阻塞队列更简单但是内部的消费者线程比较适合使用单独的线程不适合使用线程池，而且阻塞队列为空时会阻塞消费者线程，当然阻塞线程池内的线程也没什么影响只是不推荐这么做，而且阻塞的队列的性能也没有ConcurrentQueue的性能高。

public class AsynQueue<T>
{
    //队列是否正在处理数据
    private int isProcessing;
    //有线程正在处理数据
    private const int Processing = 1;
    //没有线程处理数据
    private const int UnProcessing = 0;
    //队列是否可用
    private volatile bool enabled = true;
    private Task currentTask;
    public event Action<T> ProcessItemFunction;
    public event EventHandler<EventArgs<Exception>> ProcessException;
    private ConcurrentQueue<T> queue;

    public AsynQueue()
    {
        queue = new ConcurrentQueue<T>();
        Start();
    }

    public int Count
    {
        get
        {
            return queue.Count;
        }
    }

    private void Start()
    {
        Thread process_Thread = new Thread(PorcessItem);
        process_Thread.IsBackground = true;
        process_Thread.Start();
    }

    public void Enqueue(T items)
    {
        if (items == null)
        {
            throw new ArgumentException("items");
        }

        queue.Enqueue(items);
        DataAdded();
    }

    //数据添加完成后通知消费者线程处理
    private void DataAdded()
    {
        if (enabled)
        {
            if (!IsProcessingItem())
            {
                currentTask = Task.Factory.StartNew(ProcessItemLoop);
            }
        }
    }

    //判断是否队列有线程正在处理 
    private bool IsProcessingItem()
    {
        return !(Interlocked.CompareExchange(ref isProcessing, Processing, UnProcessing) == 0);
    }

    private void ProcessItemLoop()
    {

        if (!enabled && queue.IsEmpty)
        {
            Interlocked.Exchange(ref isProcessing, 0);
            return;
        }
        //处理的线程数 是否小于当前最大任务数
        //if (Thread.VolatileRead(ref runingCore) <= this.MaxTaskCount)
        //{
        T publishFrame;

        if (queue.TryDequeue(out publishFrame))
        {

            try
            {
                ProcessItemFunction(publishFrame);
            }
            catch (Exception ex)
            {
                OnProcessException(ex);
            }
        }

        if (enabled && !queue.IsEmpty)
        {
            currentTask = Task.Factory.StartNew(ProcessItemLoop);
        }
        else
        {
            Interlocked.Exchange(ref isProcessing, UnProcessing);
        }
    }

    /// <summary>
    ///定时处理线程调用函数  
    ///主要是监视入队的时候线程 没有来的及处理的情况
    /// </summary>
    private void PorcessItem(object state)
    {
        int sleepCount = 0;
        int sleepTime = 1000;
        while (enabled)
        {
            //如果队列为空则根据循环的次数确定睡眠的时间
            if (queue.IsEmpty)
            {
                if (sleepCount == 0)
                {
                    sleepTime = 1000;
                }
                else if (sleepCount <= 3)
                {
                    sleepTime = 1000 * 3;
                }
                else
                {
                    sleepTime = 1000 * 50;
                }
                sleepCount++;
                Thread.Sleep(sleepTime);
            }
            else
            {
                //判断是否队列有线程正在处理 
                if (enabled && Interlocked.CompareExchange(ref isProcessing, Processing, UnProcessing) == 0)
                {
                    if (!queue.IsEmpty)
                    {
                        currentTask = Task.Factory.StartNew(ProcessItemLoop);
                    }
                    else
                    {
                        Interlocked.Exchange(ref isProcessing, 0);
                    }
                    sleepCount = 0;
                    sleepTime = 1000;
                }
            }
        }
    }

    public void Flsuh()
    {
        Stop();

        if (currentTask != null)
        {
            currentTask.Wait();
        }

        while (!queue.IsEmpty)
        {
            try
            {
                T publishFrame;
                if (queue.TryDequeue(out publishFrame))
                {
                    ProcessItemFunction(publishFrame);
                }
            }
            catch (Exception ex)
            {
                OnProcessException(ex);
            }
        }
        currentTask = null;
    }

    public void Stop()
    {
        this.enabled = false;
    }

    private void OnProcessException(System.Exception ex)
    {
        var tempException = ProcessException;
        Interlocked.CompareExchange(ref ProcessException, null, null);

        if (tempException != null)
        {
            ProcessException(ex, new EventArgs<Exception>(ex));
        }
    }
}

[Serializable]
public class EventArgs<T> : System.EventArgs
{
    public T Argument;

    public EventArgs() : this(default(T))
    {
    }

    public EventArgs(T argument)
    {
        Argument = argument;
    }
}