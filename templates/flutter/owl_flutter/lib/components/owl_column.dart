import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';
import '../utils/uitools.dart';

class OwlColumn extends OwlComponent {
  OwlColumn(
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

  @override
  Widget build(BuildContext context) {
    List rules = getNodeCssRules(node, pageCss);
    //搜索width和height
    String flexDirection = getRuleValue(rules, "flex-direction");
    String justifyContent = getRuleValue(rules, "justify-content");
    String alignItems = getRuleValue(rules, "align-items");

    List<Widget> columnChildren = [];
    List nodeChildren = node["children"];
    for (int i = 0; i < nodeChildren.length; i++) {
      var childNode = nodeChildren[i];
      var childWidgets = OwlComponentBuilder.buildList(
          node: childNode,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: node,
          parentWidget: this,
          cacheContext: cacheContext);
      columnChildren.addAll(childWidgets);
    }

    return wrapFlex(
        flexDirection: 'column',
        justifyContent: justifyContent,
        alignItems: alignItems,
        children: columnChildren);
  }
}
