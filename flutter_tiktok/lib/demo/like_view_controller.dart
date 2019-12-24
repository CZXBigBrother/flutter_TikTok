import 'package:flutter/material.dart';
import 'dart:math' as math;

class LikeViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LikeViewControllerState();
  }
}

class LikeViewControllerState extends State<LikeViewController> {
  var touchTime = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTapUp: (TapUpDetails details) {
          var t = new DateTime.now().millisecondsSinceEpoch -
              this.touchTime.millisecondsSinceEpoch;
          this.touchTime = new DateTime.now();
          if (t < 300) {
            this.touchTime = new DateTime.fromMicrosecondsSinceEpoch(0);
            print("---onTapUp start---");
            print(t);
            print(details.localPosition.dx);
            print(details.localPosition.dy);
            this.showLike(details.localPosition.dx, details.localPosition.dy);
            print("---onTapUp end---");
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
    print("onDoubleTap");
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
          0, 1.0, 
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
          0, 1.0, 
          curve: Curves.ease,
        ),
      ),
    );
    // 动画二组
    display = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0, 1.0, 
          curve: Curves.ease,
        ),
      ),
    );
    scaleAnimate2 = Tween<double>(
      begin: 1,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0, 1.0,
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
