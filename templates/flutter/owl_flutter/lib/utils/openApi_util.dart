
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:owl_flutter/pageJump/ole_network.dart';

import 'wx.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'date_util.dart';
class OpenApi{

  static String hexMD5(String data){
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static request(String apiId, Map<String,dynamic> requestData, Function callback) async{
//    OleNetWork.request(apiId,requestData,callback);

    var data = requestData['data'];
    String Time_Stamp = formatDate(new DateTime.now());
    print("======Time_Stamp====="+Time_Stamp);
    var sign = "1c76e21f733cf731d35a18065ac41d24";
    var appToken = "27e3002a7d299b78ee99a02087831cdb";
    var serialNo = "d42sa5af-9b78-6320-9a79-327cb00ea561";
    var signMethod = "MD5";
    String data_json = data.toString();

    WeiXinAdapter wx = WeiXinAdapter();
    Map<String , dynamic> o = {
      "url": "http://o2otrue.crv.com.cn/api/rest",
      "method": "POST",
      "success":callback,
      "header":requestData['header'],
      "data":{
        "REQUEST_ATTRS": {
          "Api_ID": apiId,
          "App_Token": appToken,
          "signMethod": signMethod,
          "Time_Stamp": Time_Stamp,
          "Sign": hexMD5('Api_ID=$apiId&App_Token=$appToken&REQUEST_DATA=$data_json&Serial_No=$serialNo&Sign_Method=$signMethod&Time_Stamp=$Time_Stamp&$sign').toString().toUpperCase(),
          "Serial_No": serialNo
        },
        "REQUEST_DATA":data,
      }
    };

    wx.request(o);
  }

  static String formatDate(DateTime t){
    return YYYYMMDD(t)+" "+HHMMssSSS(t);
  }

  static guid() {
    return S4() + S4() + '-' + S4() + '-' + S4() + '-' + S4() + '-' + S4() + S4() + S4();
  }

  // 随机生成一个4位字符
  static S4() {
//    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
//    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  }
}