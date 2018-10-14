import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:owl_flutter/utils/uitools.dart';

class OwlRow extends OwlComponent {
  OwlRow(
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
    String flexDirection = getRuleValue(rules, "flex-direction");
    String justifyContent = getRuleValue(rules, "justify-content");
    String alignItems = getRuleValue(rules, "align-items");

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
          parentWidget: this);
      widgetChildren.addAll(childWidgets);
    }

    return wrapFlex(
        flexDirection: "row",
        justifyContent: justifyContent,
        alignItems: alignItems,
        children: widgetChildren);
  }
}
