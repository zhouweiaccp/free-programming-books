




## C#取本机Ip
```cs
 public  string GetLocalIP()
        {
            string result = RunApp("route", "print", true);
            System.Text.RegularExpressions.Match m = System.Text.RegularExpressions.Regex.Match(result, @"0.0.0.0\s+0.0.0.0\s+(\d+.\d+.\d+.\d+)\s+(\d+.\d+.\d+.\d+)");
            if (m.Success)
            {
                return m.Groups[2].Value;
            }
            else
            {
                try
                {
                    System.Net.Sockets.TcpClient c = new System.Net.Sockets.TcpClient();
                    string config = EDoc2.PageHelper.GetConfigurationSettingsValue("qc7018url", "");
                    Uri url = new Uri(config);
                    c.Connect(url.Host, 80);
                    string ip = ((System.Net.IPEndPoint)c.Client.LocalEndPoint).Address.ToString();
                    c.Close();
                    return ip;
                }
                catch (Exception ex)
                {
                    WriteLog(ex.ToString());
                    return "";
                }
            }
        }


        /// <summary>  
        /// 运行一个控制台程序并返回其输出参数。  
        /// </summary>  
        /// <param name="filename">程序名</param>  
        /// <param name="arguments">输入参数</param>  
        /// <returns></returns>  
        public   string RunApp(string filename, string arguments, bool recordLog)
        {
            try
            {

                System.Diagnostics.Process proc = new System.Diagnostics.Process();
                proc.StartInfo.FileName = filename;
                proc.StartInfo.CreateNoWindow = true;
                proc.StartInfo.Arguments = arguments;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.UseShellExecute = false;
                proc.Start();

                using (System.IO.StreamReader sr = new System.IO.StreamReader(proc.StandardOutput.BaseStream, System.Text.Encoding.Default))
                {
                    string txt = sr.ReadToEnd();
                    sr.Close();
                    //if (recordLog)
                    //{
                    //    Trace.WriteLine(txt);
                    //}
                    if (!proc.HasExited)
                    {
                        proc.Kill();
                    }
                    return txt;
                }
            }
            catch (Exception ex)
            {
                WriteLog(ex.ToString());
                return "";
            }
        }

```