import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    Widget screen = getScreen(url, {}, appCss);
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }
}
