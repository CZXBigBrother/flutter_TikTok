# flutter_TikTok
![QQ20191224-093618.gif](https://github.com/CZXBigBrother/flutter_TikTok/blob/master/res/QQ20191224-093618.gif)

项目地址:[https://github.com/CZXBigBrother/flutter_TikTok](https://github.com/CZXBigBrother/flutter_TikTok) 持续效果更新
# 实现点爱心的效果需要解决的问题
* 1.onDoubleTap 无法获取到点击的坐标
* 2.flutter 用tree布局的如何将爱心分离出原来StatefulWidget 进行动画和操作
* 3.连贯动画如何实现

# 如何解决flutter原生的double事件没有返回坐标
flutter 有个onTapUp 事件,字面意思就是 点击抬起的,会返回 ```TapUpDetails details```,通过```localPosition```属性就能获取到x,y坐标
计算double 并不复杂,每次点击的时候记录下当前的事件戳,只要两个点击的时间戳和坐标距离小于自己设定的阈值,就可以视为双击事件
###### 代码如下
```
  // 记录时间
  var touchTime = new DateTime.now();
  // 记录坐标
  var touchPoint = new MathPoint(-999, -999);
```
实现双击
```
onTapUp: (TapUpDetails details) {
          // 当前时间-上次记录的时间
          var t = new DateTime.now().millisecondsSinceEpoch -
              this.touchTime.millisecondsSinceEpoch;
          // 获取当前坐标
          var currentPoint =
              new MathPoint(details.localPosition.dx, details.localPosition.dy);
          //计算两次距离
          var distance = currentPoint.distanceTo(this.touchPoint);
          // 记录当前时间
          this.touchTime = new DateTime.now();
          // 记录当前坐标
          this.touchPoint = currentPoint;
          // 判断两次间隔是否小于300毫秒
          if (t < 300 && distance < 20) {
            this.touchTime = new DateTime.fromMicrosecondsSinceEpoch(0);
            // print(details.localPosition.dx);
            // print(details.localPosition.dy);
          }
```
# 如何解决tree布局的如何将爱心分离出
我们使用OverlayEntry 控件,控件详细介绍 [https://www.jianshu.com/p/cc8aab935e11](https://www.jianshu.com/p/cc8aab935e11)
```
var overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    double width = 50;
    double height = 50;
    double x = dx - width / 2;
    double y = dy + height / 2;

    overlayEntry = new OverlayEntry(builder: (context) {
      return Stack(
        children: <Widget>[
          new Positioned(
            left: x,
            top: y,
            child: new LikeView(
              overlayEntry: overlayEntry,
            ),
          ),
        ],
      );
    });
    ///插入全局悬浮控件
    overlayState.insert(overlayEntry);
```
# 连贯动画如何实现
效果一共有 缩小 → 上移 → 放大 → 消失
第一组动画(缩小 上移) → 第二组动画(放大 消失)
flutter 动画需要两个类
AnimationController 负责管理动画
Animation 负责具体值操作
* 分解第一步:缩小
我们设置初始值为1.5倍的大小,然后动画缩回1倍
```
scaleAnimate = Tween<double>(
      begin: 1.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
```
然后通过 Transform.scale 函数的,对scale值进行改变
```
return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
           ..........
            scale: scaleAnimate.value,
          );
        },
        animation: controller,
      );
```
* 分解第二步:上移
我们初始化时候先下20个坐标点,在动画还原到原来的位置,这点很关键,为什么我们不是从0开始下移20个坐标呢,主要是因为动画比较多,我们要将动画分成两次去刷新,如果我们是从0开始往上,我们再第二次动画时候就要手动改变初始化坐标,到上移的20个点,这样我们可以少做一次操作看后面的代码
```
// 向上移动
    upLocation = Tween<EdgeInsets>(
      begin: EdgeInsets.only(top: 20.0),
      end: EdgeInsets.only(top: 0.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
```
补全第一组动画
```
return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            child: Padding(
              padding: upLocation.value,
              child: Image.asset(
                'assets/images/love.jpeg',
                fit: BoxFit.fill,
                width: width,
                height: height,
              ),
            ),
            scale: scaleAnimate.value,
          );
        },
        animation: controller,
      );
```
* 分解第三第四步 放大消失 同理
```
// 消失动画
    display = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    //放大
    scaleAnimate2 = Tween<double>(
      begin: 1,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
```
现实
```
return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            child: Opacity(
              opacity: display.value,
              child: Image.asset(
                'assets/images/love.jpeg',
                fit: BoxFit.fill,
                width: width,
                height: height,
              ),
            ),
            scale: scaleAnimate2.value,
          );
        },
        animation: controller,
      );
```
* 第一组和第二组动画刷新
我们设置一个标签step,通过对AnimationController的监听,我在第一次动画结束时更新step,然后开始第二组动画,当第二组动画结束时 删除对象
```
controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("status is completed");
          if (this.step == 0) {
            this.step = 1;
            controller.reset();
            this.setState(() {});
          } else if (this.step == 1) {
            widget.overlayEntry.remove();
          }
        }
      });
```
![QQ20191224-093618.gif](https://github.com/CZXBigBrother/flutter_TikTok/blob/master/res/QQ20191224-093618.gif)

项目地址:[https://github.com/CZXBigBrother/flutter_TikTok](https://github.com/CZXBigBrother/flutter_TikTok) 持续效果更新





















