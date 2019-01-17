import 'package:flutter/material.dart';
class OleDeviceInfo {
  static String name = "unknow";
  static String platform = "unknow";//Android or ios
  static String osVersion = "unknow";

  //portrait 竖向值
  static double statusBarHeight = 0.0;
  static double naviBarHeight = 0.0;
  static double tabBarHeight = 0.0;
  static double safeAreaTop = 0.0;
  static double safeAreaBottom = 0.0;

  static List<State> _listners = [];

  static void addListner(State widget){
      _listners.add(widget);
  }
  static void removeListner(State widget){
    _listners.remove(widget);
  }
  static notifyUpdate(){
    print("===updateing===${_listners}====");

    for(State wi in _listners){
        wi.setState((){});
    }
  }


  // 横向值 暂时oleapp不支持横向,所以暂时不写


  static bool isAndroid(){
     return platform != null && platform.toLowerCase() == "android";
  }
  static bool isIOS(){
    return platform != null && platform.toLowerCase() == "ios";
  }

  static double bottomMargin(){
    return safeAreaBottom + tabBarHeight;
  }



}