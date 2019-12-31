import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/demo/Layout/View/botton_view.dart';
import 'package:flutter_tiktok/demo/Layout/View/right_view.dart';
import 'package:flutter_tiktok/demo/Layout/View/video_controller.dart';
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
  // ScrollController scroController = new ScrollController();
  // Timer timer;
  List images = ["assets/images/vides.png", "assets/images/vides2.png"];
  StreamController<int> stream = new StreamController.broadcast();
  PageController pageController = new PageController(keepPage: false);
  double flage = 0;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      // print(pageController.page);
      if (pageController.page == 1) {
        this.stream.sink.add(1);
      } else if (pageController.page == 0) {
        this.stream.sink.add(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        getBottom(),
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
          return VideoController(
            image: this.images[index],
          );
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
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print('object -- 1');
                  this.stream.sink.add(1);
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
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  this.stream.sink.add(0);
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<StreamController<int>>('stream', stream));
  }
  //----
}
