


## link
- [](https://github.com/dotnet/corefx/blob/master/src/System.Threading.Channels/tests/ChannelTests.cs)
- [system.threading.channels](https://docs.microsoft.com/en-us/dotnet/api/system.threading.channels?view=netcore-3.0) https://docs.microsoft.com/en-us/dotnet/api/system.threading.channels.boundedchannelfullmode?view=netcore-3.0
- [an-introduction-to-system-threading-channels](https://devblogs.microsoft.com/dotnet/an-introduction-to-system-threading-channels/)
- [DotNetCore.CAP.Processor](https://github.com/dotnetcore/CAP/blob/1bc1595a97a782742807a9d1bf82634d56771a61/src/DotNetCore.CAP/Processor/IDispatcher.Default.cs) 应用
- [](https://michaelscodingspot.com/c-job-queues-with-reactive-extensions-and-channels/) 测试生产 消费者队列性能
- []()
- []()
- []()
- []()
- []()
- []()
- []()

## 数据流块与通道
System.Threading.Tasks.Dataflow库封装了存储和处理，并且主要集中在流水线上。 相比之下，System.Threading.Tasks.Channels库主要专注于存储。 通道比Dataflow块快得多，但它们特定于生产者-消费者方案。 这意味着它们不支持您使用Dataflow块获得的某些控制流功能。

## 为什么要使用System.Threading.Channels？
您可以利用渠道在发布和订阅方案中使生产者与消费者脱钩。 生产者和消费者不仅可以通过并行工作来提高性能，而且如果其中一项任务开始超过其他任务，则可以创建更多的生产者或消费者。 换句话说，生产者-消费者模式有助于提高应用程序的吞吐量（一种度量，它表示单位时间内完成的工作量）。

## System.Threading.Channels
是.Net Core基础类库中实现的一个多线程相关的库，专门处理数据流相关的操作，用来在生产者和订阅者之间传递数据（不知道可不可以理解为线程间传递数据，我把它类比成了Go语言中的Channel），使用时需要通过NuGet安装。

这个库的前身是System.Threading.Tasks.Channels，来自实验性质的核心类库项目https://github.com/dotnet/corefxlab，但是在2017年9月就不再更新了，目前使用的话需要用到最新的System.Threading.Channels库，如果你也是第一次接触的话，就直接上手研究System.Threading.Channels就可以了。

Channel API操作基于Channel对象，其操作主要由ChannelReader和ChannelWriter两部分组成，由Channelt提供的工厂方法创建一个有容量限制（或者无限制、最大容量限制）的channel。这点类似于Go语言中的chan的容量，二者在这里有很多的类似的地方，也有不同的地方。

1.1. 和Go语言channel的一些比较
Go语言中的channel默认是没有容量的，在使用这个没有容量的channel时，生产者和消费者必须“流动”起来，否则将会阻塞，也就是当生产者写入channel一个数据时，必须同时有一个接收者接收，否则写入操作会停止，等待有一个消费者取走channel中的数据，写入操作才会继续。

在System.Threading.Channels库中，没有类似Go语言的默认容量的机制，需要按需调用不同的Channel对象：

public static Channel<T> CreateBounded<T>(int capacity); ：可以创建一个带有容量限制的Channel实例对象。

public static Channel<T> CreateBounded<T>(BoundedChannelOptions options) ：创建一个自定义配置的Channel实例对象，可配置容量、以及在接收到新数据时的操作模式等等：

BoundedChannelFullMode.Wait：等待当前写入完成

BoundedChannelFullMode.DropNewest：删除并忽略管道中写入的最新的数据

BoundedChannelFullMode.DropOldest：删除并忽略管道中最旧的数据

BoundedChannelFullMode.DropWrite：删除当前正在写的数据，以写入管道中的新数据

public static Channel<T> CreateUnbounded<T>(); ：创建一个没有容量限制的Channel实例对象，在实际使用时应当谨慎使用该创建方式，因为可能会发生OutOfMemoryException。

public static Channel<T> CreateUnbounded<T>(UnboundedChannelOptions options)：创建一个自定义配置的没有容量限制的Channel实例对象。该配置选项因为没有容量限制所以不会有写入等待操作模式，只有默认的一些配置：

public bool SingleWriter { get; set; }：是否需要一个一个读

public bool SingleReader { get; set; }：是否需要一个一个写

public bool AllowSynchronousContinuations { get; set; }：是否需要异步连续操作（我个人理解为异步操作时同时进行读写）

Go语言的channel机制和System.Threading.Channels的不同之处有两个：

Go语言没有无限容量的channel，而且就我个人的想法而言，无限容量并不“无限”，因为内存是有限的。

System.Threading.Channels没有单向的channel类型。在Go中可以创建“只读”或者“只写”的channel，但是System.Threading.Channels中没有提供这种操作。

1.2. 生产者、消费者需要的方法
生产者需要使用的一些方法：TryWrite/WriteAsync/WaitToWriteAsync/Complete 消费者需要使用的一些方法：TryRead/ReadAsync/WaitToReadAsync/Completion

方法介绍：

TryRead/TryWrite：尝试使用同步方式读取或写入一项数据，返回读取或者写入是否成功。TryRead同时会以out的形式返回读取到的数据。

ReadAsync/WriteAsync：使用异步方式写入或者读取一项数据。

TryComplete/Completion：可以将channel标记为完成状态，这样就不会写入多余的错误数据，如果从已完成状态的channel中ReadAsync时会抛出异常，所以在不需要异步读取时建议经常使用TryRead。

WaitToReadAsync/WaitToWriteAsync：在尝试读取或者写入数据之前，调用该方法可获得一个Task<bool>表示读取或者写入操作能否进行。


## code
```C#
class Program
    {
        static async Task Main(string[] args)
        {
            await SingleProducerSingleConsumer();
            Console.ReadKey();
        }
        public static async Task SingleProducerSingleConsumer()
        {
            var channel = Channel.CreateUnbounded<int>();
            var reader = channel.Reader;
            for(int i = 0; i < 10; i++)
            {
                await channel.Writer.WriteAsync(i + 1);
            }           
            while (await reader.WaitToReadAsync())
            {
                if (reader.TryRead(out var number))
                {
                    Console.WriteLine(number);
                }
            }          
        }
    }
```

## Channels消费者队列
```C#
// Copyright (c) .NET Core Community. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
//https://github.com/dotnetcore/CAP/blob/1bc1595a97a782742807a9d1bf82634d56771a61/src/DotNetCore.CAP/Processor/IDispatcher.Default.cs
using System;
using System.Linq;
using System.Threading;
using System.Threading.Channels;
using System.Threading.Tasks;
using DotNetCore.CAP.Internal;
using DotNetCore.CAP.Messages;
using DotNetCore.CAP.Persistence;
using DotNetCore.CAP.Transport;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace DotNetCore.CAP.Processor
{
    public class Dispatcher : IDispatcher, IDisposable
    {
        private readonly CancellationTokenSource _cts = new CancellationTokenSource();
        private readonly IMessageSender _sender;
        private readonly ISubscribeDispatcher _executor;
        private readonly ILogger<Dispatcher> _logger;

        private readonly Channel<MediumMessage> _publishedChannel;
        private readonly Channel<(MediumMessage, ConsumerExecutorDescriptor)> _receivedChannel;

        public Dispatcher(ILogger<Dispatcher> logger,
            IMessageSender sender,
            IOptions<CapOptions> options,
            ISubscribeDispatcher executor)
        {
            _logger = logger;
            _sender = sender;
            _executor = executor;

            _publishedChannel = Channel.CreateUnbounded<MediumMessage>(new UnboundedChannelOptions() { SingleReader = false, SingleWriter = true });
            _receivedChannel = Channel.CreateUnbounded<(MediumMessage, ConsumerExecutorDescriptor)>();

            Task.WhenAll(Enumerable.Range(0, options.Value.ProducerThreadCount)
                .Select(_ => Task.Factory.StartNew(Sending, _cts.Token, TaskCreationOptions.LongRunning, TaskScheduler.Default)).ToArray());

            Task.WhenAll(Enumerable.Range(0, options.Value.ConsumerThreadCount)
                .Select(_ => Task.Factory.StartNew(Processing, _cts.Token, TaskCreationOptions.LongRunning, TaskScheduler.Default)).ToArray());
        }

        public void EnqueueToPublish(MediumMessage message)
        {
            _publishedChannel.Writer.TryWrite(message);
        }

        public void EnqueueToExecute(MediumMessage message, ConsumerExecutorDescriptor descriptor)
        {
            _receivedChannel.Writer.TryWrite((message, descriptor));
        }

        public void Dispose()
        {
            _cts.Cancel();
        }

        private async Task Sending()
        {
            try
            {
                while (await _publishedChannel.Reader.WaitToReadAsync(_cts.Token))
                {
                    while (_publishedChannel.Reader.TryRead(out var message))
                    {
                        try
                        {
                            var result = await _sender.SendAsync(message);
                            if (!result.Succeeded)
                            {
                                _logger.MessagePublishException(message.Origin.GetId(), result.ToString(),
                                    result.Exception);
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex,
                                $"An exception occurred when sending a message to the MQ. Id:{message.DbId}");
                        }
                    }
                }
            }
            catch (OperationCanceledException)
            {
                // expected
            }
        }

        private async Task Processing()
        {
            try
            {
                while (await _receivedChannel.Reader.WaitToReadAsync(_cts.Token))
                {
                    while (_receivedChannel.Reader.TryRead(out var message))
                    {
                        try
                        {
                            await _executor.DispatchAsync(message.Item1, message.Item2, _cts.Token);
                        }
                        catch (Exception e)
                        {
                            _logger.LogError(e,
                                $"An exception occurred when invoke subscriber. MessageId:{message.Item1.DbId}");
                        }
                    }
                }
            }
            catch (OperationCanceledException)
            {
                // expected
            }
        }
    }
}

```