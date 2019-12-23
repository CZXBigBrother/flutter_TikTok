import 'package:flutter/cupertino.dart';

NavigationService navigationService = NavigationService();

class NavigationService {
  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }
  GlobalKey<NavigatorState> navigatorKey;

  Future<T> navigateTo<T>(Route<T> route) {
    return navigatorKey.currentState.push<T>(route);
  }

  bool goBack() {
    return navigatorKey.currentState.pop();
  }

  Future cNavigateTo(Widget controller) {
    return navigationService.navigateTo(CupertinoPageRoute(
      builder: (context) => controller,
    ));
  }
  // Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) => new SHController()));
}
