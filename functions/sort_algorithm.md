详解O(1),O(n),O(logn),O(nlogn)的区别
       相信很多开发的同伴们在研究算法、排序的时候经常会碰到O(1)，O(n)，O(logn)，O(nlogn)这些复杂度，看到这里就会有个疑惑，这个O(N)到底代表什么呢？带着好奇开始今天文章。

       首先o(1), o(n), o(logn), o(nlogn)是用来表示对应算法的时间复杂度,这是算法的时间复杂度的表示。不仅仅用于表示时间复杂度，也用于表示空间复杂度。

算法复杂度分为时间复杂度和空间复杂度。其作用：

时间复杂度是指执行这个算法所需要的计算工作量；

空间复杂度是指执行这个算法所需要的内存空间；

       时间和空间都是计算机资源的重要体现，而算法的复杂性就是体现在运行该算法时的计算机所需的资源多少；


       O后面的括号中有一个函数，指明某个算法的耗时/耗空间与数据增长量之间的关系。其中的n代表输入数据的量。

       时间复杂度为O(n)—线性阶，就代表数据量增大几倍，耗时也增大几倍。比如常见的遍历算法。
//循环遍历N次即可得到结果
count = 0;
for(int i = 0;i < 10 ; i ++){
	count ++;
}
  时间复杂度O(n^2)—平方阶, 就代表数据量增大n倍时，耗时增大n的平方倍，这是比线性更高的时间复杂度。比如冒泡排序，就是典型的O(n x n)的算法，对n个数排序，需要扫描n x n次。
 for(int i =1;i<arr.length;i++) { //遍历n次
    for(int j=0;j<arr.length-i;j++) {//遍历n-1次
       if(arr[j]>arr[j+1]) {
              int temp = arr[j];
              arr[j]=arr[j+1];
              arr[j+1]=temp;
         }
     }    
}
//整体复杂度n*(n-1)

       时间复杂度O(logn)—对数阶，当数据增大n倍时，耗时增大logn倍（这里的log是以2为底的，比如，当数据增大256倍时，耗时只增大8倍，是比线性还要低的时间复杂度）。二分查找就是O(logn)的算法，每找一次排除一半的可能，256个数据中查找只要找8次就可以找到目标。
int binarySearch(int a[], int key) {
    int low = 0;
    int high = a.length - 1;
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (a[mid] > key)
            high = mid - 1;
        else if (a[mid] < key)
            low = mid + 1;
        else
            return mid;
    }
    return -1;
}

       时间复杂度O(nlogn)—线性对数阶，就是n乘以logn，当数据增大256倍时，耗时增大256*8=2048倍。这个复杂度高于线性低于平方。归并排序就是O(nlogn)的时间复杂度。
public void mergeSort(int[] arr, int p, int q){
    if(p >= q) {
		return
	};
    int mid = (p+q)/2;
    mergeSort(arr, p, mid);
    mergeSort(arr, mid+1,q);
    merge(arr, p, mid, q);
}
private void merge(int[] arr, int p, int mid, int q){
    int[] temp = new int[arr.length]; //此处将数组设为全局变量，否则每次都要创建一遍。
    int i = p, j = mid+1，iter = p;
    while(i <= mid && j <= q){
        if(arr[i] <= arr[j]) {
			temp[iter++] = arr[i++]；
		} else{
			temp[iter++] = arr[j++];
		} 
    }
    
    while(i <= mid) {
		temp[iter++] = arr[i++];
	}
	
    while(j <= q){
 		temp[iter++] = arr[j++];
	}
	
    for(int t = p; t <= q; t++) {
		arr[t] = temp[t];
	}
}

       O(1)—常数阶：最低的时空复杂度，也就是耗时与输入数据大小无关，无论输入数据增大多少倍，耗时/耗空间都不变。 哈希算法就是典型的O(1)时间复杂度，无论数据规模多大，都可以在一次计算后找到目标。
index = a;
a = b;
b = index;
//运行一次就可以得到结果

时间复杂度的优劣对比
常见的数量级大小：越小表示算法的执行时间频度越短，则越优；
O(1)<O(logn)<O(n)<O(nlogn)<O(n2)<O(n3)<O(2n)//2的n方<O(n!)<O(nn)//n的n方
原文链接：https://blog.csdn.net/A_dg_Jffery/article/details/99713579