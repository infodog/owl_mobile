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
    setScreenWidth(context);
    List rules = getNodeCssRules(node, pageCss);

    String text = node['_text'];
    text = renderText(text);
    var fontWeight = getRuleValue(rules, "font-weight");
    var fontSize = getRuleValue(rules, "font-size");
    var fontFamily = getRuleValue(rules, "font-family");
    var letterSpacing = getRuleValue(rules, "letter-spacing");
    var fontStyle = getRuleValue(rules, "font-style");
    var textOverflow = getRuleValue(rules, "text-overflow");
    var maxLines = getRuleValue(rules, "max-lines");
    var color = getRuleValue(rules, 'color');
    var textAlign = getRuleValue(rules, 'text-align');

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
