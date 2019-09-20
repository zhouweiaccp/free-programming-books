
https://www.cnblogs.com/nn839155963/p/11557411.html
此项目源码：https://github.com/zjhpure/crawler_public_number
Android按键精灵源码：https://github.com/zjhpure/PublicNumberQuickMacro

1、环境：ubuntu16.04 + redis + mysql + python3.5 + anyproxy + android + pm2 + npm + node

一台爬虫服，python3环境，建议在ubuntu16.04下，不用再装一次python3。
一台代理服，root权限，anyproxy环境和pm2环境，要先装好npm和node才能装anyproxy，pm2是用来控制anyproxy的。
至少一台android手机/模拟器(公众号越多，android就需要越多，按键精灵的点击频率根据实际调整)，装上微信，微信版本要求：6.66，登录一个微信号(建议微信号进行认证，否则很快会被禁止登录)，安装上按键精灵，使用按键精灵时先杀掉微信的进程，避免此软件使用时自动启动微信而打开两个微信启动类。
一个mysql数据库。
一个redis数据库。
如果机器不够，可以把爬虫服、代理服、mysql、redis都放在一台机器上。
2、这里介绍的方法是通过anyproxy中间人代理的方式实现公众号的爬取。思路如下：准备一些微信号，模拟器/手机设置wifi连接anyproxy代理服务器，服务器提供获取公众号的接口（这里说明一下为何要一个获取公众号的接口，如果是以前是不需要的，按键精灵随便点击一个公众号的历史消息就可以，而产生的headers可以用于访问其他任何的公众号的历史消息，但是在去年年末微信进行了一次升级，只能一对一地访问，也就是说点击一个公众号的历史消息产生的headers只能用于访问这个公众号的历史消息），按键精灵定时访问这个接口获取要点击的公众号，然后点击公众号的查看历史消息，这时anyproxy服务器就要截取这里的headers以及其它的必要信息保存到redis，服务器通过redis获取刚才的信息，然后就能模拟访问这个公众号的历史消息。

3、项目的结构如下，


项目结构
4、运行crawler/crawler.py时，用了redis的blpop方法，

def operate_redis(self):
    x_wechat_key = None
    x_wechat_uin = None
    user_agent = None
    cookie = None
    url = None
    flag = True
    while flag:
        self.print_with_time('prepare to connect redis')
        # 连接redis
        redis = StrictRedis(host=redis_db['host'], port=redis_db['port'], password=redis_db['password'])
        # 从左边pop出数据,b表示若没有数据,则会一直堵塞等待
        info = str(redis.blpop('click_public_number')[1], encoding='utf-8')
        info = info.split('&&')
        self.print_with_time(info)
        # 获取从anyproxy拦截公众号历史消息请求时储存在redis上的时间戳
        t = info[4]
        # 获取当前时间戳
        now = int(time.time())
        self.print_with_time('now: ' + str(now))
        # 公众号历史消息请求使用的参数有时效性,为了避免请求失效,这里时间戳不大于当前时间戳500的时间戳,即500秒
        # 还需url包含pass_ticket,因为有些网址不完整,需要去掉,如下:
        # 有时网址是这样:https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz={biz值}&scene=124&
        # 有时网址是这样:https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz={biz值}&scene=124&devicetype=android-23&version=26060135&lang=zh_CN&nettype=WIFI&a8scene=3&pass_ticket={pass_ticket值}&wx_header=1
        # 要把前者去掉
        if now - int(t) <= 500 and 'pass_ticket' in info[5]:
            flag = False
            x_wechat_key = info[0]
            x_wechat_uin = info[1]
            user_agent = info[2]
            cookie = info[3]
            url = info[5]
            self.print_with_time('x_wechat_key: ' + x_wechat_key)
            self.print_with_time('x_wechat_uin: ' + x_wechat_uin)
            self.print_with_time('user_agent: ' + user_agent)
            self.print_with_time('cookie: ' + cookie)
            self.print_with_time('time: ' + t)
    self.print_with_time('get pub headers by redis success')
    return x_wechat_key, x_wechat_uin, user_agent, cookie, url
这个方法会一直堵塞直到有数据为止，redis上保存的是微信访问公众号历史消息时的headers、url以及当时的时间戳，记录时间戳是为了爬虫在取redis数据时去掉时间太久远的，因为时间太久远链接会失效，而redis上的数据是anyproxy服务器录入的，这里需要配置anyproxy的rule_default.js文件，在/usr/local/lib/node_modules/anyproxy/lib下，编写方法sendToRedis，

