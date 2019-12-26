import 'package:flutter/material.dart';
import 'dart:math' as math;

class MathPoint {
  MathPoint(this.x, this.y);
  distanceTo(other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  var x, y;
}

class LikeViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LikeViewControllerState();
  }
}

class LikeViewControllerState extends State<LikeViewController> {
  // 记录时间
  var touchTime = new DateTime.now();
  // 记录坐标
  var touchPoint = new MathPoint(-999, -999);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("like pop demo"),
      ),
      body: GestureDetector(
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
            this.showLike(details.localPosition.dx, details.localPosition.dy);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/love.jpeg',
                width: 100,
                height: 100,
              ),
              Text("double click")
            ],
          ),
        ),
      ),
    );
  }

  void showLike(double dx, double dy) {
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
  }
}

class LikeView extends StatefulWidget {
  LikeView({Key key, this.overlayEntry});
  OverlayEntry overlayEntry;
  @override
  State<StatefulWidget> createState() {
    return LikeViewState();
  }
}

class LikeViewState extends State<LikeView> with TickerProviderStateMixin {
  int step = 0;
  double width = 50;
  double height = 50;
  AnimationController controller;
  Animation<EdgeInsets> upLocation;

  Animation<double> display;
  Animation<double> scaleAnimate;
  Animation<double> scaleAnimate2;

  @override
  void initState() {
    super.initState();
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
    // 动画二组
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
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    if (this.step == 0) {
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
    } else if (this.step == 1) {
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
    }
  }
}
