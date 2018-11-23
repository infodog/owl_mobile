import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './components/owl_home.dart';
import 'owl_generated/owl_route.dart';
import 'utils/owl.dart';
import 'pageJump/flutter_page1.dart';

void main() {
  initPageUrls();
  Map<String,WidgetBuilder> routes = initRoutes();
  var homeUrl = home_route;
  appMain(homeUrl,routes);
//  int index = 0;
//  Timer.periodic(Duration(seconds: 3), (timer) {
//    if (index == pageUrls.length) {
//      index = 0;
//    }
//    String url = pageUrls[index];
//    index++;
//    appMain(url,routes);
//  });
}

void appMain(String url,Map<String,WidgetBuilder> routes) {
  debugPaintSizeEnabled = false;
//  Widget homeScreen = getScreen(homeUrl, {}, owl.getApplication().appCss);
  if (owl.isHomeTabUrl(url)) {
    runApp(MaterialApp(
      title: 'Owl Applications',
      home: OwlHome(url, {}),
    ));
  } else {
    Widget homeScreen = getScreen(url, {}, owl.getApplication().appCss);
    runApp(MaterialApp(
      title: 'Owl Applications',
      home: new Page1(),
      routes: routes,
    ));
  }
}

Map<String, WidgetBuilder> initRoutes (){
  Map<String,WidgetBuilder> routes = {};
  for(String key in pageUrls){
    Widget w = getScreen(key, {}, owl.getApplication().appCss);
    routes[key] = (ctx){return w;};
  }
  return routes;
}
