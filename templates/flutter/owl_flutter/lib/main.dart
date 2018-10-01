import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'owl_generated/owl_route.dart';
import 'utils/owl.dart';

void main() {
  var homeUrl = home_route;
  debugPaintSizeEnabled = true;
  Widget homeScreen = getScreen(homeUrl, {}, owl.getApplication().appCss);
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: homeScreen,
  ));
}
