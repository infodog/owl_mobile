import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      parentWidget})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget);

  @override
  Widget build(BuildContext context) {
    String src = getAttr(node, "src");
    src = renderText(src);
    var mode = getAttr(node, "mode");
    List rules = getNodeCssRules(node, pageCss);
    //搜索width和height
    String width = getRuleValue(rules, "width");
    String height = getRuleValue(rules, "height");

    BoxFit fit = BoxFit.cover;

    switch (mode) {
      case 'scaleToFill':
        fit = BoxFit.fill;
        break;
      case 'aspectFit':
        fit = BoxFit.cover;
        break;
      case 'aspectFill':
        fit = BoxFit.contain;
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
}
