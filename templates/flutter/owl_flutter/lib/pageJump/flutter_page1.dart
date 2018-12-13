import 'package:flutter/material.dart';
import 'package:owl_flutter/owl_generated/owl_route.dart';
import 'page_jumpper.dart';
import 'dart:convert';
import 'ole_routers.dart';
import 'ole_navigator.dart';
import 'flutter_page2.dart';
import 'ole_network.dart';
import 'ole_device_info.dart';
import "../ole_model/ole_share_model.dart";
class _Page1State extends State<Page1>{
  static BuildContext __context;
  void _openNewPage(){

    Map  map = Map();
//      String jumpTo = "pages/vip_center/vip_center";//point
    String jumpTo = home_route;//point
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
  TextEditingController _controller= new TextEditingController();
  FocusNode _node = new FocusNode();
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

  void _editingEnd(){
    _node.unfocus();
  }
  void _payOrder() {

    String text = _controller.text;
    if(text.length <5){
      OleNetWork.toast("订单号不合法");
      return;
    }
    OleNetWork.payOrder(text);
  }
  void _shareVendor(){
    OleShareModel model = OleShareModel();
    model.title = "测试分享";
    model.detail = "我在分享";
    model.imageURL = "www.baidu.com";
    model.redirectURL = "www.baidu.com";
    OleNetWork.shareModel(model,onResult: (errMsg,platform){
      print("====share completion ${errMsg}== ${platform}===");
      if(errMsg != null){

      }else{

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    PageJumpper.setUp(context);





    Widget field = new Container(
        margin: EdgeInsets.all(50),
        child:new TextField(
            controller: _controller,
            focusNode: _node,
            onEditingComplete: _editingEnd ,
            decoration: new InputDecoration(
                hintText: "请输入订单号",)
            ),
        height: 30.0,
        );

    Widget w00 = new Container(height: 40.0,child: new GestureDetector(
        child: new Text("点我弹出支付,在上面输入框输入订单号"),
        onTap: _payOrder,
        ),);

    Widget w0 = new Container(child: new GestureDetector(
        child: new Text("点我弹出分享"),
        onTap: _shareVendor,
    ),height: 40.0,);
    Widget w1 = new Container(
        height: 50.0,
        child:  new GestureDetector(
            onTap: _requestApi,
            child: new Text(_text),
            )
    );

    Widget row = new Column(children: <Widget>[field,w00,w0,w1],);
    return new Container(child: row,);
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