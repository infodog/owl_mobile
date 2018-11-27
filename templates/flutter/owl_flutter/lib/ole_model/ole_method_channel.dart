import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class OleMethodChannel extends MethodChannel {
  OleMethodChannel(String name, {Function handler}):super(name){
    if(handler!=null){
      setMethodCallHandler(handler);
    }
  }
  void prepare(){
      //暂时啥也不做,只为能初始化,但是很必要,因为延迟加载的原因,不调用的话,channel并没初始化
  }
}