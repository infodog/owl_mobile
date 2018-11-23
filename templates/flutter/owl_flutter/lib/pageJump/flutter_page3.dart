import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {

  void _openNewPage(){
    //跳转界面
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("page3"),
            ),
        body: new Center(
            child: new Text(
                '这是页面3,点击按钮跳转至原生的页面3',
                ),
            ),
        floatingActionButton: new FloatingActionButton(
            onPressed: _openNewPage,
            child: new Icon(Icons.open_in_new),
            ),
        );;
  }
}

