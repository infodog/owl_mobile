import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/components/owl_home.dart';
import 'package:owl_flutter/owl_generated/owl_route.dart';
import 'package:owl_flutter/pageJump/page_jumpper.dart';

import '../owl_generated/owl_app.dart';

class owl {
  static void login(app) {}

  static void getUserInfo(app, page) {}

  static bool canIUse(buttonName) {
    return true;
  }

  static bool isHomeTabUrl(url) {
    var tabBar = owl.getApplication().appJson['tabBar'];
    if (tabBar == null) {
      return false;
    }

    var list = tabBar['list'];

    if (list == null) {
      return false;
    }
    for (int i = 0; i < list.length; i++) {
      var item = list[i];
      if (url == item['pagePath']) {
        return true;
      }
    }
    return false;
  }

  static OwlApp owlapp = OwlApp();
  static OwlApp getApplication() {
    return owlapp;
  }

  static void navigateTo(var obj, BuildContext context) {
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
    if (tabBar != null) {
      var list = tabBar['list'];

      for (int i = 0; i < list.length; i++) {
        var tab = list[i];
        var pagePath = tab['pagePath'];
        if (pagePath == url) {
          print(pagePath + " is one of the tab, use wx.switchTab instead");
          return null;
        }
      }
    }

    Map  map = Map();
    map["pageType"] = "flutter/"+url;
    //map["naviBarHidden"] ='1';
    PageJumpper.notityNativePush(map,context: context);


//    print("navigating to $url, params=$params");
//    Widget screen = getScreen(url, params, owl.getApplication().appCss);
//    if (screen != null) {
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => screen),
//      );
//    }
  }

  static void switchTab(var obj, BuildContext context) {
    String url = obj['url'];
    if (url.startsWith("/")) {
      url = url.substring(1);
    }

    //判断url是否属于某个tab
    var tabBar = owl.getApplication().appJson['tabBar'];
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
      PageJumpper.notityNativeReplacementPush((context) => screen);

    }
  }

  static void navigateBack(var obj, BuildContext context) {
    int delta = obj['delta'];
    for (int i = 0; i < delta; i++) {
//      Navigator.pop(context);
        PageJumpper.notityNativePop();
    }
  }

  static void addToList(arr, elem) {
    arr.add(elem);
  }

  static void removeFromList(arr, index) {
    arr.removeAt(index);
  }

  static void insert(arr, index, elem) {
    arr.insert(index, elem);
  }

  static bool containsKey(map, String key) {
    return map.containsKey(key);
  }
}
