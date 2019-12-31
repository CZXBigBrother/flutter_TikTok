import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/demo/Layout/View/right_view.dart';
import 'dart:ui' as ui show window;

import 'package:flutter_tiktok/service/screen_service.dart';

class LayoutViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LayoutViewControllerState();
  }
}

class LayoutViewControllerState extends State<LayoutViewController>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> textRoll;
  Animation<Offset> textRoll2;
  ScrollController scroController = new ScrollController();
  Timer timer;
  StreamController<int> stream = new StreamController.broadcast();
  PageController pageController = new PageController(keepPage: false);
  double flage = 0;
  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // print(this.flage);
          // if (this.flage == 0) {
          //   this.flage = 1;
          //   controller.reverse();
          // } else {
          //   this.flage = 0;
          //   controller.forward();
          // }
        }
      });

    textRoll = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(50, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    textRoll2 = Tween<Offset>(
      begin: Offset(50, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    controller.repeat();

    pageController
      ..addListener(() {
        // print("pageController.offset = ${pageController.offset}");
      });
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(new Duration(milliseconds: 2000), (timer) {
      double maxScrollExtent = scroController.position.maxScrollExtent;
      double pixels = scroController.position.pixels;
      // if (pixels + _moveDistance >= maxScrollExtent) {
      //   position = (maxScrollExtent - screenWidth / 4 + screenWidth) / 2 -
      //       screenWidth +
      //       pixels -
      //       maxScrollExtent;
      //   scroController.jumpTo(position);
      // }
      // position += _moveDistance;
      scroController.animateTo(100,
          duration: new Duration(milliseconds: 1000), curve: Curves.linear);
    });
  }

  List images = ["assets/images/vides.png", "assets/images/vides2.png"];
  @override
  Widget build(BuildContext context) {
    print("build");
    return WillPopScope(
      onWillPop: () {
        return new Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: this.getMain(),
      ),
    );
  }

  Widget getMain() {
    return Stack(
      children: <Widget>[
        this.getScrollView(),
        this.getTitleSwitch(),
        this.getBottom(),
        GestureDetector(
            onTap: () {
              this.setState(() {});
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.red,
              ),
            ))
      ],
    );
  }

  // 滑动
  Widget getScrollView() {
    return Container(
      child: PageView.builder(
        controller: pageController,
        itemCount: images.length,
        reverse: true,
        // physics: PageScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return this.getVideoViewMain();
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  // title switch
  Widget getTitleSwitch() {
    return Positioned(
      top: 50,
      width: ScreenService.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  this.stream.add(1);
                  pageController.jumpToPage(1);
                },
                child: StreamBuilder<int>(
                  initialData: 0,
                  builder: (context, snapshot) {
                    return Text(
                      "关注",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: snapshot.data == 1
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    );
                  },
                  stream: this.stream.stream,
                ),
              ),
              Container(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  this.stream.add(0);
                  pageController.jumpToPage(0);
                },
                child: StreamBuilder<int>(
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
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getVideoViewMain() {
    return Stack(
      children: <Widget>[
        this.getVideo(),
        getLikesView(),
        this.getUserAndTitle()
      ],
    );
  }

  // 视频播放(假的不是重点)
  Widget getVideo() {
    return Container(
      child: Center(
        child: Image.asset(this.images[0]),
      ),
    );
  }

  Widget getBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Color(0x33FFFFFF),
        height: 60,
        width: ScreenService.width,
      ),
    );
  }

  Widget getMusicTitle() {
    return Container(
      child: Text(
        "123456789www54321234567890",
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget getUserAndTitle() {
    return Positioned(
      bottom: 60,
      child: Padding(
        padding: EdgeInsets.only(left: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                "@MarcoChen",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: 250,
              child: Text("外星人来了,你们走不走,996做个毛赶紧辞职吧",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: 200,
              height: 20,
              child: ListView(
                reverse: true,
                controller: scroController,
                physics: new NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[this.getMusicTitle()],
              ),
            )
            // Container(
            //   padding: EdgeInsets.only(bottom: 5),
            //   width: 150,
            //   child: new SizedOverflowBox(
            //     size: Size(150, 11),
            //     // maxHeight: 30,
            //     // maxWidth: 150,
            //     child: AnimatedBuilder(
            //       builder: (context, widget) {
            //         return Transform.translate(
            //           offset: textRoll.value,
            //           child: Transform.translate(
            //             offset: textRoll2.value,
            //             child: Text("112345678765432qw345678976543",
            //                 maxLines: 1,
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                 )),
            //           ),
            //         );
            //       },
            //       animation: controller,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  //----
}

//  Container(
//               child: Center(
//                 child: Image.asset("assets/images/vides.png"),
//               ),
//               // color: Colors.red,
//             ),
//             Container(
//               child: Center(
//                 child: Image.asset("assets/images/vides2.png"),
//               ),
