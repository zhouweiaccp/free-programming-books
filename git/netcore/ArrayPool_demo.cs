public async Task CopyFromAsync(Stream input, CancellationToken cancellationToken)
        {
#if !NET45
            var buffer = ArrayPool<byte>.Shared.Rent(BufferSize);
#else
            var buffer = new byte[BufferSize];
#endif
 
            try
            {
                for (;;)
                {
                    var count = await input.ReadAsync(buffer, 0, buffer.Length, cancellationToken).ConfigureAwait(false);
                    if (count == 0)
                    {
                        break;
                    }
 
                    await WriteAsync(buffer, 0, count, cancellationToken).ConfigureAwait(false);
                }
            }
            finally
            {
#if !NET45
                ArrayPool<byte>.Shared.Return(buffer);
#endif
            }
        }
//https://www.csharpcodi.com/csharp-examples/System.Buffers.ArrayPool.Rent(int)/