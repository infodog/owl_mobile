import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/owl_home.dart';
import '../utils/owl.dart';
import 'owl_route.dart';

class OwlApp {
  OwlApp() {
    appJson = __appJson;
    appCss = __appCss;
  }

  Map<String, dynamic> appJson;
  Map<String, dynamic> appCss;
  List<String> pages;

  App(o) {
    this.appObject = o;
  }

  var appObject;

  init_app_object() {
    __appJs;
  }

  navigateTo(var obj, BuildContext context) {
    String url = obj['url'];
    if (url.startsWith("/")) {
      url = url.substring(1);
    }

    int pos = url.indexOf("?");
    Map params = {};
    if (pos > 0) {
      String queryString = url.substring(pos + 1);
      String path = url.substring(0, pos);
      url = path;
      //parse queryString

      List<String> paramPairs = queryString.split("&");
      for (int i = 0; i < paramPairs.length; i++) {
        String paramPair = paramPairs[i];
        List<String> kv = paramPair.split("=");
        if (kv.length == 2) {
          params[kv[0]] = kv[1];
        }
      }
    }
    //检查url是否属于tabs, 如果属于则不跳转
    var tabBar = owl.getApplication().appJson['tabBar'];
    if (tabBar == null) {
      return null;
    }
    var list = tabBar['list'];

    for (int i = 0; i < list.length; i++) {
      var tab = list[i];
      var pagePath = tab['pagePath'];
      if (pagePath == url) {
        print(pagePath + " is one of the tab, use wx.switchTab instead");
        return null;
      }
    }

    Widget screen = getScreen(url, params, appCss);
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  switchTab(var obj, BuildContext context) {
    String url = obj['url'];
    if (url.startsWith("/")) {
      url = url.substring(1);
    }

    //判断url是否属于某个tab
    var tabBar = appJson['tabBar'];
    if (tabBar == null) {
      return null;
    }

    var list = tabBar['list'];
    if (list == null) {
      return null;
    }
    var currentIndex = -1;

    for (int i = 0; i < list.length; i++) {
      var item = list[i];
      if (item['pagePath'] == url) {
        currentIndex = i;
      }
    }
    if (currentIndex == -1) {
      return null;
    }

    int pos = url.indexOf("?");
    Map params = {};
    if (pos > 0) {
      String queryString = url.substring(pos + 1);
      String path = url.substring(0, pos);
      url = path;
      //parse queryString

      List<String> paramPairs = queryString.split("&");
      for (int i = 0; i < paramPairs.length; i++) {
        String paramPair = paramPairs[i];
        List<String> kv = paramPair.split("=");
        if (kv.length == 2) {
          params[kv[0]] = kv[1];
        }
      }
    }

    Widget screen = OwlHome(url, params);
    if (screen != null) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(builder: (context) => screen),
      );
    }
  }
}

class NoAnimationRoute<T> extends MaterialPageRoute<T> {
  NoAnimationRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
//    return new FadeTransition(opacity: animation, child: child);
    return child;
  }
}
