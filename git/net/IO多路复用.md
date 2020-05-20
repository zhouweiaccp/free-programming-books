https://www.cnblogs.com/sheng-jie/p/how-much-you-know-about-the-io-models-demo.html

既然知道原因所在，咱们就来予以改造。适用异步方式来处理连接、接收和发送数据。

public static class NioServer
{
    private static ManualResetEvent _acceptEvent = new ManualResetEvent(true);
    private static ManualResetEvent _readEvent = new ManualResetEvent(true);
    public static void Start()
    {
        //1. 创建Tcp Socket对象
        var serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        // serverSocket.Blocking = false;//设置为非阻塞
        var ipEndpoint = new IPEndPoint(IPAddress.Loopback, 5001);
        //2. 绑定Ip端口
        serverSocket.Bind(ipEndpoint);
        //3. 开启监听，指定最大连接数
        serverSocket.Listen(10);
        Console.WriteLine($"服务端已启动({ipEndpoint})-等待连接...");

        while (true)
        {
            _acceptEvent.Reset();//重置信号量
            serverSocket.BeginAccept(OnClientConnected, serverSocket);
            _acceptEvent.WaitOne();//阻塞
        }
    }

    private static void OnClientConnected(IAsyncResult ar)
    {
        _acceptEvent.Set();//当有客户端连接进来后，则释放信号量
        var serverSocket = ar.AsyncState as Socket;
        Debug.Assert(serverSocket != null, nameof(serverSocket) + " != null");

        var clientSocket = serverSocket.EndAccept(ar);
        Console.WriteLine($"{clientSocket.RemoteEndPoint}-已连接");
        
        while (true)
        {
            _readEvent.Reset();//重置信号量
            var stateObj = new StateObject { ClientSocket = clientSocket };
            clientSocket.BeginReceive(stateObj.Buffer, 0, stateObj.Buffer.Length, SocketFlags.None, OnMessageReceived, stateObj);
            _readEvent.WaitOne();//阻塞等待
        }
    }

    private static void OnMessageReceived(IAsyncResult ar)
    {
        var state = ar.AsyncState as StateObject;
        Debug.Assert(state != null, nameof(state) + " != null");
        var receiveLength = state.ClientSocket.EndReceive(ar);

        if (receiveLength > 0)
        {
            var msg = Encoding.UTF8.GetString(state.Buffer, 0, receiveLength);
            Console.WriteLine($"{state.ClientSocket.RemoteEndPoint}-接收数据：{msg}");

            var sendBuffer = Encoding.UTF8.GetBytes($"received:{msg}");
            state.ClientSocket.BeginSend(sendBuffer, 0, sendBuffer.Length, SocketFlags.None,
                SendMessage, state.ClientSocket);
        }
    }

    private static void SendMessage(IAsyncResult ar)
    {
        var clientSocket = ar.AsyncState as Socket;
        Debug.Assert(clientSocket != null, nameof(clientSocket) + " != null");
        clientSocket.EndSend(ar);
        _readEvent.Set(); //发送完毕后，释放信号量
    }
}

public class StateObject
{
    // Client  socket.  
    public Socket ClientSocket = null;
    // Size of receive buffer.  
    public const int BufferSize = 1024;
    // Receive buffer.  
    public byte[] Buffer = new byte[BufferSize];
}