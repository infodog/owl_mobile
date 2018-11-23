import 'package:flutter/material.dart';
import 'page_jumpper.dart';
import 'dart:convert';
import 'ole_routers.dart';
import 'ole_navigator.dart';
import 'flutter_page2.dart';
import 'ole_network.dart';
import 'ole_device_info.dart';

class _Page1State extends State<Page1>{
  static BuildContext __context;
  void _openNewPage(){

    Map  map = Map();
    String jumpTo = "pages/vip_center/vip_center";//point
    map["pageType"] = "flutter/"+jumpTo;
    //map["naviBarHidden"] ='1';
    PageJumpper.notityNativePush(map);


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    __context = context;
    OleRoutes.globalState = Navigator.of(__context);

    return new Scaffold(
        appBar:null,
        body: Container(child: new MyWidget(),margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,OleDeviceInfo.bottomMargin()),),
        floatingActionButton:Container(
             margin:  EdgeInsets.fromLTRB(0.0,0.0,0.0,OleDeviceInfo.bottomMargin()),
            child: new FloatingActionButton(
            onPressed: _openNewPage,
            child: new Icon(Icons.open_in_new),
            ),
        ));;
  }
}
class Page1 extends StatefulWidget {



  void _requestApi(){
    OleNetWork.request("crv.ole.product.getProductDetails",{"productId":"p_5600694"},(Map result){

      print(result);
      //把这result显示

    });
  }


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    State s = _Page1State();
    OleDeviceInfo.addListner(s);
    return s;
  }




}
class _SomeState extends State<MyWidget> {
  String _text = '我是flutter页面1,点击按钮跳转至flutter的页面2\n点击文字本身,可以网络请求';
  void _requestApi(){
    OleNetWork.showProgress();
    OleNetWork.request("crv.ole.product.getProductDetails",{"productId":"p_5600694"},(Map result){
      print("=======get result=========");
      print(result);
      //把这result显示
      setState(() {
        _text = result.toString();
      });

      OleNetWork.dissmissProgress();

      OleNetWork.toast("网络请求完成");
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    PageJumpper.setUp(context);
    return new Center(
        child:  new GestureDetector(
            onTap: _requestApi,
            child: new Text(_text),
            )
    );
  }
}

class MyWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    State s = new _SomeState();

    return s;
  }


}