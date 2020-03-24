



https://www.cnblogs.com/dreamsqin/p/12557070.html
目前有一个需求是在移动端上内嵌h5实现点位的视频直播，直播项目采用Vue编写，后端主要输出 RTMP 和 HLS 协议的直播流，本文主要总结一下整体开发的技术选型以及开发过程中的思考与学习总结。

流媒体传输
我的困惑： 什么是流媒体，以及其传输方式是怎样的？

流媒体
流媒体是指采用流式传输方式在 Internet 上播放的媒体格式，例如音频、视频等多媒体文件。

流式传输方式
流式传输方式是将多媒体文件经过特殊压缩后分成一个个压缩包，再由服务器向客户端连续、实时传送。用户不必像非流式传输那样等待整个文件全部下载完毕后才能播放，而是只需要经过几秒钟或几十秒的启动延时即可对压缩的音视频文件进行播放，剩余的部分将继续下载，直至播放完毕。

流媒体传输协议
常用的流媒体传输协议主要有HTTP渐进式下载和实时流媒体协议两类。
HTTP渐进式下载：仅能传输完整的音视频文件，在给定时刻，用户只能观看已下载的那部分，而不能跳到还未下载的部分。HTTP边下载边播放，严格意义上讲，不是直播协议。他的原理是先下载文件的基本信息，音频视频的时间戳，再下载音视频数据，以播放mp4为例，先下载文件头，根据文件头指引下载文件尾，然后再下载文件的音视频数据。
实时流媒体协议：可用于实况直播，也可传输完整的音视频文件。例如RTSP/RTP、RTMP、HLS、HTTP-FLV。

RTSP协议
既可以基于UDP传输也可以基于TCP传输，是纯粹的传输控制协议，它本身与它负载的媒体数据不相关，RTSP协议需要自定义客户端向服务器发送RTSP命令。其视频数据由RTP传输，视频质量由RTCP控制，视频控制（如播放、暂停等）由RTSP提供。

常用直播流协议
我的困惑： 哪些流媒体传输协议用于直播，不同类型之间又有什么区别？

RTMP（Real Time Messaging Protocol）
协议比较全能，既可以用来推送，又可以用来直播。其核心理念是将大块的视频帧和音频帧“剁碎”，然后以小数据包的形式在互联网上进行传输，且支持加密，因此隐私性相对比较理想，但拆包组包的过程比较复杂，所以在海量并发时容易出现一些不可预期的稳定性问题。

HLS（HTTP Live Streaming）
苹果推出的解决方案，将视频分成 5-10 秒的视频小分片，然后用 M3U8 索引表进行管理。由于客户端下载到的视频都是 5-10 秒的完整数据，故视频的流畅性很好，但也同样引入了很大的延迟（HLS 的一般延迟在 10-30s 左右）。相比于 FLV，HLS 在iPhone 和大部分 Android 手机浏览器上的支持非常给力，所以常用于 QQ 和微信朋友圈的 URL 分享。

HTTP-FLV（Flash Video）
由 Adobe 公司主推，格式极其简单，只是在大块的视频帧和音视频头部加入一些标记头信息，由于这种极致的简洁，在延迟表现和大规模并发方面都很成熟。唯一的不足就是在手机浏览器上的支持非常有限，但是用作手机端 APP 直播协议却异常合适。

RTMP、HLS、HTTP-FLV 协议对比如下图所示：



直播原理
我的困惑： 想要实现直播，需要经历怎样的过程？

如果用一句话描述整体过程，其实就是直播时，主播端将直播流推向服务器，用户端发起请求从服务器拉视频流过来解码播放，流程如下图所示：



第一部分就是视频主播端的操作：视频采集处理后推流到流媒体服务器。

首先从前端采集设备中获得原始的音频、视频数据；
为了增强额外效果，对音频进行混音、降噪等处理，可为视频打上时间戳、添加Logo水印或增加滤镜；
随后对音频、视频进行编码，通过编码压缩满足其在互联网上实时传输的需求；
编码后就可以把各种多媒体内容（视频、音频、字幕等）盛放在同一个容器里，也就是所谓的封装，使得不同多媒体内容可同步播放，与此同时还提供了索引；
最后就是通过流传输协议将封装好的内容推送到流媒体服务器上；
第二部分就是流媒体服务器：负责把从第一部分接收到的流进行处理并分发给用户。

流媒体服务器的主要功能是对流媒体内容进行采集（接收推流）、缓存、调度和传输播放（以流式协议实现用户分发）。

典型的流媒体服务器：

