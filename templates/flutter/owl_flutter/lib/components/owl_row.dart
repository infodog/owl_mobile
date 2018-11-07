import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';
import '../utils/uitools.dart';

class OwlRow extends OwlComponent {
  OwlRow(
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
    List rules = getNodeCssRulesEx(node, pageCss);
    //搜索width和height
    String flexDirection = getRuleValueEx(rules, "flex-direction");
    String justifyContent = getRuleValueEx(rules, "justify-content");
    String alignItems = getRuleValueEx(rules, "align-items");

    List<Widget> widgetChildren = [];
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
      widgetChildren.addAll(childWidgets);
    }

    return wrapFlex(
        flexDirection: "row",
        justifyContent: justifyContent,
        alignItems: alignItems,
        children: widgetChildren);
  }
}
