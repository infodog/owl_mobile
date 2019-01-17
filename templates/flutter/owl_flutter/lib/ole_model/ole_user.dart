import 'package:flutter/material.dart';



class OleUser {
  String memeberLevel;
  String memeberId;
  String cardno;
  String vipName;
  /**
      qq登录的open id
   */
  String qqOpenId;

  /**
      wechat登录的open id
   */
  String weixinOpenId;

  /**
      新浪登录的open id
   */
  String sinaOpenId;

  String account;//账号
  String password;
  String token;
  String uid;

  bool isVip(){
    if(isLogined() == false || memeberLevel == null){
      return false;
    }
    return memeberLevel != "common";

  }
  bool isLogined(){
    return uid==null;
  }




}