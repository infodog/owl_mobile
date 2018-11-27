import 'ole_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import '../pageJump/ole_const.dart';

import 'ole_method_channel.dart';
abstract class UserStateListhner {
  void userUpdated(OleUser user);

}
class OleUserManager {
  static OleUser currentUser = new OleUser();
  static List<UserStateListhner> _listhener = [];

  static OleMethodChannel  _channel =  OleMethodChannel(OleConsts.CHANNEL_USER_ASYNC,handler: methodCallBack);

  static Future<Null> methodCallBack(MethodCall call) async {
      if(OleConsts.METHOD_USER_ASYNC ==  call.method){
        Map info = call.arguments;
        print("=====get user info===");
        print(info);
        print("=====================");
        updateInfo(info);

      }

  }
  static OleMethodChannel channel(){
    return _channel;
  }


  //通知原生,用户退出登录
   static notifyUserLogouted(OleUser user){

   }
  //通知原生,用户登录
  static notifyUserLogined(OleUser user){
    //目前原生端主导登录,暂不用
  }
    //向原生请求用户数据,这是一个异步
  static requestInfoUpdate(){

  }



  static void addStateListner(UserStateListhner state){
    _listhener.add(state);
  }
  static void removeStateListner(UserStateListhner state){
    _listhener.remove(state);
  }

  static void updateInfo(Map info){
    //这里将map的东西更新至this的字段
      currentUser.account = info["account"];
      currentUser.password = info["password"];
      currentUser.uid = info["uid"];

    //通知ui更新
    for(UserStateListhner ls in _listhener){
      ls.userUpdated(currentUser);
    }

  }
  void logOut(){
    currentUser.account = null;
    currentUser.password = null;
    currentUser.uid =null;
    currentUser.token = null;
    notifyUserLogouted(currentUser);
  }

}