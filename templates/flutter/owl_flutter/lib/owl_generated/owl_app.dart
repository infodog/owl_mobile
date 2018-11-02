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
