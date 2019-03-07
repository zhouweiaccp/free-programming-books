   /// <summary>  
        /// 获取当前使用的IP  
        /// </summary>  
        /// <returns></returns>  
        public static string GetLocalIP()  
        {  
            string result = RunApp("route", "print", true);  
            Match m = Regex.Match(result, @"0.0.0.0\s+0.0.0.0\s+(\d+.\d+.\d+.\d+)\s+(\d+.\d+.\d+.\d+)");  
            if (m.Success)  
            {  
                return m.Groups[2].Value;  
            }  
            else  
            {  
                try  
                {  
                    System.Net.Sockets.TcpClient c = new System.Net.Sockets.TcpClient();  
                    c.Connect("www.baidu.com", 80);  
                    string ip = ((System.Net.IPEndPoint)c.Client.LocalEndPoint).Address.ToString();  
                    c.Close();  
                    return ip;  
                }  
                catch (Exception)  
                {  
                    return null;  
                }  
            }  
        }  
  
  
        /// <summary>  
        /// 运行一个控制台程序并返回其输出参数。  
        /// </summary>  
        /// <param name="filename">程序名</param>  
        /// <param name="arguments">输入参数</param>  
        /// <returns></returns>  
        public static string RunApp(string filename, string arguments, bool recordLog)  
        {  
            try  
            {  
                if (recordLog)  
                {  
                    Trace.WriteLine(filename + " " + arguments);  
                }  
                Process proc = new Process();  
                proc.StartInfo.FileName = filename;  
                proc.StartInfo.CreateNoWindow = true;  
                proc.StartInfo.Arguments = arguments;  
                proc.StartInfo.RedirectStandardOutput = true;  
                proc.StartInfo.UseShellExecute = false;  
                proc.Start();  
  
                using (System.IO.StreamReader sr = new System.IO.StreamReader(proc.StandardOutput.BaseStream, Encoding.Default))  
                {  
                    string txt = sr.ReadToEnd();  
                    sr.Close();  
                    if (recordLog)  
                    {  
                        Trace.WriteLine(txt);  
                    }  
                    if (!proc.HasExited)  
                    {  
                        proc.Kill();  
                    }  
                    return txt;  
                }  
            }  
            catch (Exception ex)  
            {  
                Trace.WriteLine(ex);  
                return ex.Message;  
            }  
        }  

 NetworkInterface[] NetworkInterfaces = NetworkInterface.GetAllNetworkInterfaces();
                foreach (NetworkInterface NetworkIntf in NetworkInterfaces)
                {
                    IPInterfaceProperties IPInterfaceProperties = NetworkIntf.GetIPProperties();
                    UnicastIPAddressInformationCollection UnicastIPAddressInformationCollection = IPInterfaceProperties.UnicastAddresses;
                    foreach (UnicastIPAddressInformation UnicastIPAddressInformation in UnicastIPAddressInformationCollection)
                    {
                        if (UnicastIPAddressInformation.Address.AddressFamily == AddressFamily.InterNetwork)
                        {
                            logger.Warn(UnicastIPAddressInformation.Address.ToString());
                        }
                    }
                }
