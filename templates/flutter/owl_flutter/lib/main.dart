import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:owl_flutter/owl_generated/owl_app.dart';

import './components/owl_home.dart';
import 'owl_generated/owl_route.dart';
import 'utils/owl.dart';

void main() {
  initPageUrls();
  var homeUrl = home_route;
  OwlApp.init();
  appMain(homeUrl);
  /*int index = 0;
  Timer.periodic(Duration(seconds: 3), (timer) {
    if (index == pageUrls.length) {
      index = 0;
    }
    String url = pageUrls[index];
    index++;
    appMain(url);
  });*/
}

void appMain(String url) {
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
      home: homeScreen,
    ));
  }
}
