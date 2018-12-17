
import 'package:owl_flutter/utils/openApi_util.dart';

void login (){
  String loginApiId = "crv.ole.user.login";
  var loginId = "13866866868";
  var password = "123456";
  var data ={
    "data":{
      "loginId": loginId,
      "password": password
    }
  };
  OpenApi.request(loginApiId,data,(res){
    print(res['data'].toString());
  });
}