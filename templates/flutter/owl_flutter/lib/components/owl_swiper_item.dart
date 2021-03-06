import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/owl_componet.dart';

class OwlSwiperItem extends OwlComponent {
  OwlSwiperItem(
      {Key key,
      node,
      pageCss,
      appCss,
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

  getImage() {
    var children = node['children'];
    var imgNode = children[0];
    var childNode = imgNode['image'];

    var src = renderText(getAttr(childNode, 'src'), escape: false);
    if (src != null) {
      if (src.startsWith("http")) {
        return NetworkImage(src);
      } else {
        String assetKey = null;
        int pos = src.indexOf('img');
        if (pos > -1) {
          assetKey = 'assets/' + src.substring(pos);
          return AssetImage(assetKey);
        } else {
          return null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
