import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/owl_componet.dart';
import '../utils/uitools.dart';

class OwlText extends OwlComponent {
  OwlText(
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
    setScreenWidth(context);
    List rules = getNodeCssRulesEx(node, pageCss);

    String text = node['_text'];
    text = renderText(text);
    var fontWeight = getRuleValueEx(rules, "font-weight");
    var fontSize = getRuleValueEx(rules, "font-size");
    var fontFamily = getRuleValueEx(rules, "font-family");
    var letterSpacing = getRuleValueEx(rules, "letter-spacing");
    var fontStyle = getRuleValueEx(rules, "font-style");
    var textOverflow = getRuleValueEx(rules, "text-overflow");
    var maxLines = getRuleValueEx(rules, "max-lines");
    var color = getRuleValueEx(rules, 'color');
    var textAlign = getRuleValueEx(rules, 'text-align');

    Color textcolor = fromCssColor(color);

    TextStyle style = TextStyle(
        color: textcolor,
        fontWeight: getFontWeight(fontWeight),
        fontSize: lp(fontSize, null),
        fontFamily: fontFamily,
        letterSpacing: lp(letterSpacing, null),
        fontStyle: fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);

    return Text(text, style: DefaultTextStyle.of(context).style.merge(style));
  }
}
