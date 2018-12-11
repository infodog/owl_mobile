import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';

class AssetView extends StatefulWidget {

  final Asset _asset;
  final double width;
  final double height;
  final BoxFit fit;

  AssetView(this._asset,this.width, this.height,{this.fit});

  @override
  State<StatefulWidget> createState() => AssetState(this._asset,this.width,this.height,this.fit);
}

class AssetState extends State<AssetView> {

  Asset _asset;
  double width;
  double height;
  BoxFit fit;
  AssetState(this._asset,this.width,this.height,this.fit);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    await this._asset.requestThumbnail(width.toInt(), height.toInt(), quality: 95);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._asset.thumbData) {
      return Image.memory(
        this._asset.thumbData.buffer.asUint8List(),
        width:this.width,
        height:this.height,
        fit: this.fit??BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return Opacity(opacity:0.5,child:Container(
      child: Text("loading"),
      alignment: Alignment(0.0, 0.0),
    ));
    
     
  }
}