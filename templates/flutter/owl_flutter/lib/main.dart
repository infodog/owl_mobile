import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './components/owl_home.dart';
import 'owl_generated/owl_route.dart';
import 'utils/owl.dart';

void main() {
  var homeUrl = home_route;
  debugPaintSizeEnabled = false;
//  Widget homeScreen = getScreen(homeUrl, {}, owl.getApplication().appCss);
  if (owl.isHomeTabUrl(homeUrl)) {
    runApp(MaterialApp(
      title: 'Owl Applications',
      home: OwlHome(homeUrl, {}),
    ));
  } else {
    Widget homeScreen = getScreen(homeUrl, {}, owl.getApplication().appCss);
    runApp(MaterialApp(
      title: 'Owl Applications',
      home: homeScreen,
    ));
  }
}
