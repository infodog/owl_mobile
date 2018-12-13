import 'package:flutter/services.dart';
import 'dart:async';
import 'ole_const.dart';
import "../ole_model/ole_method_channel.dart";
import '../ole_model/ole_share_model.dart';
class OleNetWork{


  static int _requestID = 0;
  static OleMethodChannel _methodChannel =  OleMethodChannel(OleConsts.CHANNEL_NETWORK,handler:methodCallBack);
  static OleMethodChannel channel(){
    return _methodChannel;
  }

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
           _requestStack.remove(func);
      }
    }else if(call.method == OleConsts.METHOD_PAYMENT){
      //支付数据
      Map  result = call.arguments;

      String rid = result["params"][_networkidPrefix()];
      Function func = _requestStack[rid];
      if(func !=null){
        print("find callback");
        func(result["errMsg"]);
        _requestStack.remove(func);
      }
    }else if(call.method == OleConsts.METHOD_SHARE_VENDOR){
      //第三方分享
      Map  result = call.arguments;

      String rid = result["params"][_networkidPrefix()];
      Function func = _requestStack[rid];
      if(func !=null){
        print("find callback");
        func(result["errMsg"],result["platform"]);
        _requestStack.remove(func);
      }
    }
  }

  static String _networkidPrefix(){
    return "__flutter_network_id";
  }

  static Map wrapedParams(String api,Map params){
    _requestID++;
    _methodChannel.setMethodCallHandler(methodCallBack);


    if(params == null) {
      params = {};
    }
    params["apiId"] = api;
    String key = "${_networkidPrefix()}_${_requestID}";
    //把这个key 加到网络请求里去,原生端请勿删除此参数
    params[_networkidPrefix()] = key;
    return params;
  }

  static void shareModel(OleShareModel model,{Function onResult(String errorMsg,String platform)}){
    if(model == null){
      return;
    }
    Map params = wrapedParams("ole_api_share_vendor_platform",model.toMap());
    String key = params[_networkidPrefix()];

    if(onResult !=null){
      _requestStack[key] = onResult ;
    }

    _methodChannel.invokeMethod(OleConsts.METHOD_SHARE_VENDOR,params);
  }

  //如果errorMsg为空,则说明成功
  static void payOrder(String orderId,[Function onResult(String errorMsg)]){

    Map params = wrapedParams(orderId,{});
    String key = params[_networkidPrefix()];

    if(onResult !=null){
      _requestStack[key] = onResult;
    }

    _methodChannel.invokeMethod(OleConsts.METHOD_PAYMENT,params);
  }
  static void request(String api,Map params,[Function onResult(Map result)]){



     params = wrapedParams(api,params);
     String key = params[_networkidPrefix()];

     if(onResult !=null){
       _requestStack[key] = onResult ;
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