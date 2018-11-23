import 'package:flutter/services.dart';
import 'dart:async';
import 'ole_const.dart';

class OleNetWork{


  static int _requestID = 0;
  static MethodChannel _methodChannel =  const MethodChannel(OleConsts.CHANNEL_NETWORK);

  static Map _requestStack = {};


  static Future<Null> methodCallBack(MethodCall call) async {
    //网络请求有返回了
    if(call.method == OleConsts.METHOD_NETWORK){
      print("===net work invoked===");
      Map  result = call.arguments;

      String rid = result["params"][_networkidPrefix()];
      Function func = _requestStack[rid];
      if(func !=null){
           print("find callback");
          func(result);
      }
    }
  }

  static String _networkidPrefix(){
    return "__flutter_network_id";
  }

  static void request(String api,Map params,[Function onResult(Map result)]){


     _requestID++;
     _methodChannel.setMethodCallHandler(methodCallBack);

     params["apiId"] = api;
     if(params == null) {
       params = {};
     }

     if(onResult !=null){
       String key = "${_networkidPrefix()}_${_requestID}";
       _requestStack[key] = onResult ;
       //把这个key 加到网络请求里去,原生端请勿删除此参数
       params[_networkidPrefix()] = key;
     }



     _methodChannel.invokeMethod(OleConsts.METHOD_NETWORK,params);



  }
  static void showProgress([String tip]){
    _methodChannel.invokeMethod(OleConsts.METHOD_PROGRESS_SHOW,tip);
  }
  static void dissmissProgress(){
    _methodChannel.invokeMethod(OleConsts.METHOD_PROGRESS_DISSMISS);
  }

  static void toast(String tip) {
    _methodChannel.invokeMethod(OleConsts.METHOD_TOAST,tip);
  }



}