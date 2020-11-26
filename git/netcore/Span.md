 ## 新式 Span 做法

如果看懂了 Span 结构图，你就应该会使用 _pointer + length 将 string 进行切片处理，对不对，代码如下：

            for (int i = 0; i < 10000; i++)
            {
                var num1 = int.Parse(word.AsSpan(0, splitIndex));

                var num2 = int.Parse(word.AsSpan(splitIndex));

                var sum = num1 + num2; 
            }

            然后在 托管堆 验证一下，是不是没有 临时 string 了？

0:000> !dumpheap -type String -stat
Statistics:
              MT    Count    TotalSize Class Name
00007ffc53a51e18      167        36538 System.String

https://mp.weixin.qq.com/s/S7WCis1GLyMfGensyMcjRA