import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'owl.dart';

int parseInt(String s) {
  return int.parse(s);
}

typedef ChooseImageSucessListener = void Function(
    List<String> pathes, List<dynamic> fileObjects);
typedef ChooseImageFailListener = void Function(dynamic e);
typedef ChooseImageCompleteListener = void Function(dynamic e);

class WeiXinAdapter {
  WeiXinAdapter();

  BuildContext docBuildContext = null;

  void navigateTo(o) {
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

  request(o) {
    var method = o['method'];
    if (method == null) {
      method = 'GET';
    }
    var url = o['url'];
    var data = o['data'];
    Map<String, String> header = o['header'];
    Request req = Request(method, url);
    if (data is String) {
      req.body = data;
    } else {
      req.bodyFields = data;
    }

    Map<String, String> headers = req.headers;
    for (MapEntry<String, String> entry in header.entries) {
      headers[entry.key] = entry.value;
    }

    var client = new Client();
    client.send(req).then((StreamedResponse response) {
      var res = {};
      response.stream.bytesToString().then((String body) {
        var res = {};
        res['data'] = body;
        res['statusCode'] = response.statusCode;
        res['header'] = response.headers;
        o['success'](res);
      }, onError: o['failed']);
    }, onError: o['failed']).whenComplete(o['complete']);
  }

  chooseImage(Map params) {
    int count = params['count'];
    List sizeType = params['sizeType'];
    List sourceType = params['sourceType'];
    ChooseImageSucessListener success = params['success'];
    ChooseImageFailListener fail = params['fail'];
    ChooseImageCompleteListener complete = params['complete'];
  }
}
