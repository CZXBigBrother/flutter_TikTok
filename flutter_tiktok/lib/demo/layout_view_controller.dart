import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui show window;

import 'package:flutter_tiktok/service/screen_service.dart';

class LayoutViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LayoutViewControllerState();
  }
}

class LayoutViewControllerState extends State<LayoutViewController> {
  AnimationController controller;
  Animation<Offset> textRoll;
  StreamController<int> stream = new StreamController.broadcast();

  PageController pageController = new PageController(keepPage: false);
  @override
  void initState() {
    super.initState();
    pageController
      ..addListener(() {
        // print("pageController.offset = ${pageController.offset}");
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
        this.getLikesView(),
        this.getUserAndTitle()
      ],
    );
  }

  //右边的喜欢 评价 分享
  Widget getLikesView() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/video_icon_praise.png",
                    width: 40,
                    height: 40,
                  ),
                  Text("66.6W", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/video_msg_icon.png",
                    width: 40,
                    height: 40,
                  ),
                  Text("55.6W", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/video_share_icon.png",
                    width: 40,
                    height: 40,
                  ),
                  Text("44.6W", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
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
              width: 150,
              child: new SizedOverflowBox(
                size: Size(100, 11),
                // maxHeight: 30,
                // maxWidth: 150,
                child: AnimatedBuilder(
                  builder: (context, widget) {
                    return Text("112345678765432qw345678976543",
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                        ));
                  },
                  animation: controller,
                ),
              ),
            )
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