function sendToRedis(x_wechat_key, x_wechat_uin, user_agent, cookie, url) {
    var redis = require("redis");
    client = redis.createClient(6379, 'localhost', {});
    client.auth('123456');
    client.on("error", function (err) {
        console.log("Error " + err);
    });
    var now = Math.round(new Date().getTime() / 1000)
    console.log(now);
    client.rpush('click_public_number', x_wechat_key + '&&' + x_wechat_uin + '&&' + user_agent + '&&' + cookie + '&&' + now + '&&' + url, redis.print)
    client.quit();
};
sendToRedis方法放在文件最顶头，即'use strict'的上面，这里需要在/usr/local/lib/node_modules/anyproxy目录下执行以下命令以增加node的redis模块

sudo npm install redis
接着重写rule_default.js文件的beforeSendResponse方法，

*beforeSendResponse(requestDetail, responseDetail) {
    var tempStr = "mp.weixin.qq.com/mp/profile_ext?action=home";
    var res = requestDetail.url.indexOf(tempStr)
    if (res > 0) {
        var body = responseDetail.response.body
        var regu = "操作频繁，请稍后再试";
        if (body.indexOf(regu) >= 0) {
            console.log('微信操作频繁网页');
        } else {
            var data = requestDetail.requestOptions;
            sendToRedis(data.headers['x-wechat-key'], data.headers['x-wechat-uin'], data.headers['User-Agent'], data.headers['Cookie'], requestDetail.url)
            console.log(data);
        }
    }
    return null;
},
这里说明一下，微信对于点击历史消息是有限制的，一天一个账号最多只能点击一定的次数，超过了就会出现”操作频繁，请稍后再试“，大概需要12小时后才会恢复，所以这里在anyproxy服务器这里就把这种情况过滤掉，当然最根本的是要在android按键精灵那边控制好点击频率。接下来就是启动anyproxy服务器，在安装好anyproxy后，先要生成CA证书，执行

anyproxy-ca
其实生成CA证书这一步可以进行一个验证，执行anyproxy为不带CA证书启动，执行anyproxy -i为带CA证书启动，没有CA证书只能anyproxy就不能获取到https的内容，如果没有执行anyproxy-ca就执行anyproxy -i会无法启动anyproxy，命令行会提示需要CA证书的。然后就是使用pm2来启动并管理anyproxy，首次启动执行

sudo pm2 start anyproxy -x -- -i
之后的启动执行

sudo pm2 start anyproxy
查看anyproxy运行情况执行

sudo pm2 list
重启anyproxy执行

sudo pm2 restart anyproxy
pm2
可以把anyproxy/restart_anyproxy.py文件复制到anyproxy的机器上，执行

nohup python3 -u restart_anyproxy.py &
让anyproxy每天凌晨重启一次，因为anyproxy运行太久会变卡顿。在浏览器输入：代理服ip:8002，查看anyproxy运行情况，


anyproxy
android连接wifi指定anyproxy代理，代理地址是代理服ip，端口是8001，在代理服ip:8002网址上，点击RootCA后，屏幕出现二维码和download按钮，可以点击download直接下载到电脑然后复制到手机安装CA证书，或者用手机浏览器扫二维码安装CA证书，还可以用手机浏览器访问：代理服ip:8002/fetchCrtFile安装CA证书。

5、public_number/get_public_number.py用来生成公众号队列，有了这个，服务器对爬取频率有最终的控制权，这里的策略是每隔几秒从mysql获取几个公众号存到redis上，设置一个队列的数量上限，而按键精灵接口就是从redis上获取要点击的公众号的，get_public_number.py是从右边push进公众号数据，按键精灵接口api.py是从左边pop出公众号数据，一旦队列数量不足上限了，get_public_number.py又会从mysql处接着获取公众号数据从右边push到公众号队列里，下面是public_number/get_public_number.py部分代码，

