
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:owl_flutter/pageJump/ole_network.dart';
import 'package:owl_flutter/utils/DataHandler.dart';

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
    var sign = "1c76e21f733cf731d35a18065ac41d24";
    var appToken = "27e3002a7d299b78ee99a02087831cdb";
    var serialNo = "d42sa5af-9b78-6320-9a79-327cb00ea561";
    var signMethod = "MD5";
    String data_json = data.toString();
    Map<String,dynamic> o = {
      "REQUEST_ATTRS": {
        "Api_ID": apiId,
        "App_Token": appToken,
        "signMethod": signMethod,
        "Time_Stamp": Time_Stamp,
        "Sign": hexMD5('Api_ID=$apiId&App_Token=$appToken&REQUEST_DATA=$data_json&Serial_No=$serialNo&Sign_Method=$signMethod&Time_Stamp=$Time_Stamp&$sign').toString().toUpperCase(),
        "Serial_No": serialNo
      },
      "REQUEST_DATA":data,
    };

    try{
      Dio dio = new Dio();
      Map<String, dynamic> header = {};
      DataHandler dataHandler = new DataHandler();
      String sessionId = await dataHandler.getSession();
      if(requestData['header'] != null && requestData['header'] is Map<String,dynamic>){
        header = requestData['header'];
      }
      if(sessionId != null){
        header['sessionId'] = sessionId;
      }
      dio.options.headers =header;
      String baseUrl = "http://o2otrue.crv.com.cn/api/rest";
      Response response;
      response =  await dio.post(baseUrl, data:o);
      var res = {};
      res['data'] = response.data;
      res['statusCode'] = response.statusCode;
      res['header'] = response.headers;
      if (response.statusCode == 200) {
        if(apiId == 'crv.ole.user.login' && res['data']['RETURN_DATA']['sessionId'] != null){
          String session = res['data']['RETURN_DATA']['sessionId'];
          dataHandler.setSession(session);
        }
        if(res['data']['RETURN_CODE'] == "E1M000003"){
          //todo
          //跳到登录页
          print("还没登录！！！");
        }
        callback(res);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        print(e.message);
      }
    }

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