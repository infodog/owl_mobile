import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'ole_page.dart';
class OleRoute extends MaterialPageRoute {//PageRouteBuilder 可自定义动画

  OlePage page;
  String id = "";
  NavigatorState _navigator;

  OleRoute(OlePage page):super(builder:(_) {return page.flutterPage;}){


    this.page = page;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if(page.animatble == false) return child;
    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }


}