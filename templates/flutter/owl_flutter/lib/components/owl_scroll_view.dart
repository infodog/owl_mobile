import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';
import '../utils/json_util.dart';
import '../utils/uitools.dart';

class OwlScrollView extends OwlComponent {
  OwlScrollView(
      {Key key,
      node,
      pageCss,
      appCss,
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
    List rules = getNodeCssRules(node, pageCss);
    //搜索width和height

    //搜索width和height
    String width = getRuleValue(rules, "width");
    String height = getRuleValue(rules, "height");

    List children = node['children'];
    String scrollX = getAttr(node, 'scroll-x');
    String scrollY = getAttr(node, 'scroll-y');
    assert(children != null);

    List<Widget> listChildren = [];
    for (int i = 0; i < children.length; i++) {
      List<Widget> childWidgets = OwlComponentBuilder.buildList(
          node: children[i],
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: node,
          parentWidget: this);
      listChildren.addAll(childWidgets);
    }
    Axis scrollDirection = Axis.vertical;
    if (scrollX == 'true') {
      scrollDirection = Axis.horizontal;
    } else if (scrollY == 'true') {
      scrollDirection = Axis.vertical;
    }
    ListView listView = new ListView(
      padding: getPadding(rules),
//      shrinkWrap: true,
      children: listChildren,
      scrollDirection: scrollDirection,
    );
    return Container(
        child: listView,
        height: lp(height, null),
        width: lp(width, null),
        key: ValueKey('scroll-view'));
  }
}
