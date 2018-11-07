import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';
import '../utils/json_util.dart';
import '../utils/uitools.dart';

class OwlView extends OwlComponent {
  OwlView(
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

  bool isStack;
  Widget w = null;
  Widget _buildWidget(BuildContext context) {
    print("...build");
    setScreenWidth(context);
    String alignment = getAttr(node, 'alignment');
    var children = node['children'];

    var fixednodes = [];
    var nonFixedNodes = [];
    for (var i = 0; i < children.length; i++) {
      Map<String, dynamic> child = children[i];
      var nodeName = child.keys.first;
      List childRules = getNodeCssRulesEx(child[nodeName], pageCss);
      var position = getRuleValueEx(childRules, 'position');

      if (position == 'absolute') {
        fixednodes.add(child);
      } else {
        nonFixedNodes.add(child);
      }
    }

    List<Widget> childWidgets = [];
    List<Widget> fixedWidgets = [];
    Map<Widget, int> widget2zindex = {};

    for (var i = 0; i < nonFixedNodes.length; i++) {
      var childNode = nonFixedNodes[i];
      var zIndexStr = getRuleValueEx(childNode['rules'], 'z-index');
      int zIndex = 0;
      if (zIndexStr != null) {
        zIndex = int.parse(zIndexStr);
      }

      var widgets = OwlComponentBuilder.buildList(
          node: childNode,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: node,
          parentWidget: this,
          cacheContext: cacheContext);
      childWidgets.addAll(widgets);
      for (var j = 0; j < widgets.length; j++) {
        widget2zindex[widgets[j]] = zIndex;
      }
    }

    for (var i = 0; i < fixednodes.length; i++) {
      var childNode = fixednodes[i];
      var zIndexStr = getRuleValueEx(childNode['rules'], 'z-index');
      int zIndex = 0;
      if (zIndexStr != null) {
        zIndex = int.parse(zIndexStr);
      }
      var widgets = OwlComponentBuilder.buildList(
          node: childNode,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: node,
          parentWidget: this,
          cacheContext: cacheContext);
      fixedWidgets.addAll(widgets);

      for (var j = 0; j < widgets.length; j++) {
        widget2zindex[widgets[j]] = zIndex;
      }
    }

    List rules = getNodeCssRulesEx(node, pageCss);
    //搜索width和height
    String width = getRuleValueEx(rules, "width");
    String height = getRuleValueEx(rules, "height");
    String color = getRuleValueEx(rules, "color");
    String backgroundColor = getRuleValueEx(rules, 'background-color');

    String minWidth = getRuleValueEx(rules, "min-width");
    String maxWidth = getRuleValueEx(rules, "max-width");
    String minHeight = getRuleValueEx(rules, "min-height");
    String maxHeight = getRuleValueEx(rules, "max-height");
    String borderRadius = getRuleValueEx(rules, "border-radius");

    String backgroundImage = getRuleValueEx(rules, "background-image");
    String backgroundPosition = getRuleValueEx(rules, "background-position");
    String backgroundRepeat = getRuleValueEx(rules, "background-repeat");
    String backgroundSize = getRuleValueEx(rules, 'background-size');

    String position = getRuleValueEx(rules, "position");

    Color bColor = fromCssColor(backgroundColor);
    Border border = getBorder(rules);
    String className = getAttr(node, 'class'); //{{aaaa}} => 1

    String flexDirection = getRuleValueEx(rules, "flex-direction");
    String justifyContent = getRuleValueEx(rules, "justify-content");
    String alignItems = getRuleValueEx(rules, "align-items");

    String boxShadow = getRuleValueEx(rules, 'box-shadow');
    List<BoxShadow> shadows = parseBoxShadow(boxShadow);

    Widget container = Container(
        key: ValueKey(className),
        child: ClipRect(
            child: wrapFlex(
                children: childWidgets,
                flexDirection: flexDirection,
                justifyContent: justifyContent,
                alignItems: alignItems)),
        width: lp(width, null),
        height: lp(height, null),
//        alignment: Alignment.topLeft,
        padding: getPadding(rules),
        margin: getMargin(rules),
        decoration: BoxDecoration(
            color: bColor,
            image: createDecorationImage(
                backgroundImage: backgroundImage,
                backgroundPosition: backgroundPosition,
                backgroundSize: backgroundSize,
                backgroundRepeat: backgroundRepeat),
            border: border,
            boxShadow: shadows,
            borderRadius: borderRadius == null
                ? null
                : BorderRadius.circular(lp(borderRadius, 0.0))),
        constraints: BoxConstraints(
            minWidth: lp(minWidth, 0.0),
            minHeight: lp(minHeight, 0.0),
            maxWidth: lp(maxWidth, double.infinity),
            maxHeight: lp(maxHeight, double.infinity)));

    Widget realView = null;
    if (hasTextStyles(rules)) {
      Color textcolor = fromCssColor(color);
      var fontWeight = getRuleValueEx(rules, "font-weight");
      var fontSize = getRuleValueEx(rules, "font-size");
      var fontFamily = getRuleValueEx(rules, "font-family");
      var letterSpacing = getRuleValueEx(rules, "letter-spacing");
      var fontStyle = getRuleValueEx(rules, "font-style");
      var textOverflow = getRuleValueEx(rules, "text-overflow");
      var maxLines = getRuleValueEx(rules, "max-lines");
      var lineHeight = getRuleValueEx(rules, 'line-height');
      var textAlign = getRuleValueEx(rules, 'text-align');

      TextStyle style;

      if (lineHeight != null) {
        double effectiveFontSize =
            lp(fontSize, null) ?? DefaultTextStyle.of(context).style.fontSize;
        double height = lp(lineHeight, null) / effectiveFontSize;
        style = TextStyle(
            color: textcolor,
            fontWeight: getFontWeight(fontWeight),
            fontSize: lp(fontSize, null),
            fontFamily: fontFamily,
            height: height,
            letterSpacing: lp(letterSpacing, null),
            fontStyle:
                fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);
      } else {
        style = TextStyle(
            color: textcolor,
            fontWeight: getFontWeight(fontWeight),
            fontSize: lp(fontSize, null),
            fontFamily: fontFamily,
            letterSpacing: lp(letterSpacing, null),
            fontStyle:
                fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);
      }

      realView = DefaultTextStyle(
          child: container,
          textAlign: getTextAlign(textAlign) == null
              ? DefaultTextStyle.of(context).textAlign
              : getTextAlign(textAlign),
          style: DefaultTextStyle.of(context).style.merge(style),
          overflow: getTextOverflow(textOverflow),
          maxLines: maxLines == null ? null : int.parse(maxLines));
    } else {
      realView = container;
    }

    if (position == 'absolute' || position == 'fixed') {
      String left = getRuleValueEx(rules, 'left');
      String top = getRuleValueEx(rules, 'top');
      String right = getRuleValueEx(rules, 'right');
      String bottom = getRuleValueEx(rules, 'bottom');

      var realChild = realView;
      if (fixedWidgets.length > 0) {
        List<Widget> stackChildren = [realView];
        widget2zindex[realView] = 0;

        stackChildren.addAll(fixedWidgets);
        stackChildren.sort((w1, w2) {
          return widget2zindex[w1].compareTo(widget2zindex[w2]);
        });
        realChild = Stack(children: stackChildren);
      }

      return Positioned(
          child: realChild,
          top: lp(top, null),
          left: lp(left, null),
          right: lp(right, null),
          bottom: lp(bottom, null));
    } else {
      //检查下面的子元素是否有position=absolute
      if (fixedWidgets.length > 0) {
        List<Widget> stackChildren = [realView];
        widget2zindex[realView] = 0;

        stackChildren.addAll(fixedWidgets);
        stackChildren.sort((w1, w2) {
          return widget2zindex[w1].compareTo(widget2zindex[w2]);
        });
        return Stack(children: stackChildren);
      } else {
        return realView;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (w != null) {
      return w;
    }
    w = _buildWidget(context);
    return w;
  }
}
