# flutter_TikTok
![QQ20191231-184930.gif](https://github.com/CZXBigBrother/flutter_TikTok/blob/master/res/11.gif)

[Flutter 仿抖音效果 (一) 全屏点爱星](https://www.jianshu.com/p/e527aab4fc4b)
[Flutter 仿抖音效果 (二) 界面布局](https://www.jianshu.com/p/f5b75a4bb126)

项目地址:[https://github.com/CZXBigBrother/flutter_TikTok](https://github.com/CZXBigBrother/flutter_TikTok) 持续效果更新

# 实现界面布局效果需要解决的问题
* 1.整体布局实现
* 2.底部歌曲左右移动效果
![Snip20191231_10.png](https://upload-images.jianshu.io/upload_images/3258209-2a5723784d5e1fe2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)
#布局的实现
1.基本的布局是简单的,外层通过Stack作为根
2.左边点赞的控件组通过Align进行统一布局
3.顶部控件组通过Positioned进行布局,设置顶部距离,其实也可以用align,我们多使用几种来习惯flutter的布局
4.底部同样使用Positioned,设置底部距离
5.子页面的左右滑动使用PageView,一开始我们要从推荐开始左滑到关注,可以使用reverse属性,不需要更多额外的操作
#细节实现 
1.pageController监听
```
PageController pageController = new PageController(keepPage: false);
pageController.addListener(() {
      // print(pageController.page);
      if (pageController.page == 1) {
        this.stream.sink.add(1);
      } else if (pageController.page == 0) {
        this.stream.sink.add(0);
      }
    });
```
刷新顶部的下划线时,我们一样使用StreamController刷新,这样效率比setstate高很多
```
  StreamController<int> stream = new StreamController.broadcast();
  StreamBuilder<int>(
                  initialData: 0,
                  builder: (context, snapshot) {
                    return Text(
                      "推荐",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: snapshot.data == 0
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    );
                  },
                  stream: this.stream.stream,
                )
```
2.歌曲名走马灯效果

![111.gif](https://github.com/CZXBigBrother/flutter_TikTok/blob/master/res/111.gif)
这个效果看起来挺麻烦的其实实现起来超级的简单用最普通的ListView就能快速的实现
首页listview里面套入的是最简单的container+text
```
Container(
      // color: Colors.red,
      // alignment: Alignment.centerLeft,
      child: Text(
        "三根皮带歌曲,哗啦啦啦啦啦啦啦啦啦啦啦",
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    )
```
listview添加一个ScrollController做为滑动的控制
```
  ScrollController scroController = new ScrollController();
```
使用一个定时器,把listview滑到最大的位置之后,在滑回去
先通过scroController.position.maxScrollExtent获取最大位置,
然后通过scroController.animateTo进行滑动,因为我设置一次循环的时间是3000毫秒,所以滑过去和滑回来的时间各占一般 new Duration(milliseconds: (time * 0.5).toInt()),还有就是歌名没有大于最大宽度时候其实我们不需要进行滑动,所以判断maxScrollExtent是否大于0来确定是否进行滑动动画
```
Timer timer;
  void startTimer() {
    int time = 3000;
    timer = Timer.periodic(new Duration(milliseconds: time), (timer) {
      if (scroController.positions.isNotEmpty == false) {
        print('界面被销毁');
        return;
      }
      double maxScrollExtent = scroController.position.maxScrollExtent;
      // print(maxScrollExtent);
      // double pixels = scroController.position.pixels;
      if (maxScrollExtent > 0) {
        scroController.animateTo(maxScrollExtent,
            duration: new Duration(milliseconds: (time * 0.5).toInt()),
            curve: Curves.linear);
        Future.delayed(Duration(milliseconds: (time * 0.5).toInt()), () {
          if (scroController.positions.isNotEmpty == true) {
            scroController.animateTo(0,
                duration: new Duration(milliseconds: (time * 0.5).toInt()),
                curve: Curves.linear);
          }
        });
      } else {
        print('不需要移动');
        timer.cancel();
      }
    });
  }
```















