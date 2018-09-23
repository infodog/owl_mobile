import 'package:flutter/widgets.dart';
import 'package:owl_flutter/components/owl_column.dart';
import 'package:owl_flutter/components/owl_page.dart';
import 'package:owl_flutter/components/owl_row.dart';
import 'package:owl_flutter/components/owl_scroll_view.dart';
import 'package:owl_flutter/components/owl_view.dart';

class OwlComponentBuilder {
  static Widget build(
      {Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss}) {
    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    nodeName = node.keys.first;
    var childNode = node[nodeName];
    switch (nodeName) {
      case "page":
        return new OwlPage(node: childNode, pageCss: pageCss, appCss: appCss);
      case "view":
        return new OwlView(node: childNode, pageCss: pageCss, appCss: appCss);
      case "column":
        return new OwlColumn(node: childNode, pageCss: pageCss, appCss: appCss);
      case "row":
        return new OwlRow(node: childNode, pageCss: pageCss, appCss: appCss);
      case "swipper":
        break;
      case "scroll_view":
        return new OwlScrollView(
            node: childNode, pageCss: pageCss, appCss: appCss);
      case "cover_view":
        break;
      case "bottom_navigator_bar":
        break;
      case "_text":
        String textContent = childNode;
        return Text(textContent);
    }
  }
}
