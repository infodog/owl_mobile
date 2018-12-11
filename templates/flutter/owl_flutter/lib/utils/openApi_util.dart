import 'package:http/http.dart' as http;
import 'dart:convert';
class OpenApi{

  static request(String apiId, Map<String,dynamic> o, [Function callback]) async{
    var client = new http.Client();
    var baseUrl = "http://o2otrue.crv.com.cn/api/rest";
    var method ="";
    String sessionId = "";
    Map<String,String> headers = {"sessionId":sessionId};
    Map data = {};
    var res={};
    try{
      http.Response response;
      if (method == "GET") {
        response = await client.get(baseUrl);
      } else {
        response = await client.post(baseUrl, body: data,headers:headers);
        if (response.statusCode == 200) {
          String body = response.body.toString();
          res['data'] = jsonDecode(body);
          res['statusCode'] = response.statusCode;
          res['header'] = response.headers;
          if (o['success'] != null && o['success'] is Function) {
            o['success'](res);
          }
        } else {
          res['data'] = 'error code : ${response.statusCode}';
          if (o['failed'] != null && o['failed'] is Function) {
            o['failed'](res);
          }
        }
      }

    }catch(e){
      res['data'] = '网络异常';
      if (o['complete'] != null && o['complete'] is Function) {
        o['complete'](res);
      }
    }
  }
}