# 连接redis
redis = StrictRedis(host=redis_db['host'], port=redis_db['port'], password=redis_db['password'])
n = 19
while True:
    self.print_with_time('sleep 10s')
    time.sleep(10)
    for row in self.mysql_operate.query_pub():
        self.print_with_time('sleep 2s')
        time.sleep(2)
        public_number_wechat_id = row[1]
        public_number_name = row[2]
        public_number_biz = row[3]
        if redis.llen('public_number') <= 19:
            redis.rpush('public_number', public_number_name + '&&' + public_number_wechat_id + '&&' + public_number_biz)
            print('public_number_wechat_id:' + public_number_wechat_id + ' public_number_name:' + public_number_name + ' public_number_biz:' + public_number_biz)
        else:
            self.print_with_time('public_number size can not more than ' + str(n + 1))
            self.print_with_time('sleep 2s')
            time.sleep(2)
            while redis.llen('public_number') <= 19:
                if redis.llen('public_number') <= 19:
                    redis.rpush('public_number', public_number_name + '&&' + public_number_wechat_id + '&&' + public_number_biz)
                    print('public_number_wechat_id:' + public_number_wechat_id + ' public_number_name:' + public_number_name + ' public_number_biz:' + public_number_biz)
                else:
                    self.print_with_time('public_number size can not more than ' + str(n + 1))
                    self.print_with_time('sleep 2s')
                    time.sleep(2)
下面是api.py，

import json

from cfg.cfg import redis_db, api_port
from flask import Flask
from redis import StrictRedis

app = Flask(__name__)

@app.route('/')
def hello():
    return 'hello world!'

@app.route('/crawler/public_number/get_click_public_number', methods=['GET', 'POST'])
def get_click_public_number():
    # 连接redis
    redis = StrictRedis(host=redis_db['host'], port=redis_db['port'], password=redis_db['password'])
    if redis.llen('public_number') > 0:
        # redis长度不为0,从左pop出数据,按键精灵可以点击
        info = str(redis.lpop('public_number'), encoding='utf-8')
        info = info.split('&&')
        print(info)
        data = {"errcode": 0, "msg": "获取公众号成功",
            "result": {"publicNumberName": info[0], "publicNumberWechatId": info[1], "publicNumberBiz": info[2]}}
    else:
        # redis长度为0,按键精灵不用点击
        data = {"errcode": 1, "msg": "无公众号获取"}
    result = json.dumps(data, ensure_ascii=False)
    print(result)
    return result

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=api_port, debug=True)
6、cfg/cfg_test.py配置测服运行时的redis、mysql以及按键精灵接口的端口，cfg/cfg_prod同理配置正服，

api_port = 10002

redis_db = {
    'host': 'localhost',
    'port': 6379,
    'password': '123456'
}

mysql_db = {
    'host': 'localhost',
    'user': 'root',
    'password': '123456',
    'db': 'crawl_wx_pub',
    'port': 3306
}
mysql创建数据库crawl_wx_pub，通过db/db.sql数据库脚本生成表，一共有三个表，公众号表pub，公众号文章表pub_article，爬取记录表crawl_record，这里只测试两个公众号，pythonbuluo(Python程序员)，python-china(Python中文社区)，所以微信那边需要关注这两个公众号，当然你可以修改成其他公众号，需要在pub表上填上公众号微信号、公众号名称和公众号biz值，biz值的获取，点击公众号的历史消息，点击右上角按钮，点击复制链接，在一个地方查看这个链接，链接像如下：https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MjM5NzU0MzU0Nw==&scene=123&pass_ticket={pass_ticket值}，那这里的biz值就是MjM5NzU0MzU0Nw==。

7、从redis取得headers等信息后，crawl/crawl.py先查询mysql是否存在此公众号，

# 通过biz值查询数据库里是否有今天未爬取的此公众号
result = self.mysql_operate.query_public_number_by_biz(biz=biz)
self.print_with_time(result)
if len(result) > 0:
    row = result[0]
    public_number_id = row[0]
    public_number_wechat_id = row[1]
    public_number_name = row[2]
    try:
        self.print_with_time('public_number_wechat_id:' + public_number_wechat_id + ' public_number_name:' + public_number_name)
        response = requests.request('GET', url, headers=headers)
        meta = {'public_number_wechat_id': public_number_wechat_id, 'public_number_name': public_number_name, 'public_number_id': public_number_id}
        article_num = self.parse(response, meta)
        # 若今天的文章数量为0,可能公众号还没有发表文章
        if article_num > 0:
            # 今天已爬取,标记为1,这里一旦有一次今天爬取成功了,就标记为今天已爬取
            # 大多数公众号一天只能发文一次,除了少数早期的公众号可以发文多次,新申请应该都是一天只能发文一次                      
            self.mysql_operate.update_public_number_today_is_crawl(public_number_wechat_id=str(public_number_wechat_id), today_is_crawl=str(1))
        # 录入爬取记录,1为爬取成功
        self.mysql_operate.insert_crawl_record(public_number_id=public_number_id, crawl_status=1)
    except Exception as e:
        self.print_with_time(e)
        traceback.print_exc()
        self.print_with_time(
                    'crawl failure, ' + 'public_number_wechat_id:' + public_number_wechat_id + ', public_number_name:' + public_number_name)
        # 录入爬取记录,0为爬取失败
        self.mysql_operate.insert_crawl_record(public_number_id=public_number_id, crawl_status=0)
