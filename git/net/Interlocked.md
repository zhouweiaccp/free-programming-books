



##  public static int CompareExchange(
	ref int location1,
	int value,
	int comparand
)

为例说明其运算过程：
比较location1与comparand，如果不相等，什么都不做；如果location1与comparand相等，则用value替换location1的值。无论比较结果相等与否，返回值都是location1中原有的值