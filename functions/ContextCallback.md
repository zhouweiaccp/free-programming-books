使用同步上下文也可以实现相同的效果，WinFroms和WPF继承了SynchronizationContext，使同步上下文能够在UI线程或者Dispatcher线程上正确执行

System.Windows.Forms. WindowsFormsSynchronizationContext
System.Windows.Threading. DispatcherSynchronizationContext
调用方法如下：

复制代码
private void button_Click(object sender, EventArgs e)
{
           var context = SynchronizationContext.Current; //获取同步上下文
           Debug.Assert(context != null);
           ThreadPool.QueueUserWorkItem(BackgroudRun, context); 
}

private void BackgroudRun(object state)
{
    var context = state as SynchronizationContext; //传入的同步上下文
    Debug.Assert(context != null);
    SendOrPostCallback callback = o =>
                                      {
                                          label1.Text = "Hello SynchronizationContext";
                                      };
    context.Send(callback,null); //调用
}
复制代码
使用.net4.0的Task 可以简化成

复制代码
private void button_Click(object sender, EventArgs e)
{
            var  scheduler = TaskScheduler.FromCurrentSynchronizationContext(); // 创建一个SynchronizationContext 关联的 TaskScheduler
            Task.Factory.StartNew(() => label1.Text = "Hello TaskScheduler", CancellationToken.None,
                                  TaskCreationOptions.None, scheduler);
}
复制代码