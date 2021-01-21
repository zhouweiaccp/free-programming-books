
## 批量上传
git@github.com:kazaff/webuploaderDemo.git
https://blog.kazaff.me/2014/11/14/%E8%81%8A%E8%81%8A%E5%A4%A7%E6%96%87%E4%BB%B6%E4%B8%8A%E4%BC%A0/



https://github.com/zhouweiaccp/AspnetMvcWebuploaderDemo   c# 管道上传研究中
https://github.com/javanf/webUpload   nodejs
https://github.com/wangyushuai/WebUploader-Demos


https://github.com/devin87/web-uploader/  js (html5 + html4) 文件上传管理器，支持上传进度显示，支持秒传+分片上传+断点续传，支持图片预览+缩放，支持 IE6+、Firefox、Chrome等



https://github.com/kissygalleryteam/uploader/blob/master/doc/demo/theme-crossUploader.html  上传界面效果

jQuery File Uploader、FineUploader、Uploadify、Baidu Web Uploader   
- [dropzone] (https://www.dropzonejs.com/#configuration)
- [filepond](https://github.com/pqina/filepond)A flexible and fun JavaScript file upload library  插件比较多,支持 jquery vue reat...  ![doc](https://pqina.nl/filepond/docs/)



## nodejs
-[](https://github.com/node-formidable/formidable)

https://www.npmjs.com/package/spark-md5  前端通过spark-md5.js计算本地文件md5
https://gitee.com/lsy69221/file-upload    基于Node.js的大文件分片上传
https://github.com/sunhaikuo/uploadDemo    基于Node.js的大文件分片上传
https://blog.csdn.net/x746655242/article/details/52964623 基于node服务器的大文件（G级）上传 


## multipart/form-data
https://github.com/Vodurden/Http-Multipart-Data-Parser
https://github.com/iLexDev/ASP.NET-WebApi-MultipartDataMediaFormatter



### 如何判断文件是否上传成功
默认如果啥也不处理，只要有返回数据就认为是成功，就算返回的是错误信息，也认为是成功了。https://github.com/fex-team/webuploader/issues/136

但是，在认为成功前会派送一个事件uploadAccept，这个事件是用来询问是否上传成功的。在这个事件中你可以拿到上传的是哪个文件，以及对应的服务端返回reponse。

uploader.on( 'uploadAccept', function( file, response ) {
    if ( hasError ) {
        // 通过return false来告诉组件，此文件上传有错。
        return false;
    }
});


### 如何实现秒传与断点续传
https://github.com/fex-team/webuploader/issues/142
因为这是小众需求，所以默认没有做在webuploader里面，而只是提供hook接口，让用户很简单的扩展此功能。

那么，都有哪些重要的hook接口呢？

before-send-file 此hook在文件发送之前执行
before-file 此hook在文件分片（如果没有启用分片，整个文件被当成一个分片）后，上传之前执行。
after-send-file 此hook在文件所有分片都上传完后，且服务端没有错误返回后执行。
...
对于秒传来说，其实就是文件上传前，把内容读取出来，算出md5值，然后通过ajax与服务端验证进行验证, 然后根据结果选择继续上传还是掉过上传。

像这个操作里面有两个都是异步操作，文件内容blob读取和ajax请求。所以这个handler必须是异步的，怎样告诉组件此handler是异步的呢？只需要在hanlder里面返回一个promise对象就可以了，这样webuploader就会等待此过程，监听此promise的完成事件，自动继续。

以下是此思路的简单实现。
```js
Uploader.register({
    'before-send-file': 'preupload'
}, {
    preupload: function( file ) {
        var me = this,
            owner = this.owner,
            server = me.options.server,
            deferred = WebUploader.Deferred();

        owner.md5File( file.source )

            // 如果读取出错了，则通过reject告诉webuploader文件上传出错。
            .fail(function() {
                deferred.reject();
            })

            // md5值计算完成
            .then(function( md5 ) {

                // 与服务安验证
                $.ajax(server, {
                    dataType: 'json',
                    data: {
                        md5: ret
                    },
                    success: function( response ) {

                        // 如果验证已经上传过
                        if ( response.exist ) {
                            owner.skipFile( file );

                            console.log('文件重复，已跳过');
                        }

                        // 介绍此promise, webuploader接着往下走。
                        deferred.resolve();
                    }
                });
            });

        return deferred.promise();
    }
});
```
关于断点续传
其实就是秒传分片，跟秒传整个文件是一个思路。关于md5验证这块，可以ajax请求验证，也可以在文件秒传验证的时候，把已经成功的分片md5列表拿到，这样分片验证的时候就只需要本地验证就行了，减少请求数。
具体实现和思路请查看这里#139 https://github.com/fex-team/webuploader/issues/139
```js
WebUploader.Uploader.register({
    'before-send': 'checkchunk'
}, {
    checkchunk: function( block ) {
        var blob = block.blob.getSource(),
            deferred = $.Deferred();

        // 这个肯定是异步的，需要通过FileReader读取blob后再算。
        md5Blob( blob, function( error, ret ) {
            // 读取md5出错的话，分片不能跳过。
            if ( error ) {
                deferred.resolve();
            } else {

                // 方案1
                // 将md5结果通过ajax与服务端验证
                $.ajax( xxx ).then(function( response ) {

                    // 更具md5与服务端匹配，如果重复，则跳过。
                    if ( xxx ) {
                        deferred.reject();
                    } else {
                        deferred.resolve();
                    }
                });

                // 方案二
                // 在这个文件上传前，一次性把所有已成功的分片md5拿到。
                // 在这里只需本地验证就ok
                if ( hash[ ret ] ) {
                    deferred.reject();
                } else {
                    deferred.resolve();
                }
            }
        });

        return deferred.promise();
    }
});
```