微软的Windows Media Service（WMS）：它采用MMS协议接收、传输视频，采用Windows Media Player（WMP）作为前端播放器；
RealNetworks公司的Helix Server：采用RTSP/RTP协议接收、传输视频，采用Real Player作为播放前端播放器；
Adobe公司的Flash Media Server：采用RTMP（RTMPT/RTMPE/RTMPS）协议接收、传输视频，采用Flash Player作为前端播放器；
第三部分就是用户：只需要拥有支持对应流媒体传输协议的播放器即可。

这一部分其实就是我们前端需要实现的，如何在移动端的内嵌h5页面中实现直播流的播放。所以我们只需要关注后端是通过什么协议给我们返回直播流以及我们如何有效的播放就可以了~

客户端直播插件
我的困惑： 除了采用h5原生的<video></<video>标签，我们还能用什么插件实现视频直播，不同插件之间有什么区别？

经过我暴风式搜索后找到三款常用并且支持实时流媒体播放的客户端插件（hls.js、video.js、vue-video-player），下面我们一个个道来。

hls.js
hls.js是一个可以实现HTTP实时流媒体客户端的js库，主要依赖于<video></<video>标签和Media Source ExtensionsAPI。它的工作原理是将MPEG2传输流和AAC/MP3流转换成ISO BMFF (MP4)片段。由于hls.js是基于标准的<video></<video>标签实现播放，所以它不需要额外的播放器。

优点： 包比较小，很纯净，UI可以根据自己的业务自行扩展，功能可以根据需求进行封装，比较灵活，而且专业直播HLS协议流。
缺点： 对于常规的通用性播放器没有封装好的UI，功能上也需要自己调API实现，协议单一，只支持HLS。

video.js
video.js是一个基于h5的网络视频播放器，支持h5视频、现代流媒体格式（MP4、WebM、HLS、DASH等）以及YouTube、Vimeo，甚至连flash也支持(通过插件实现，后面会详细说明)，可在桌面端或移动端实现视频播放。

优点： 支持多种格式的流媒体播放，浏览器不支持时可实现优雅降级；专门有一套针对直播流的UI；插件机制强大，目前社区已有数百个皮肤和插件供下载；兼容性好，几乎支持所有桌面及移动端的浏览器。
缺点： 包比较大，实现hls直播的时候其实是内嵌了hls.js的代码，由于封装好UI和功能，使其不够灵活，修改UI时需要通过插件实现。

vue-video-player
vue-video-player其实就是将video.js集成到了Vue中，在Vue项目中使用起来会更方便。

移动端内嵌h5实现视频直播
1、技术选型：

传输协议——由于后端支持同时返回HLS协议和RTMP协议的直播流，结合考虑HLS协议的高延时问题和RTMP协议的兼容性问题，本项目决定采用向下兼容的方式实现，默认使用RTMP协议直播，当浏览器不支持时降级使用HLS协议播放。
直播插件——本项目基于Vue实现，并且业务逻辑为常规直播操作，无特殊需求，从开发效率、稳定性及兼容性出发，决定采用vue-video-player插件实现。
2、vue-video-player安装与引入：

CDN：
<link rel="stylesheet" href="path/to/video.js/dist/video-js.css"/>
<script type="text/javascript" src="path/to/video.min.js"></script>
<script type="text/javascript" src="path/to/vue.min.js"></script>
<script type="text/javascript" src="path/to/dist/vue-video-player.js"></script>
<script type="text/javascript">
  Vue.use(window.VueVideoPlayer)
</script>
NPM（支持全局/按需引入）：npm install vue-video-player --save

全局引入

import Vue from 'vue'
import VueVideoPlayer from 'vue-video-player'

// 引入videojs样式
import 'video.js/dist/video-js.css'
// 自定义样式引入，并为<video-player>添加对应类名即可，例如vjs-custom-skin
// import 'vue-video-player/src/custom-theme.css'

Vue.use(VueVideoPlayer, /* {
  options: 全局默认配置,
  events: 全局videojs事件
} */)
按需引入

// 引入videojs样式
import 'video.js/dist/video-js.css'

import { videoPlayer } from 'vue-video-player'

export default {
  components: {
    videoPlayer
  }
}
3、video.js插件扩展： 当已有插件（video.js插件集合：https://videojs.com/plugins/）无法满足需求时可对已有插件进行扩展或自行开发video.js插件

import videojs from 'video.js'

// videojs plugin
const Plugin = videojs.getPlugin('plugin')
class ExamplePlugin extends Plugin {
  // something...
}
videojs.registerPlugin('examplePlugin', ExamplePlugin)

// videojs language
videojs.addLanguage('es', {
  Pause: 'Pausa',
  // something...
})

// more videojs api...

// vue component...
具体实现方式可参见：https://github.com/videojs/video.js/blob/master/docs/guides/plugins.md

4、视频直播关键代码：
options：video.js options
playsinline：设置播放器在移动设备上不全屏[ Boolean, default: false ]
customEventName：自定义状态变更时的事件名[ String, default: 'statechanged' ]

