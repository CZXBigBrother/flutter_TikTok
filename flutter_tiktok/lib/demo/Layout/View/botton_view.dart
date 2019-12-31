import 'package:flutter/cupertino.dart';
import 'package:flutter_tiktok/service/screen_service.dart';

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
