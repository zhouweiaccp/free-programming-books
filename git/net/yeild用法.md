




## 数据去重
        static IEnumerable<int> FilterWithYield()

        {
            int a = 0;
            var arr = new int[] { 1, 2, 2, 3, 4, 5, 6 };
            for (int i = 0; i < arr.Length; i++)
            {
                a = arr[i];
                if (i + 1 == arr.Length)
                {
                    yield return a;
                    yield break;
                }
                if (arr[i+1]!=a)
                {
                    yield return a;
                }

            }
        }
        static void Main(string[] args)
        {

            foreach (var item in FilterWithYield())
            {
                Console.WriteLine(item);
            }
            Console.ReadLine();
        }