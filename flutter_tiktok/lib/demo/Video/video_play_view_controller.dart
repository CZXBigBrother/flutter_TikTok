import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tiktok/demo/Layout/View/right_view.dart';
import 'package:flutter_tiktok/service/event_bus_service.dart';
import 'package:flutter_tiktok/service/screen_service.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
  String image;
  final int positionTag;
  String video;

  VideoController({Key key, this.image, this.positionTag, this.video})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ViewControllerState();
  }
}

class ViewControllerState extends State<VideoController> {
  ScrollController scroController = new ScrollController();
  Timer timer;
  bool videoPrepared = false; //视频是否初始化
  bool _hideActionButton = true;
  VideoPlayerController _controller;

  static double h = Platform.isAndroid
      ? (16 / 9 * ScreenService.width - ScreenService.topSafeHeight <=
              ScreenService.height
          ? 16 / 9 * ScreenService.width - ScreenService.topSafeHeight
          : ScreenService.height)
      : (16 / 9 * ScreenService.width <= ScreenService.height
          ? 16 / 9 * ScreenService.width
          : ScreenService.height);
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
    _controller = VideoPlayerController.asset(widget.video)
      ..initialize().then((_) {})
      ..setLooping(true).then((_) {
        if (widget.positionTag == 0) {
          _controller.play();
          videoPrepared = true;
        } else {
          videoPrepared = false;
        }
        setState(() {});
      });

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
  }

  @override
  void dispose() {
    this.scroController.dispose();
    this.timer.cancel();
    _controller.dispose(); //释放播放器资源

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object_build");
    return getVideoViewMain();
  }

  Widget getVideoViewMain() {
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
  }

  getPauseView() {
    return Offstage(
      offstage: _hideActionButton,
      child: Stack(
        children: <Widget>[
          Align(
            child: Container(
                child: Image.asset('assets/images/ic_playing.png'),
                height: 50,
                width: 50),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

  Widget getPreviewImg() {
    // var url;
    // HttpController.host.then((onValue) {
    //   url = onValue + widget.previewImgUrl;
    // });
    return Offstage(
        offstage: videoPrepared,
        child: Container(
          color: Colors.black,
          margin: EdgeInsets.only(top: ScreenService.topSafeHeight),
          child: Image.asset(
            widget.image,
            // getUrl(widget.previewImgUrl),
            fit: BoxFit.fill,
            width: ScreenService.width,
            height: ScreenService.height,
          ),
        ));
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
