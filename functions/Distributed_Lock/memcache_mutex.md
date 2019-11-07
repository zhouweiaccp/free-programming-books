     之前在网上看过memcache-mutex的场景分析和实现代码，这里将.net方式加以实现，当然这里主要是依据原文的伪代码照猫画虎，以此做为总结及记录。如果您对相应实现感兴趣可以尝试使用本文提供的代码进行测试，如果有问题请及时与我联系。   
     原文链接：http://timyang.net/programming/memcache-mutex/ 
     本地链接：http://www.cnblogs.com/daizhj/articles/1959704.html
 

     为了实现原文中的对象到期时间属性，定义了一个基类，其信息如下：

 

复制代码

[Serializable]
public class CacheObj
{
        /// <summary>
        /// 数据绝对到期时间，默认为当前时间开始三分钟后失效
        /// </summary>
        public DateTime ExpireTime = DateTime.Now.AddMinutes(3);      

        /// <summary>
        /// 数据相对有效时间，单位:秒。默认为30秒有效期
        /// </summary>
        public int TimeOut = 30;
}
复制代码


     这样所有要放到memcached的对象只要继承该对象就OK了，比如下面的用户信息类： 


复制代码

/// <summary>
/// 用户信息
/// </summary>
[Serializable]
public class UserInfo : CacheObj
{
        public string UserName;
        public int Age;
        public string Email;

        public override string ToString()
        {
            return "UserName:" + UserName + "  Age:" + Age + "  Email:" + Email;
        }
}
复制代码


     下面是原文中方式一的实现代码：
 

复制代码

MemcachedClient mc = MemCachedManager.CacheClient;
//方一
public UserInfo GetCacheData1(string key)
{
    UserInfo value = mc.Get(key) as UserInfo;
    if (value == null)
    {
        // 3 分钟到期.在delete操作执行之前，当前key_mutex add只能被添加一次并返回true
        if (mc.Add(key + "_mutex", key + "_mutex", DateTime.Now.AddMinutes(3)) == true)
        {
            value = new UserInfo() { UserName = "daizhj", Email = "daizhj617595@126.com" };// db.get(key);//从加载数据
            mc.Set(key, value);
            mc.Delete(key + "_mutex");                    
        }
        else
        {
            System.Threading.Thread.Sleep(500);//如果设置过短，可能上面set语法还未生效
            value = mc.Get(key) as UserInfo;//sleep之后重试读取cache数据
        }
    }
    return value;
}
复制代码


    下面是方式2的代码：

 

复制代码

//方法二
public UserInfo GetCacheData2(string key)
{
    UserInfo value = mc.Get(key) as UserInfo;
    if (value == null)
    {
        // 3 分钟到期，在delete之前，当前key_mutex add只能被添加一次并返回true
        if (mc.Add(key + "_mutex", "add_mutex", DateTime.Now.AddMinutes(3)) == true)
        {
            value = new UserInfo() { UserName = "daizhj", Email = "daizhj617595@126.com" };// db.get(key);//从加载数据
            mc.Set(key, value);
            mc.Delete(key + "_mutex");
        }
        else
        {
            System.Threading.Thread.Sleep(500);//如果设置过短，可能上面set语法还未生效
            value = mc.Get(key) as UserInfo;//sleep之后重试读取cache数据
        }
    }
    else
    {
        if (value.ExpireTime <= DateTime.Now)
        {
            //有值但已过期 
            if (mc.Add(key + "_mutex", "add_mutex", DateTime.Now.AddMinutes(3)) == true)
            {
                value.ExpireTime = DateTime.Now.AddSeconds(value.TimeOut);
                //这只是为了让它先暂时有效（后面即将更新该过期数据），这样做主要防止避免cache失效时刻大量请求获取不到mutex并进行sleep，注意这里设置成有效会导致其它线程会暂时读到脏数据
                mc.Set(key, value, DateTime.Now.AddSeconds(value.TimeOut * 2));//这里*2是为了让memcached缓存数据更长时间，因为真正校验到期时间用ExpireTime来判断

                //从数据源加载最新数据
                value = new UserInfo() { UserName = "daizhenjun", Email = "617595@163.com" };// db.get(key);
                value.ExpireTime = DateTime.Now.AddSeconds(value.TimeOut);
                mc.Set(key, value, DateTime.Now.AddSeconds(value.TimeOut * 2));
                mc.Delete(key + "_mutex");
            }
            else
            {
                System.Threading.Thread.Sleep(500);//如果设置过短，可能上面set语法还未生效
                value = mc.Get(key) as UserInfo;//sleep之后重试读取cache数据
            }
        }
    }
    return value;
}
复制代码


      无论使用那种方式，都会带来代码复杂性增大（尤其第二种），另外还有就是与memcached额外的连接及存储开销（key_mutex本身存储也要消耗资源）。因为除非是高并发场景下同时更新memcached，否则这两种方式需要斟酌使用。