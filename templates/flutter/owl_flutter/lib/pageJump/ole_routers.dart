import 'package:flutter/material.dart';
import 'flutter_page1.dart';
import 'flutter_page2.dart';
import 'flutter_page3.dart';
import '../owl_generated/owl_route.dart';
import '../utils/owl.dart';

class OleRoutes{

  static NavigatorState globalState;
  static Map<String, WidgetBuilder> routers = <String, WidgetBuilder> {
  '/page1': (BuildContext context) => new Page1(),
  '/page2': (BuildContext context) => new Page2(),
  '/page3': (BuildContext context) => new Page3(),
  };
}