import 'package:owl_flutter/utils/openApi_util.dart';

class Test {
  static test(){
    var loginId = "xinjingtest001";
    var password = "123456";
    var apiId = "crv.ole.user.login";
    var requestData = {
      "data":{
        "loginId": loginId,
        "password": password
      }
    };
    OpenApi.request(apiId, requestData, (res){
      print("res====="+res.toString());
    });
  }
}