import 'package:flutter/material.dart';
import '../pageJump/page_jumpper.dart';
import '../ole_model/ole_user_manager.dart';
import '../pageJump/ole_network.dart';
class _HomeState extends State<OleHomePageWraper> {

  final Widget body;
  _HomeState(this.body);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    PageJumpper.setUp(context);
    return body;
  }
}
class OleHomePageWraper extends StatefulWidget {
  final Widget body;
  OleHomePageWraper(this.body){
        //这里需要做一些通道的初始化
        OleNetWork.channel().prepare();
        PageJumpper.channel().prepare();
        PageJumpper.requestDeviceInfo();

        OleUserManager.channel().prepare();


  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return  _HomeState(body);
  }
}
