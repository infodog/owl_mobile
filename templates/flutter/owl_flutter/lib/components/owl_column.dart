import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';

class OwlColumn extends OwlComponent {
  OwlColumn({Key key, node, pageCss, appCss})
      : super(key: key, node: node, pageCss: pageCss, appCss: appCss);

  @override
  Widget build(BuildContext context) {
    List rules = getNodeCssRules();
    //搜索width和height
    String flexDirection = getRuleValue(rules, "flex-direction");
    String justifyContent = getRuleValue(rules, "justify-content");
    String alignItems = getRuleValue(rules, "align-items");

    VerticalDirection verticalDirection = VerticalDirection.down;
    switch (flexDirection) {
      case 'column':
        verticalDirection = VerticalDirection.down;
        break;
      case 'column-reverse':
        verticalDirection = VerticalDirection.up;
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
    List columnChildren = [];
    List nodeChildren = node["children"];
    for (int i = 0; i < nodeChildren.length; i++) {
      var childNode = nodeChildren[i];
      var childWidget = OwlComponentBuilder.build(
          node: childNode, pageCss: pageCss, appCss: appCss);
      columnChildren.add(childWidget);
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      verticalDirection: verticalDirection,
      children: columnChildren,
    );
  }
}
