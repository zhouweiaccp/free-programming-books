

class Program
    {
        static void Main(string[] args)
        {
            //注意：ManualResetEvent可以对所有进行等待的线程进行统一控制
 
            //true-初始状态为发出信号；false-初始状态为未发出信号
            ManualResetEvent mre = new ManualResetEvent(false);
            //线程池开启10个线程
            for (int i = 0; i < 10; i++)
            {
                int k = i;
                
                ThreadPool.QueueUserWorkItem(t =>
                {
                    Console.WriteLine($"这是第{k+1}个线程，线程ID为{Thread.CurrentThread.ManagedThreadId}");
                    //等待信号，没有信号的话不会执行后面的语句,因为初始状态是false，所以后面的语句暂时不会执行
                    mre.WaitOne();
                    Console.WriteLine($"第{k+1}个线程获得信号，线程ID为{Thread.CurrentThread.ManagedThreadId}");
                });
            }
            Thread.Sleep(5000);
            Console.WriteLine("\r\n 5秒后发出信号... \r\n");
            //Set()方法：释放信号，所有等待信号的线程都将获得信号，开始执行WaitOne()后面的语句
            mre.Set();
            Console.ReadKey();
        }
	}