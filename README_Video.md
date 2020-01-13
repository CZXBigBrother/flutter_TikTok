![3.gif](https://upload-images.jianshu.io/upload_images/3258209-1788c1d5e28a8e35.gif?imageMogr2/auto-orient/strip)
[Flutter 仿抖音效果 (一) 全屏点爱星](https://www.jianshu.com/p/e527aab4fc4b)
[Flutter 仿抖音效果 (二) 界面布局](https://www.jianshu.com/p/f5b75a4bb126)


项目地址:[https://github.com/CZXBigBrother/flutter_TikTok](https://github.com/CZXBigBrother/flutter_TikTok) 持续效果更新
# 实现抖音视频播放列表需要解决的问题
* 1.视频播放
* 2.切换时开始和停止视频的播放

# 视频播放
视频播放实际实现是非常简单的只用使用VideoPlayerController就能快速的接入
```
video_player: ^0.10.1+5
```
使用到的API
```
  /// finished.
  Future<void> play() async {
  /// Sets whether or not the video should loop after playing once. See also
  /// [VideoPlayerValue.isLooping].
  Future<void> setLooping(bool looping) async 
  /// Pauses the video.
  Future<void> pause() async 
```
![Snip20200113_2.png](https://upload-images.jianshu.io/upload_images/3258209-9966d301b79dd8be.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
加载完成前,使用第一帧的图片作为预留图,加载完成之后,隐藏预览图,保证短视频加载缓慢是不会出现黑屏的情况 ,播放按键和预留图都通过stack布局的方式进行.
```
return Stack(
      children: <Widget>[
        GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: ScreenService.topSafeHeight),
                  width: ScreenService.width,
                  height: h, //h/w = sh/sw
                  child: VideoPlayer(_controller),
                ),
                getPauseView()
              ],
            ),
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
                _hideActionButton = false;
              } else {
                _controller.play();
                videoPrepared = true;
                _hideActionButton = true;
              }
              setState(() {});
            }),
        // this.getVideo(),
        getPreviewImg(),
        getLikesView(),
        this.getUserAndTitle()
      ],
    );
```
# 上下切换列表 
使用Swiper 
```
 body: Container(
        child: Swiper(
          autoStart: false,
          circular: false,
          direction: Axis.vertical,
          children: children,
          controller: _controller,
        ),
        color: Colors.black,
      ),
```
# 切换时开始和停止视频的播放
添加 SwiperController监听
```
  SwiperController _controller = SwiperController();
```
初始化时 我们会使用
```
会标记 一个tag值用来判断当前队列的编号
```
然后在当滑动到某个视频时通知开始播放
```
    _controller.addListener(() {
      if (_controller.page.floor() == _controller.page) {
        eventBus.emit(keyPlayVideo + _controller.page.floor().toString(),
            _controller.page.floor());
      }
    });
```
这里会用到一个东西就是eventBus.这个和iOS 的KVO 差不多的意思.添加监听的KEY 然后注册接受.内部存储里一个事件的队列.发送通知是会执行所有的接受者
在视频controller中注册监听eventBus
```
    eventBus.on(keyPlayVideo + widget.positionTag.toString(), (arg) {
      if (arg == widget.positionTag) {
        _controller.play();
        videoPrepared = true;
        _hideActionButton = true;
      } else {
        _controller.pause();
        _hideActionButton = false;
      }
      setState(() {});
    });
```
在dispose的时候必须移除eventBus 和 等等的Controller,否则会报错
```
  @override
  void dispose() {
    this.scroController.dispose();
    this.timer.cancel();
    _controller.dispose(); //释放播放器资源

    super.dispose();
  }

```
