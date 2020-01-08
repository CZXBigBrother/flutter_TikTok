import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/demo/Video/video_play_view_controller.dart';
// import 'package:flutter_tiktok/demo/Layout/View/video_controller.dart';

class VideoViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoViewControllerState();
  }
}

class VideoViewControllerState extends State<VideoViewController> {
  SwiperController _controller = SwiperController();
  List images = ["assets/images/vides.png", "assets/images/vides2.png"];

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (String item in this.images) {
      children.add(VideoController(
        image: item,
      ));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("video controller"),
      // ),
      body: Container(
        child: Swiper(
          autoStart: false,
          circular: false,
          direction: Axis.vertical,
          children: children,
          controller: _controller,
        ),
      ),
    );
  }
}
