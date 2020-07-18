

##  断点续传下载原理实现
需求背景  [https://www.cnblogs.com/peachyy/p/7482222.html]
动态创建的文件下载的时候希望浏览器显示下载进度
动态创建的文件希望能够分段下载
HTTP断点续传报文
要实现HTTP断点续传必须要简单了解以下几个报文。

Accept-Ranges 告诉客户端(浏览器..)服务器端支持断点续传 服务器端返回
Range 客户端告诉服务器端从指定的的位置/范围(这里值字节数)下载资源 客户端发出
Content-Range 服务器端告诉客户端响应的数据信息，在整个返回体中本部分的字节位置 服务器端返回
ETag 资源标识 非必须 服务器端返回
Last-Modified 资源最后一次更新的时间 非必须 服务器端返回
Range 的范围格式

表示0-499个字节范围：Range: bytes=0-499
表示最后500个字节范围：Range: bytes=-500
表示500字节开始到结束范围：Range: bytes=500-
表示第一个和最后一个字节：Range: bytes=0-0,-1
表示同时指定几个范围：Range: bytes=500-600,601-999
Content-Range 的数据格式

Content-Range: bytes 0-499/22036 ：表示返回0-499字节范围数据 资源一共22036个字节

原理

客户端发起请求 设置Range指定开始字节数或结束字节数 如果是从0开始也可以不用设置。
服务器端检查到客户端Range头 解析开始字节数以及结束字节数 并返回报文头 Accept-Ranges表示支持断点续传，Content-Range记录该次向客户端写入流的位置信息，然后再写入流到客户端。
服务端可以使用ETag Last-Modified 标记一下资源是否被修改。作一些验证工作，如果验证不通过则返回错误，非必须项。
java实现
复制代码
 OutputStream os=null;
    InputStream inputStream =null;
    File zipFile=null;
    try{
        long zipStart=System.currentTimeMillis();
        zipFile=createFile();//动态根据业务创建文件
        if(logger.isInfoEnabled()){
            logger.info(String.format("压缩ZIP 花费时间 %s(s) ",
        (System.currentTimeMillis()-zipStart)/1000));
        }
        if (zipFile.exists()) {
            long downloadStart=System.currentTimeMillis();
            inputStream= new BufferedInputStream(new FileInputStream(zipFile));
            response.reset();
            os=new BufferedOutputStream(response.getOutputStream());
            String userAgent = request.getHeader("USER-AGENT");
            String fileName=zipFile.getName();
            if (null != userAgent && -1 != userAgent.indexOf("MSIE")) {
                fileName = URLEncoder.encode(fileName, "UTF8");
            } else if (null != userAgent && -1 != userAgent.indexOf("Mozilla")) {
                fileName = new String(fileName.getBytes("utf-8"), "ISO-8859-1");
            }
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Content-Disposition", 
        "attachment;filename="+ fileName);
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            long pos = 0, fileSize=zipFile.length(),
    last=fileSize-1;
            response.setHeader("ETag",zipFile.getName().
         concat(Objects.toString(fileSize))
                    .concat("_").concat(Objects.toString(zipFile.lastModified())));
            response.setDateHeader("Last-Modified",zipFile.lastModified());
            response.setDateHeader("Expires",
            System.currentTimeMillis()+1000*60*60*24);
            if (null != request.getHeader("Range")) {
                response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
                try {
                    // 暂时只处理这2种range格式 1、RANGE: bytes=111- 2、Range: bytes=0-499
                    String numRang = request.getHeader("Range")
            .replaceAll("bytes=", "");
                    String[] strRange = numRang.split("-");
                    if (strRange.length == 2) {
                        pos = Long.parseLong(strRange[0].trim());
                        last = Long.parseLong(strRange[1].trim());
                    } else {
                        pos = Long.parseLong(numRang.replaceAll("-", "").trim());
                    }
                } catch (NumberFormatException e) {
                    logger.error(request.getHeader("Range") + " error");
                    pos = 0;
                }
            }
            long rangLength = last - pos + 1;
            String contentRange = new StringBuffer("bytes ").
            append(String.valueOf(pos)).
            append("-").append(last).append("/").
            append(String.valueOf(fileSize)).toString();
            response.setHeader("Content-Range", contentRange);
            response.addHeader("Content-Length",Objects.toString(rangLength));
            if(pos>0){
                inputStream.skip(pos);
            }
            byte[] buffer = new byte[1024*512];//每次以512KB 0.5MB的流量下载
            int length = 0,sendTotal=0;
            while (sendTotal < rangLength && length!=-1) {
                length = inputStream.read(buffer, 0,
        ((rangLength - sendTotal) <= buffer.length ?
                        ((int) (rangLength - sendTotal)) : buffer.length));
                sendTotal = sendTotal + length;
                os.write(buffer, 0, length);
            }
            if(os!=null){
                os.flush();
            }
            if(logger.isInfoEnabled()){
                logger.info(String.format("下载 花费时间 %s(s) ",
        (System.currentTimeMillis()-downloadStart)/1000));
            }
        }
    }catch (Exception e){
        if(StringUtils.endsWithIgnoreCase(e.getMessage(),"Broken pipe")){
            logger.error("用户取消下载");
        }
        logger.error(e.getMessage(),e);
    }finally {
        if(os!=null){
            try{
                os.close();
            }catch (Exception e){}
        }
        if(inputStream!=null){
            try{
                IOUtils.closeQuietly(inputStream);
            }catch (Exception e){}
        }
    }
}












   /// <summary>
        /// 设置Header 信息 和输出流位置
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="outputStream"> </param>
        /// <param name="fileName"></param>
        /// <param name="contentType"></param>
        /// <param name="pStart"></param>
        ///  <param name="pEnd"></param>
        protected virtual void SetStreamRange(Stream stream, Stream outputStream, string fileName, string contentType, out long pStart, out long pEnd)
        {
            long size = stream.Length;
            pStart = 0;
            pEnd = size - 1;
            long contentLength = size + HeaderSize;
            if (string.IsNullOrEmpty(Downloader.ZipGuid))//压缩下载不需要设置头
            {
                //HttpContext.Current.Response.ContentType = contentType; //设定输出文件类型
                var downName = WebsiteUtility.GetDownloadFileName(fileName);
                HttpContext.Current.Response.Headers.Add("Content-Disposition", "attachment; filename=\"" + downName + "\";");

                if (HttpContext.Current.Request.Headers["Range"].Count > 0)
                {
                    HttpContext.Current.Response.StatusCode = 206;
                    string strRange = HttpContext.Current.Request.Headers["Range"].ToString().Replace("bytes=", "");
                    if (strRange.IndexOf("-") < 0)
                    {
                        long.TryParse(strRange, out pStart); // 有start没end
                    }
                    else if (strRange.EndsWith("-"))  // 有start没end
                    {
                        long.TryParse(strRange.Replace("-", ""), out pStart);
                    }
                    else if (strRange.IndexOf("-") == 0) // 有end没start
                    {
                        long.TryParse(strRange.Replace("-", ""), out pEnd);
                    }
                    else if (strRange.IndexOf("-") > 0) // 有头有尾
                    {
                        // rang=0-1024   contentLength = 1024-0+1=1025;
                        long.TryParse(strRange.Split('-')[0], out pStart);
                        long.TryParse(strRange.Split('-')[1], out pEnd);
                    }
                    contentLength = pEnd - pStart + 1;
                    //contentLength += HeaderSize;
                }

                //设置下载文件名
                HttpContext.Current.Response.Headers.Add("Content-Length", contentLength.ToString());

                //Console.WriteLine("Content-Length:" + contentLength.ToString());

                if (pStart != 0 || HttpContext.Current.Request.Headers["Range"].Count > 0)
                {
                    string contentRangeValue = $"bytes {pStart}-{(pEnd)}/{size + HeaderSize}";
                    HttpContext.Current.Response.Headers.Add("Content-Range", contentRangeValue);

                    //Console.WriteLine("Content-Range:" + contentRangeValue);
                    if (HeaderSize > 0)
                    {
                        if (pStart > 0)
                        {
                            pStart = pStart - HeaderSize;
                        }
                        pEnd = pEnd - HeaderSize;
                    }
                    stream.Position = pStart;
                }
            }
        }
