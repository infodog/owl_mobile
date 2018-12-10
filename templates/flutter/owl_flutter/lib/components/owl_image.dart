import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:owl_flutter/widgets/asset_view.dart';

import '../components/owl_componet.dart';
import '../utils/json_util.dart';
import '../utils/uitools.dart';

class OwlImage extends OwlComponent {
  OwlImage(
      {Key key,
      dynamic node,
      dynamic pageCss,
      dynamic appCss,
      model,
      componentModel,
      parentNode,
      parentWidget,
      cacheContext})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

  @override
  Widget build(BuildContext context) {

    var mode = getAttr(node, "mode");
    List rules = getNodeCssRulesEx(node, pageCss);
    //搜索width和height
    String width = getRuleValueEx(rules, "width");
    String height = getRuleValueEx(rules, "height");

    BoxFit fit = BoxFit.cover;

    switch (mode) {
      case 'scaleToFill':
        fit = BoxFit.fill;
        break;
      case 'aspectFit':
        fit = BoxFit.contain;
        break;
      case 'aspectFill':
        fit = BoxFit.cover;
        break;
      case 'widthFix':
        fit = BoxFit.fitWidth;
        break;
      case 'top':
        fit = BoxFit.scaleDown;
        break;
      default:
        fit = BoxFit.cover;
    }

    String src = getPlainAttr(node, "src");
    print("src is : " + src);
    print(src);
    var srcObj;
    if (src.indexOf("{{") == 0) {
      src = getMiddle(src, "{{", "}}");
    }
    print(src);
    srcObj = model.getData(src);
    if(srcObj is String){
      src = srcObj;
      if (src.startsWith('http')) {
        return CachedNetworkImage(
            imageUrl: src,
            width: lp(width, null),
            height: lp(height, null),
            fit: fit);
      } else {
        String assetKey = null;
        int pos = src.indexOf('img');
        assetKey = 'assets/' + src.substring(pos);
        return Image.asset(assetKey,
            width: lp(width, null), height: lp(height, null), fit: fit);
      }
    }
    else if(srcObj is Asset){
      Asset _asset = srcObj;
      double w = lp(width,300.0);
      double h = lp(height,300.0);
      return AssetView(_asset,w,h,fit:fit);
    }
    return Container();
  }
}
