
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:multi_image_picker/picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'owl.dart';

int parseInt(String s) {
  return int.parse(s);
}

typedef ChooseImageSucessListener = void Function(dynamic e);
typedef ChooseImageFailListener = void Function(dynamic e);
typedef ChooseImageCompleteListener = void Function(dynamic e);

class WeiXinAdapter {
  WeiXinAdapter();

  BuildContext docBuildContext = null;

  void navigateTo(o) {
    print("owl navigate, $o");
    owl.navigateTo(o, docBuildContext);
  }

  void switchTab(o) {
    owl.switchTab(o, docBuildContext);
  }

  void showToast(o) {
    String title = o['title'];
    int duration = o['duration'];
    final snackBar = SnackBar(
      content: Text(title),
      duration: Duration(milliseconds: duration),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(docBuildContext).showSnackBar(snackBar);
  }

  void navigateBack(o) {
    owl.navigateBack(o, docBuildContext);
  }

  request(o) async {
    String method = o['method'];
    if (method == null) {
      method = 'GET';
    }
    method = method.toUpperCase();
    var url = o['url'];
    var data = o['data'];
    Map<String, String> header = o['header'];
    var response;
    var dio = new Dio();
    if(header!=null){
      dio.options.headers = header;
    }
   

    try {
      if (method == 'GET') {
        response = await dio.get(url);
      } else {
        if(header!=null){
          String contentType = header['Content-Type'];
          dio.options.contentType= ContentType.parse(contentType);
        }
        response = await dio.post(url, data: data);
      }
      var res = {};
      res['data'] = response.data;
      res['statusCode'] = response.statusCode;
      res['header'] = response.headers;
      if (o['success'] != null) {
        o['success'](res);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
      if (o['fail'] != null) {
        o['fail']({'msg': e.message});
      }
      return;
    }
  }

  chooseImage(Map params) {
    int count = params['count'];
    List sizeType = params['sizeType'];
    List sourceType = params['sourceType'];
    ChooseImageSucessListener success = params['success'];
    ChooseImageFailListener fail = params['fail'];
    ChooseImageCompleteListener complete = params['complete'];
    Future<List<Asset>> f =
        MultiImagePicker.pickImages(maxImages: count, enableCamera: true);
    f.then((List<Asset> assets) {
      if (success != null) {
        success({"tempFilePaths": assets});
      }
    });
  }

  uploadFile(Map object) async {
    String url = object['url']; //	string		是	开发者服务器地址
    dynamic filePathOrAsset = object['filePath']; //string		是	要上传文件资源的路径
    String name =
        object['name']; //string		是	文件对应的 key，开发者在服务端可以通过这个 key 获取文件的二进制内容
    Map header =
        object['header']; //	Object		否	HTTP 请求 Header，Header 中不能设置 Referer
    Map formData = object['formData']; //Object		否	HTTP 请求中其他额外的 form data
    dynamic success = object['success']; //	function		否	接口调用成功的回调函数
    dynamic fail = object['fail']; //	function		否	接口调用失败的回调函数
    dynamic complete =
        object['complete']; //	function		否	接口调用结束的回调函数（调用成功、失败都会执行）

    try {
      if (filePathOrAsset is Asset) {
        Asset _asset = filePathOrAsset;
        await _asset.requestOriginal(quality:80);
        formData[name] = new UploadFileInfo.fromBytes(
            _asset.imageData.buffer.asUint8List(), name);
        var dio = new Dio();
        if(header!=null){
            dio.options.headers = header;
        }
        Response response = await dio.post(url, data: formData);
        _asset.releaseOriginal();
        var res = {"data": response.data, "statusCode": response.statusCode};
        if (success != null) {
          success(res);
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
      if (fail != null) {
        fail({'msg': e.message});
      }
      return;
    }
    finally{
      if(complete!=null){
        complete({});
      }
    }
  }
}
