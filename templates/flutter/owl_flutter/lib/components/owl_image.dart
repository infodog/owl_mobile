import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/components/owl_componet.dart';

import '../utils/json_util.dart';

class OwlImage extends OwlComponent {
  OwlImage({Key key, dynamic node, dynamic pageCss, dynamic appCss})
      : super(key: key, node: node, pageCss: pageCss, appCss: appCss);

  @override
  Widget build(BuildContext context) {
    var src = getAttr(node, "src");
    var mode = getAttr(node, "mode");
    List rules = getNodeCssRules();
    //搜索width和height
    String width = getRuleValue(rules, "width");
    String height = getRuleValue(rules, "height");

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
        fit = BoxFit.none;
    }

    return CachedNetworkImage(
        imageUrl: src,
        width: lp(width, null),
        height: lp(height, null),
        fit: fit);
  }
}
