import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';

class OwlWrap extends OwlComponent {
  OwlWrap(
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

    WrapAlignment mainAxisAlignment = WrapAlignment.start;
    switch (justifyContent) {
      case 'flex-start':
        mainAxisAlignment = WrapAlignment.start;
        break;
      case 'flex-end':
        mainAxisAlignment = WrapAlignment.end;
        break;
      case 'center':
        mainAxisAlignment = WrapAlignment.center;
        break;
      case 'space-between':
        mainAxisAlignment = WrapAlignment.spaceBetween;
        break;
      case 'space-around':
        mainAxisAlignment = WrapAlignment.spaceAround;
        break;
      case 'space-evenly':
        mainAxisAlignment = WrapAlignment.spaceEvenly;
        break;
    }

    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start;
    switch (alignItems) {
      case 'flex-start':
        crossAxisAlignment = WrapCrossAlignment.start;
        break;
      case 'flex-end':
        crossAxisAlignment = WrapCrossAlignment.end;
        break;
      case 'center':
        crossAxisAlignment = WrapCrossAlignment.center;
        break;
      case 'baseline':
        //crossAxisAlignment = WrapCrossAlignment.baseline;
        //not implemented by the framework
        break;
      case 'stretch':
        //crossAxisAlignment = WrapCrossAlignment.stretch;
        //not implemented by the framework
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
          componentModel: componentModel,
          parentNode: node,
          parentWidget: this,
          cacheContext: cacheContext);
      widgetChildren.addAll(childWidgets);
    }

    return Wrap(
      alignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      children: widgetChildren,
    );
  }
}
