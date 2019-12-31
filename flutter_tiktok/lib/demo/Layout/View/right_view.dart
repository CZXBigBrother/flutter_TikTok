//右边的喜欢 评价 分享
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
