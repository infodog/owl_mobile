import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';

class OwlRow extends OwlComponent {
  OwlRow({Key key, node, pageCss, appCss, model, componentModel})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);

  @override
  Widget build(BuildContext context) {
    List rules = getNodeCssRules();
    //搜索width和height
    String flexDirection = getRuleValue(rules, "flex-direction");
    String justifyContent = getRuleValue(rules, "justify-content");
    String alignItems = getRuleValue(rules, "align-items");

    TextDirection textDirection = TextDirection.ltr;
    switch (flexDirection) {
      case 'row':
        textDirection = TextDirection.ltr;
        break;
      case 'row-reverse':
        textDirection = TextDirection.rtl;
        break;
      default:
        break;
    }

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    switch (justifyContent) {
      case 'flex-start':
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case 'flex-end':
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case 'center':
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case 'space-between':
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        break;
      case 'space-around':
        mainAxisAlignment = MainAxisAlignment.spaceAround;
        break;
      case 'space-evenly':
        mainAxisAlignment = MainAxisAlignment.spaceEvenly;
        break;
    }

    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;
    switch (alignItems) {
      case 'flex-start':
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case 'flex-end':
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      case 'center':
        crossAxisAlignment = CrossAxisAlignment.center;
        break;
      case 'baseline':
        crossAxisAlignment = CrossAxisAlignment.baseline;
        break;
      case 'stretch':
        crossAxisAlignment = CrossAxisAlignment.stretch;
        break;
    }
    List<Widget> widgetChildren = [];
    List nodeChildren = node["children"];
    for (int i = 0; i < nodeChildren.length; i++) {
      var childNode = nodeChildren[i];
      var childWidgets = OwlComponentBuilder.buildList(
          node: childNode,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel);
      widgetChildren.addAll(childWidgets);
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      children: widgetChildren,
    );
  }
}
