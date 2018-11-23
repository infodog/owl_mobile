import 'package:flutter/material.dart';
class OlePage{
  Widget flutterPage;
  int tag =0;
  String routeName = "";
  bool animatble;
  OlePage(Widget flutterPage,{String routeName,this.animatble = true}){
   this.flutterPage = flutterPage;
    if(routeName !=null){
      this.routeName = routeName;
    }
  }

}