数据库会有一个标记今天是否已爬取的字段，而查询是否有此公众号时会把此条件加进，这里这么做还有上面的通过服务器生成公众号队列都是为了减慢爬取的频率，因为微信对于爬取次数是有严格控制的，爬取时需要尽可能地减少无用的爬取。而crawler/reset_crawl.py文件就是每天凌晨定时把今天是否已爬取这个字段重置为未爬取，

while True:
    self.print_with_time('sleep 10s')
    time.sleep(10)
    # 获取当前时间
    now = str(datetime.datetime.now())
    # 获取当前时间的小时数
    hour = now.split(' ')[1].split(':')[0]
    # 若小时数为00,则证明已经到了凌晨
    if '00' == hour:
        # 重置所有公众号的今天是否已爬取为0
        self.mysql_operate.reset_all_public_number_today_is_crawl()
        self.print_with_time('sleep 4000s')
        # 执行完就休眠一个小时,一天只重置一次
        time.sleep(4000)
crawler/crawler.py确定公众号今天没有爬取完后，就会正式开始进行爬取，获取公众号历史消息中的今天文章和昨天文章的链接以及封面，访问这些链接，获取它们的标题和发表时间，而在插入数据到mysql时就是通过公众号微信号、文章标题和文章发表时间来判定是否重复的，具体代码看crawler/crawler.py。如果是真的要上线的，需要获取文章的内容，然后保存成文件上传到云存储比如七牛云，同样封面和内容中的图片链接也需要上传到云存储，以防止图片地址有时效性或禁止外链访问，但这里就不具体写出这些了。

8、最后就是怎么启动这个项目了，拿测服说，正服同理，把项目整体复制到爬虫测服上，目录放在/data/crawler/下，因为ctl_test.sh的开头是这样的，

ROOT=/data/crawler/crawler_public_number
如果目录要放在其它地方，那ctl_test.sh的ROOT就要对应地改变。进入项目目录，执行chmod +x ctl_test.sh，使ctl_test.sh可执行，执行sh ctl_test.sh start_api，启动按键精灵接口，执行sh ctl_test.sh start，启动爬虫，项目就启动起来了，项目运行后会在项目目录下生成nohup.out文件记录运行情况。可以通过命令

ps -aux | grep python3
查看项目是否在运行，如果是出现以下进程就是正确的，


爬虫进程

2个api.py的进程，4个start.py的进程，少了一个都是运行异常。访问网址测试按键精灵接口是否正常，


按键精灵接口
刚开始时可以先执行api.py，然后执行start.py，这样可以直观的在控制台看到输出信息，测试无误后再放到真正的服务器上，通过执行脚本文件的方式来启动项目。

9、说一下按键精灵的流程：间隔一定时间请求一次按键精灵接口ip:/crawler/public_number/get_click_public_number，接收到公众号微信号和公众号名字，然后就自动点击这个公众号的历史消息。若用了非6.66版本的微信可以使用Android Device Monitor查看微信按钮、节点等的信息，修改对应的源码；若要查看微信某个页面的activity类名，可以执行命令adb shell dumpsys activity | grep mFocusedActivity获取手机屏幕当前的activity。上面提到的要手动关注公众号，因为关注微信公众号的那个页面是个webview，如果是使用传统的AccessibilityService辅助功能实现自动点击是无法获取到webview里的信息，需要root手机来获取按钮的位置实现点击，所以这个项目目前的缺点就是还无法实现自动关注公众号。还有补充说一下，为什么不用scrapy框架，一开始我也是用scrapy框架的，但是也就是在去年年末微信升级的时候，不知微信下了什么毒，用scrapy框架就会出现什么连接丢失的错误，我也百思不得其解，但是改用requests就没事了，所以现在用的就是requests，而且单线程，同时也降低了爬取的频率。不过这也让我明白另一点，爬虫不一定是比快还讲究慢哈。