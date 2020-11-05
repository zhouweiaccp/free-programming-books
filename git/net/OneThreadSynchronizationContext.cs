using System;
using System.Collections.Concurrent;
using System.Threading;

namespace ETModel
{
	public class OneThreadSynchronizationContext : SynchronizationContext
	{
		public static OneThreadSynchronizationContext Instance { get; } = new OneThreadSynchronizationContext();

		private readonly int mainThreadId = Thread.CurrentThread.ManagedThreadId;

		// 线程同步队列,发送接收socket回调都放到该队列,由poll线程统一执行
		private readonly ConcurrentQueue<Action> queue = new ConcurrentQueue<Action>();

		private Action a;

		public void Update()
		{
			while (true)
			{
				if (!this.queue.TryDequeue(out a))
				{
					return;
				}
				a();
			}
		}

		public override void Post(SendOrPostCallback callback, object state)
		{
			if (Thread.CurrentThread.ManagedThreadId == this.mainThreadId)
			{
				callback(state);
				return;
			}
			
			this.queue.Enqueue(() => { callback(state); });
		}
	}
}



// using System;https://github.com/egametang/ET) ET是一个开源的游戏客户端（基于unity3d）服务端双端框架，服务端是使用C# .net core开发的分布式游戏服务端，其特点是开发效率高，性能强
// using System.Threading;
// using System.Threading.Tasks;
// using ETModel;

// namespace Example2_2_2
// {
//     class Program
//     {
//         private static int loopCount = 0;
        
//         static void Main(string[] args)
//         {
//             SynchronizationContext.SetSynchronizationContext(OneThreadSynchronizationContext.Instance);

//             Console.WriteLine($"主线程: {Thread.CurrentThread.ManagedThreadId}");
            
//             Crontine();
            
//             while (true)
//             {
//                 OneThreadSynchronizationContext.Instance.Update();
                
//                 Thread.Sleep(1);
                
//                 ++loopCount;
//                 if (loopCount % 10000 == 0)
//                 {
//                     Console.WriteLine($"loop count: {loopCount}");
//                 }
//             }
//         }

//         private static async void Crontine()
//         {
//             await WaitTimeAsync(5000);
//             Console.WriteLine($"当前线程: {Thread.CurrentThread.ManagedThreadId}, WaitTimeAsync finsih loopCount的值是: {loopCount}");
//             await WaitTimeAsync(4000);
//             Console.WriteLine($"当前线程: {Thread.CurrentThread.ManagedThreadId}, WaitTimeAsync finsih loopCount的值是: {loopCount}");
//             await WaitTimeAsync(3000);
//             Console.WriteLine($"当前线程: {Thread.CurrentThread.ManagedThreadId}, WaitTimeAsync finsih loopCount的值是: {loopCount}");
//         }
        
//         private static Task WaitTimeAsync(int waitTime)
//         {
//             TaskCompletionSource<bool> tcs = new TaskCompletionSource<bool>();
//             Thread thread = new Thread(()=>WaitTime(waitTime, tcs));
//             thread.Start();
//             return tcs.Task;
//         }
        
//         /// <summary>
//         /// 在另外的线程等待
//         /// </summary>
//         private static void WaitTime(int waitTime, TaskCompletionSource<bool> tcs)
//         {
//             Thread.Sleep(waitTime);
//             Console.WriteLine($"SetResult线程: {Thread.CurrentThread.ManagedThreadId}");
//             tcs.SetResult(true);
//         }
//     }
// }