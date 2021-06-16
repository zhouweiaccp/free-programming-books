




https://www.cnblogs.com/xm_cpppp/p/3612055.html
https://github.com/zhouweiaccp/Masuit.Tools/blob/260a9e0305ef6978c4e1e0954a96b709f11abc02/Masuit.Tools.Abstractions/Net/PartialDownloader.cs

1、首先我们要实现如下图的效果：                                                         
　　a、主线程A运行方法段1时创建子线程B

　　b、然后子线程B执行方法段2

　　c、执行完后通知主线程A执行方法段3



 

 

2、实现代码如下：                     
复制代码
        public Form1()
        {
            InitializeComponent();
        }

        public void Method1()
        {
            //给主线程取个名字
            if (Thread.CurrentThread.Name == null)
                Thread.CurrentThread.Name = "main";

            //获取主线程上下文
            asyncOperation = AsyncOperationManager.CreateOperation(null);

            //创建一个线程并执行方法2
            ThreadStart ts = new ThreadStart(Method2);
            Thread t = new Thread(ts);
            t.Name = "work";
            t.Start();
        }

        public void Method2()
        {
            MessageBox.Show("当前线程：" + Thread.CurrentThread.Name);

            //模拟干了一件3秒耗时的事情
            Thread.Sleep(3000);

            //通知主线程我事情干好了，你可以执行方法3了
            if (asyncOperation != null)
                asyncOperation.Post(new SendOrPostCallback(Method3), null);

            //结束上下文的生存期
            asyncOperation.OperationCompleted();
        }

        public void Method3(object data)
        {
            MessageBox.Show("当前线程：" + Thread.CurrentThread.Name);
        }

        private AsyncOperation asyncOperation;
        private void button1_Click(object sender, EventArgs e)
        {
            Method1();
        } 
复制代码
 

3、要点记录                        
1、AsyncOperation 一般通过 AsyncOperationManager 对象获取

asyncOperation = AsyncOperationManager.CreateOperation(null);
2、在System.Windows.Forms.Form的UI线程存在对应的上下文AsyncOperation，在Conosol控制台程序的主线程不存在上下文AsyncOperation

     给个例子一看就清楚了

复制代码
        static AsyncOperation asyncOperation;

        static void Main(string[] args)
        {
            Console.WriteLine("我是主线程：" + Thread.CurrentThread.ManagedThreadId);
            Method1();
            Console.ReadKey();
        }

        static void Method1()
        {

            //获取主线程上下文
            asyncOperation = AsyncOperationManager.CreateOperation(null);

            //创建一个线程
            ThreadStart ts = new ThreadStart(Method2);
            Thread t = new Thread(ts);
            t.Start();
        }

        static void Method2()
        {
            Console.WriteLine("我是子线程：" + Thread.CurrentThread.ManagedThreadId);

            //模拟干了一件3秒耗时的事情
            Thread.Sleep(3000);

            //通知主线程事情干好了，其实这里创建了一个新线程
            if (asyncOperation != null)
                asyncOperation.Post(new SendOrPostCallback(Method3), null);

            //结束上下文的生存期
            asyncOperation.OperationCompleted();
        }

        static void Method3(object data)
        {
            Console.WriteLine("我是上下文创建的线程：" + Thread.CurrentThread.ManagedThreadId);
        }
复制代码