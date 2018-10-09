import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:owl_flutter/utils/uitools.dart';

class OwlView extends OwlComponent {
  OwlView({Key key, node, pageCss, appCss, model, componentModel})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);

  @override
  Widget build(BuildContext context) {
    setScreenWidth(context);
    List rules = getNodeCssRules(node, pageCss);
    //搜索width和height
    String width = getRuleValue(rules, "width");
    String height = getRuleValue(rules, "height");
    String color = getRuleValue(rules, "color");
    String backgroundColor = getRuleValue(rules, 'background-color');

    String marginLeft = getRuleValue(rules, "margin-left");
    String marginRight = getRuleValue(rules, "margin-right");
    String marginTop = getRuleValue(rules, "margin-top");
    String marginBottom = getRuleValue(rules, "margin-bottom");

    String paddingLeft = getRuleValue(rules, "padding-left");
    String paddingRight = getRuleValue(rules, "padding-right");
    String paddingTop = getRuleValue(rules, "padding-top");
    String paddingBottom = getRuleValue(rules, "padding-bottom");

    String minWidth = getRuleValue(rules, "min-width");
    String maxWidth = getRuleValue(rules, "max-width");
    String minHeight = getRuleValue(rules, "min-height");
    String maxHeight = getRuleValue(rules, "max-height");
    String borderRadius = getRuleValue(rules, "border-radius");

    List children = node['children'];
    assert(children != null);

    Widget containerChild = null;
    if (children.length == 1) {
      List<Widget> childWidgets = OwlComponentBuilder.buildList(
          node: children[0],
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel);
      if (childWidgets.length == 1) {
        containerChild = childWidgets[0];
      } else {
        containerChild = new Column(children: childWidgets);
      }
    } else {
      List<Widget> listChildren = [];
      for (int i = 0; i < children.length; i++) {
        List<Widget> childWidgets = OwlComponentBuilder.buildList(
            node: children[i],
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
        listChildren.addAll(childWidgets);
      }
      containerChild = new Column(children: listChildren);
    }

    Color bColor = fromCssColor(backgroundColor);
    Border border = getBorder(rules);

    Widget container = Container(
        child: containerChild,
        width: lp(width, null),
        height: lp(height, null),
        padding: EdgeInsets.only(
            left: lp(paddingLeft, 0.0),
            right: lp(paddingRight, 0.0),
            top: lp(paddingTop, 0.0),
            bottom: lp(paddingBottom, 0.0)),
        margin: EdgeInsets.only(
            left: lp(marginLeft, 0.0),
            right: lp(marginRight, 0.0),
            top: lp(marginTop, 0.0),
            bottom: lp(marginBottom, 0.0)),
        decoration: BoxDecoration(
            color: bColor,
            border: border,
            borderRadius: borderRadius == null
                ? null
                : BorderRadius.circular(lp(borderRadius, 0.0))),
        constraints: BoxConstraints(
            minWidth: lp(minWidth, 0.0),
            minHeight: lp(minHeight, 0.0),
            maxWidth: lp(maxWidth, double.infinity),
            maxHeight: lp(maxHeight, double.infinity)));

    if (hasTextStyles(rules)) {
      Color textcolor = fromCssColor(color);
      var fontWeight = getRuleValue(rules, "font-weight");
      var fontSize = getRuleValue(rules, "font-size");
      var fontFamily = getRuleValue(rules, "font-family");
      var letterSpacing = getRuleValue(rules, "letter-spacing");
      var fontStyle = getRuleValue(rules, "font-style");
      var textOverflow = getRuleValue(rules, "text-overflow");
      var maxLines = getRuleValue(rules, "max-lines");
      var lineHeight = getRuleValue(rules, 'line-height');

      TextStyle style = TextStyle(
          color: textcolor,
          fontWeight: getFontWeight(fontWeight),
          fontSize: lp(fontSize, null),
          fontFamily: fontFamily,
          letterSpacing: lp(letterSpacing, null),
          fontStyle:
              fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);

      return DefaultTextStyle(
          child: container,
          style: DefaultTextStyle.of(context).style.merge(style),
          overflow: getTextOverflow(textOverflow),
          maxLines: maxLines == null ? null : int.parse(maxLines));
    } else {
      return container;
    }
  }
}
