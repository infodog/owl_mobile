import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:multi_image_picker/picker.dart';
import 'package:owl_flutter/components/owl_image_scroll_gallery.dart';
import 'package:owl_flutter/model/ScreenModel.dart';
import 'package:owl_flutter/utils/asset_image_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'owl.dart';

typedef OnTextChange = void Function(String text);

class LoadingTextProvider {
  OnTextChange onChange;
}

class LoadingText extends StatefulWidget {
  LoadingText(this.title, this.loadingTextProvider);

  String title;
  Listenable listenable;
  LoadingTextProvider loadingTextProvider;

  @override
  LoadingTextState createState() {
    return LoadingTextState();
  }
}

class LoadingTextState extends State<LoadingText> {
  String title;

  initState() {
    super.initState();
    this.title = widget.title;
    widget.loadingTextProvider.onChange = _onChange;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead, child: Text(title));
  }

  void _onChange(String text) {
    this.setState(() {
      this.title = text;
    });
  }
}

int parseInt(String s) {
  return int.parse(s);
}

typedef ChooseImageSucessListener = void Function(dynamic e);
typedef ChooseImageFailListener = void Function(dynamic e);
typedef ChooseImageCompleteListener = void Function(dynamic e);

class WeiXinAdapter {
  WeiXinAdapter({this.model});
  ScreenModel model;
  BuildContext docBuildContext = null;
  LoadingTextProvider loadingTextProvider = new LoadingTextProvider();

  void navigateTo(o) {
    print("owl navigate, $o");
    Owl.navigateTo(o, docBuildContext);
  }

  void switchTab(o) {
    Owl.switchTab(o, docBuildContext);
  }

  void showToast(o) {
    String title = o['title'];
    int duration = o['duration'];
    if (duration == null) {
      duration = 2000;
    }
    final snackBar = SnackBar(
      content: Text(title),
      duration: Duration(milliseconds: duration),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(docBuildContext).showSnackBar(snackBar);
  }

  void navigateBack(o) {
    Owl.navigateBack(o, docBuildContext);
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
    if (header != null) {
      dio.options.headers = header;
    }

    try {
      if (method == 'GET') {
        response = await dio.get(url);
      } else {
        if (header != null) {
          String contentType = header['Content-Type'];
          dio.options.contentType = ContentType.parse(contentType);
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
    Map<dynamic, dynamic> formData =
        object['formData']; //Object		否	HTTP 请求中其他额外的 form data
    dynamic success = object['success']; //	function		否	接口调用成功的回调函数
    dynamic fail = object['fail']; //	function		否	接口调用失败的回调函数
    dynamic complete =
        object['complete']; //	function		否	接口调用结束的回调函数（调用成功、失败都会执行）
    if (formData == null) {
      formData = {};
    }
    try {
      if (filePathOrAsset is Asset) {
        Asset _asset = filePathOrAsset;
        await _asset.requestOriginal(quality: 80);
        formData[name] = new UploadFileInfo.fromBytes(
            _asset.imageData.buffer.asUint8List(), name);
        var dio = new Dio();
        if (header != null) {
          dio.options.headers = header;
        }

        Map<String, dynamic> params = {};
        if (formData != null) {
          for (var key in formData.keys) {
            if (key is String) {
              params[key] = formData[key];
            }
          }
        }
        FormData dioFormData = new FormData.from(params);
        Response response = await dio.post(url, data: dioFormData);
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
        print(e);
      }
      if (fail != null) {
        print("upload failed");
        fail({'msg': "upload failed"});
      }
      return;
    } finally {
      if (complete != null) {
        complete({});
      }
    }
  }

  bool loading = false;

  void showLoading(Map params) {
    String title = params["title"];
    if (!loading) {
      loading = true;
      showCupertinoDialog(
          context: docBuildContext,
          builder: (BuildContext ctx) => CupertinoAlertDialog(
              content: Container(
                  alignment: Alignment.center,
                  child: LoadingText(title, loadingTextProvider))));
    } else {
      loadingTextProvider.onChange(title);
    }
  }

  void hideLoading(Map params) {
    loading = false;
    loadingTextProvider.onChange = null;
    Navigator.pop(docBuildContext);
  }

  void stopPullDownRefresh() {
    model.refreshController.sendBack(true, RefreshStatus.completed);
  }

  void startPullDownRefresh() {
    if (model.pageJs != null) {
      var onRefresh = model.pageJs["onPullDownRefresh"];
      if (onRefresh != null) {
        model.refreshController.sendBack(true, RefreshStatus.refreshing);
        onRefresh();
      }
    }
  }

  void previewImage(Map params) {
    var urls = params["urls"];
    List<ImageProvider> imgs = [];
    for (int i = 0; i < urls.length; i++) {
      var url = urls[i];
      if (url is Asset) {
        Asset _asset = url as Asset;
        ImagePickerAssetImage img = ImagePickerAssetImage(asset: _asset);
        imgs.add(img);
      } else if (url is String) {
        if (url.startsWith("http")) {
          NetworkImage img = NetworkImage(url);
          imgs.add(img);
        } else if (url.startsWith("file")) {
          FileImage img = FileImage(File(url));
          imgs.add(img);
        } else {
          AssetImage img = AssetImage(url);
          imgs.add(img);
        }
      }
    }
    OwlImageScrollGallery gallery = OwlImageScrollGallery(images: imgs);

    Navigator.push(
      docBuildContext,
      MaterialPageRoute(builder: (context) => gallery),
    );
  }
}
