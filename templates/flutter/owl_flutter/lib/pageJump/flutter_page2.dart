import 'package:flutter/material.dart';
import 'page_jumpper.dart';
import 'ole_network.dart';
class Page2 extends StatelessWidget {

  void _openNewPage(){
    //跳转界面
     PageJumpper.jump({"pageType":"productDetail","value":"p_5600694"});

  }
  void _popPage(){
    PageJumpper.notityNativePop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar:null,
        body: new Center(
            child:  new GestureDetector(
                onTap: _popPage,
                child: new Text(
                    '我是flutter页面2,点圆形按钮跳转至原生的商详[饼干]\n点击文字本身会返回上一页',
                    ),
            )
            ),
        floatingActionButton: new FloatingActionButton(
            onPressed: _openNewPage,
            child: new Icon(Icons.open_in_new),
            ),
        );;
  }
}