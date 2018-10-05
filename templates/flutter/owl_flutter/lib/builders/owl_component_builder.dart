import 'package:flutter/widgets.dart';
import 'package:owl_flutter/components/owl_center.dart';
import 'package:owl_flutter/components/owl_column.dart';
import 'package:owl_flutter/components/owl_expanded.dart';
import 'package:owl_flutter/components/owl_form.dart';
import 'package:owl_flutter/components/owl_input.dart';
import 'package:owl_flutter/components/owl_page.dart';
import 'package:owl_flutter/components/owl_row.dart';
import 'package:owl_flutter/components/owl_scroll_view.dart';
import 'package:owl_flutter/components/owl_text.dart';
import 'package:owl_flutter/components/owl_view.dart';
import 'package:owl_flutter/components/owl_wrap.dart';

class OwlComponentBuilder {
  static Widget build(
      {Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss,
      Map<String, dynamic> model}) {
    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    nodeName = node.keys.first;
    var childNode = node[nodeName];
    switch (nodeName) {
      case "page":
        return new OwlPage(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "view":
        return new OwlView(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "column":
        return new OwlColumn(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "row":
        return new OwlRow(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "wrap":
        return new OwlWrap(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "form":
        return new OwlForm(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "input":
        return new OwlInput(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "center":
        return new OwlCenter(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "middle":
        return new OwlCenter(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "expanded":
        return new OwlExpanded(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "swipper":
        break;
      case "scroll_view":
        return new OwlScrollView(
            node: childNode, pageCss: pageCss, appCss: appCss, model: model);
      case "cover_view":
        break;
      case "bottom_navigator_bar":
        break;
      case "_text":
        return OwlText(
            node: node, pageCss: pageCss, appCss: appCss, model: model);
    }
  }
}
