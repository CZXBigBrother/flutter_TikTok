import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tiktok/demo/Layout/View/right_view.dart';
import 'package:flutter_tiktok/service/screen_service.dart';

class VideoController extends StatefulWidget {
  String image;
  VideoController({Key key, this.image}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ViewControllerState();
  }
}

class ViewControllerState extends State<VideoController> {
  ScrollController scroController = new ScrollController();
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

  @override
  void initState() {
    super.initState();
    this.startTimer();
  }

  @override
  void dispose() {
    this.scroController.dispose();
    this.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getVideoViewMain();
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
        child: Image.asset(widget.image),
      ),
    );
  }

  Widget getMusicTitle() {
    return Container(
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
              // color: Colors.red,
              // alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              width: 200,
              height: 25,
              child: ListView(
                // reverse: true,
                controller: scroController,
                physics: new NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[this.getMusicTitle()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
