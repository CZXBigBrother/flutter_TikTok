import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/demo/Video/video_play_view_controller.dart';
import 'package:flutter_tiktok/service/widget_ext_service.dart';
// import 'package:flutter_tiktok/demo/Layout/View/video_controller.dart';
import 'package:flutter_tiktok/service/event_bus_service.dart';

class VideoViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoViewControllerState();
  }
}

class VideoViewControllerState extends State<VideoViewController> {
  SwiperController _controller = SwiperController();
  List images = ["assets/images/v1.png", "assets/images/v2.png"];
  List videos = ["assets/videos/1.MP4", "assets/videos/2.mp4"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.page.floor() == _controller.page) {
        eventBus.emit(keyPlayVideo + _controller.page.floor().toString(),
            _controller.page.floor());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int index = 0;
    for (String item in this.images) {
      children.add(VideoController(
          image: item, positionTag: index, video: videos[index]));
      index++;
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
        color: Colors.black,
      ),
    );
  }
}