<template>
  <video-player
        class="video-player-box"
        ref="videoPlayer"
        :options="playerOptions"
        :playsinline="true"
        customEventName="customstatechangedeventname"
        @play="onPlayerPlay($event)"
        @pause="onPlayerPause($event)"
        @ended="onPlayerEnded($event)"
        @waiting="onPlayerWaiting($event)"
        @playing="onPlayerPlaying($event)"
        @loadeddata="onPlayerLoadeddata($event)"
        @timeupdate="onPlayerTimeupdate($event)"
        @canplay="onPlayerCanplay($event)"
        @canplaythrough="onPlayerCanplaythrough($event)"
        @statechanged="playerStateChanged($event)"
        @ready="playerReadied">
  </video-player>
</template>
export default {
    data() {
      return {
        playerOptions: {
          // 是否关闭音频
          muted: true,
          // 初始语言，默认为英语，code参见：https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
          language: 'zh-CN',
          // 播放速度，指定后Video.js将显示一个控件(vjs-playback-rate类的控件)，允许用户从选项数组中选择播放速度
          playbackRates: [0.5, 1.0, 1.5, 2.0],
          // 将播放器置于流畅模式，并在计算播放器的动态大小时使用该值，表示长宽比例
          aspectRatio: '4:3',
          // 等同于原生<video>标签中的一组<source>子标签，可实现优雅降级；type 属性规定媒体资源的 MIME 类型，标准类型可参见：https://www.iana.org/assignments/media-types/media-types.xhtml；
          sources: [{
            type: "rtmp/flv",
            src: "rtmp://58.200.131.2:1935/livetv/hunantv"
          }, {
            type: "application/x-mpegURL",
            src: "http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8"
          }],
          // 兼容顺序，默认值是['html5']，这意味着html5技术是首选，其他已注册的技术将按其注册的顺序在该技术之后添加。
          techOrder: ['flash'],
          // 在视频开始播放之前显示的图像的URL（封面），这通常是一个视频帧或自定义标题屏幕，一旦用户点击“播放”，图像就会消失。
          poster: require('../assets/test.jpg'),
        }
      }
    },
    mounted() {
      console.log('this is current player instance object', this.player)
    },
    computed: {
      player() {
        return this.$refs.videoPlayer.player
      }
    },
    methods: {
      // 各个事件监听
      onPlayerPlay(player) {
        // console.log('播放器播放!', player)
      },
      onPlayerPause(player) {
        // console.log('播放器暂停!', player)
      },
      // ...（此处省略多个事件监听函数）

      // 状态监听
      playerStateChanged(playerCurrentState) {
        // console.log('播放器当前状态更新', playerCurrentState)
      },

      // 监听播放器是否就绪
      playerReadied(player) {
        console.log('播放器已就绪', player)
        // 就绪后就可以调用播放器的一些方法
      }
    }
 }
踩坑小tips：
播放 HLS 协议流，需要videojs-contrib-hls插件，但是直接引用即可，因为在安装vue-video-player插件时，videojs-contrib-hls是一并安装的；如果需要播放RTMP协议流，需要videojs-flash插件，也是直接引用就可以了（flash插件需要在hls之前引用）



import 'videojs-flash'
import 'videojs-contrib-hls'
5、效果展示：

封面


rtmp



hls


总结
本文首先阐述了流媒体、流媒体传输方式、流媒体传输协议以及RTSP协议的概念；接着基于项目直播需求引出三种常用直播流协议RTMP、HLS、HTTP-FLV，并对三种协议进行了对比分析，为后续技术选型提供参考；然后根据通用直播原理描述了整个直播流数据传输的过程，从采集、处理、编码、封装到推流、分发与播放，表明前端的重点工作在最后一步即流媒体播放；随后对常用的三款客户端直播插件hls.js、video.js、vue-video-player进行说明，并分析了各自的优缺点；最后详细总结了移动端内嵌h5实现视频直播的编码过程，包括技术选型、插件的安装与引入、插件扩展、视频直播关键代码及最终的效果展示。
本项目中视频直播方式的实现大大提高了前端的开发效率，并且保证了桌面端与移动端的兼容性，同时增强了用户体验，比传统只使用一种协议的播放源更灵活，为通用直播需求提供解决方案。

参考资料
1、直播流播放协议：https://help.aliyun.com/knowledge_detail/49785.html
2、流媒体服务器：https://baike.baidu.com/item/%E6%B5%81%E5%AA%92%E4%BD%93%E6%9C%8D%E5%8A%A1%E5%99%A8/9711212?fr=aladdin
3、hls.js：https://github.com/video-dev/hls.js
4、video.js： https://github.com/videojs/video.js
5、vue-video-player：https://github.com/surmon-china/vue-video-player