import 'package:flutter/material.dart';
import 'package:flutter_scroll_gallery/flutter_scroll_gallery.dart';
//这里是引用这个类

/*
我的引用没效果  所以引用scroll_gallery.dart这个类
flutter_scroll_gallery: ^0.0.2
*/

class OwlImageScrollGallery extends StatelessWidget {
  OwlImageScrollGallery({this.images});
  List<ImageProvider> images;
  int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("图片浏览"), actions: [
          IconButton(
            icon: Icon(Icons.close),
            tooltip: '关闭',
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]),
        body: new ScrollGallery(images
            //interval: new Duration(seconds: 3), //可以自动播放   播放时间
            ));
  }
}
