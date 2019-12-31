import 'package:flutter/material.dart';
import 'package:flutter_tiktok/service/navigation_service.dart';

import 'demo/Layout/layout_view_controller.dart';
import 'demo/like_view_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      title: 'Flutter Tik Tok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Tik Tok Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
          title: Text("like pop demo"),
          onTap: () {
            navigationService.cNavigateTo(new LikeViewController());
          },
        ),
        ListTile(
          title: Text("layout view demo"),
          onTap: () {
            navigationService.cNavigateTo(new LayoutViewController());
          },
        ),
      ]).toList()),
    );
  }
}
