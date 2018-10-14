import 'package:flutter/material.dart';

import '../utils/json_util.dart';

double screenWidth;
double px_rpx_ratio = 0.0;
const double rpx_width = 750.00;

const text_styles = [
  "font-weight",
  "font-size",
  "font-family",
  "color",
  "letter-spacing",
  "font-style",
  "text-overflow",
  "line-height",
  "max-lines",
  "text-align"
];

void setScreenWidth(BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  screenWidth = w;
  if (px_rpx_ratio == 0.0) {
    px_rpx_ratio = w / rpx_width;
  }
}

bool isRuleEffective(List<String> selectors, List<String> classes) {
  bool isEffective = false;
  if (selectors == null || classes == null) {
    return false;
  }
  for (int i = 0; i < classes.length; i++) {
    String className = classes[i];
    String selector = '.' + className;
    if (selectors.contains(selector) == true) {
      isEffective = true;
    }
  }
  return isEffective;
}

void addOrReplaceRule(List rules, rule) {
  if (rule['property'] != null) {
    rule['property'] = rule['property'].toLowerCase();
  }
  if (rule['value'] != null && rule['value'] is String) {
    rule['value'] = rule['value'].toLowerCase();
  } else {
    print("error....." + rule.toString());
  }

  for (int i = 0; i < rules.length; i++) {
    if (rules[i]['property'] == rule['property']) {
      rules[i] = rule;
      return;
    }
  }
  rules.add(rule);
}

List getEffectiveCssRules(String classString, String style, dynamic pageCss) {
  List<Map<dynamic, dynamic>> rules = [];
  if (classString != null) {
    List<String> classes = classString.split("\\s");
    var pageRules = pageCss["stylesheet"]["rules"];
    for (int i = 0; i < pageRules.length; i++) {
      var rule = pageRules[i];
      String type = rule['type'];
      if (type == 'rule') {
        List<String> selectors = rule['selectors'];
        if (isRuleEffective(selectors, classes)) {
          List newRules = rule["declarations"];
          newRules.forEach((r) {
            addOrReplaceRule(rules, r);
          });
        }
      }
    }
  }

  if (style != null) {
    style = style.toLowerCase();
    List<String> styleRules = style.split(";");
    for (int i = 0; i < styleRules.length; i++) {
      String s = styleRules[i];
      List<String> pair = s.split(":");
      if (pair.length == 2) {
        var rule = {
          "type": "declaration",
          "property": pair[0],
          "value": pair[1]
        };
        rules.add(rule);
      }
    }
  }

  return rules;
}

bool hasTextStyles(List rules) {
  for (int i = 0; i < rules.length; i++) {
    var rule = rules[i];
    String property = rule['property'];
    if (text_styles.contains(property)) {
      return true;
    }
  }
  return false;
}

List<dynamic> getNodeCssRules(node, pageCss) {
  var cssClass = getAttr(node, "class");
  var style = getAttr(node, "style");
  List rules = getEffectiveCssRules(cssClass, style, pageCss);
  return rules;
}

String getRuleValue(List<Map> rules, String name) {
  for (int i = 0; i < rules.length; i++) {
    Map<String, dynamic> rule = rules[i];
    if (rule["property"] == name) {
      return rule['value'];
    }
  }
  return null;
}

//logicPixel
double lp(String l, double defaultValue) {
  if (l == null) {
    return defaultValue;
  }
  if (l.endsWith("rpx")) {
    l = l.substring(0, l.length - 3);
    double lrpx = double.parse(l);
    return lrpx * px_rpx_ratio;
  } else if (l.endsWith("px")) {
    l = l.substring(0, l.length - 2);
    double lrpx = double.parse(l);
    return lrpx;
  }
  return defaultValue;
}

Color fromCssColor(String cssColor) {
  if (cssColor == null) {
    return null;
  }
  if (cssColor.startsWith("#")) {
    cssColor = cssColor.replaceFirst("#", "");
    int inColor = int.parse(cssColor, radix: 16);
    return Color(inColor).withAlpha(0xff);
  } else {
    return null;
  }
}

FontWeight getFontWeight(String fontWeight) {
  //TODO:补充完整FontWeight的定义
  if (fontWeight == null) {
    return null;
  }
  fontWeight = fontWeight.toLowerCase();
  switch (fontWeight) {
    case 'bold':
      return FontWeight.w700;
    case 'normal':
      return FontWeight.normal;
    case 'light':
      return FontWeight.w300;
    default:
      return null;
  }
}

TextOverflow getTextOverflow(String textoverflow) {
  switch (textoverflow) {
    case 'ellipsis':
      return TextOverflow.ellipsis;
    case 'clip':
      return TextOverflow.clip;
    case 'fade':
      return TextOverflow.fade;
    default:
      return TextOverflow.clip;
  }
}

TextAlign getTextAlign(String textAlign) {
  if (textAlign != null) {
    textAlign = textAlign.toLowerCase();
  } else {
    return null;
  }
  switch (textAlign) {
    case 'left':
      return TextAlign.left;
    case 'right':
      return TextAlign.right;
    case 'center':
      return TextAlign.center;
    case 'justify':
      return TextAlign.justify;
    case 'start':
      return TextAlign.start;
    case 'end':
      return TextAlign.end;
    default:
      return TextAlign.left;
  }
}

BorderStyle getBorderStyle(String styleString) {
  switch (styleString) {
    case 'none':
      return BorderStyle.none;
    case 'solid':
      return BorderStyle.solid;
    default:
      return BorderStyle.none;
  }
}

BorderSide parseBorderSide(String borderSideString) {
  if (borderSideString == null) {
    return null;
  }
  Color color;
  double width;
  BorderStyle style;
  List<String> parts = borderSideString.split(new RegExp("[ \t]+"));
  for (int i = 0; i < parts.length; i++) {
    String part = parts[i];
    int codeUnit = part.codeUnitAt(0);
    if (part.startsWith("#")) {
      //this is color
      color = fromCssColor(part);
    } else if (codeUnit >= '0'.codeUnitAt(0) && codeUnit <= '9'.codeUnitAt(0)) {
      //width
      width = lp(part, null);
    } else {
      //style
      style = getBorderStyle(part);
    }
  }
  return BorderSide(color: color, width: width, style: style);
}

Border getBorder(List rules) {
  String borderAll = getRuleValue(rules, "border");
  String borderBottom = getRuleValue(rules, "border-bottom");
  String borderTop = getRuleValue(rules, "border-top");
  String borderLeft = getRuleValue(rules, "border-left");
  String borderRight = getRuleValue(rules, "border-right");

  BorderSide borderSide = parseBorderSide(borderAll);

  Border border = null;
  if (borderSide != null) {
    border = Border.all(
        color: borderSide.color,
        width: borderSide.width,
        style: borderSide.style);
  }

  BorderSide borderSideBottom = parseBorderSide(borderBottom);
  BorderSide borderSideTop = parseBorderSide(borderTop);
  BorderSide borderSideLeft = parseBorderSide(borderLeft);
  BorderSide borderSideRight = parseBorderSide(borderRight);
  if (borderSideBottom != null) {
    if (border != null) {
      border = Border.merge(border, Border(bottom: borderSideBottom));
    } else {
      border = Border(bottom: borderSideBottom);
    }
  }

  if (borderSideTop != null) {
    if (border != null) {
      border = Border.merge(border, Border(top: borderSideTop));
    } else {
      border = Border(top: borderSideTop);
    }
  }

  if (borderSideLeft != null) {
    if (border != null) {
      border = Border.merge(border, Border(left: borderSideLeft));
    } else {
      border = Border(left: borderSideLeft);
    }
  }

  if (borderSideRight != null) {
    if (border != null) {
      border = Border.merge(border, Border(right: borderSideRight));
    } else {
      border = Border(right: borderSideRight);
    }
  }

  return border;
}

Flex wrapFlex(
    {String flexDirection,
    String justifyContent,
    String alignItems,
    List<Widget> children}) {
  VerticalDirection verticalDirection = VerticalDirection.down;
  Axis direction;
  MainAxisAlignment mainAxisAlignment;
  switch (flexDirection) {
    case 'row':
      verticalDirection = VerticalDirection.down;
      direction = Axis.horizontal;
      mainAxisAlignment = MainAxisAlignment.start;
      break;
    case 'column':
      verticalDirection = VerticalDirection.down;
      direction = Axis.vertical;
      mainAxisAlignment = MainAxisAlignment.start;
      break;
    default:
      verticalDirection = VerticalDirection.down;
      direction = Axis.vertical;
      mainAxisAlignment = MainAxisAlignment.start;
      break;
  }

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

  return Flex(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    verticalDirection: verticalDirection,
    direction: direction,
    children: children,
  );
}

EdgeInsetsGeometry getPadding(rules) {
  String padding = getRuleValue(rules, 'padding');
  String paddingBottom = getRuleValue(rules, "padding-bottom");
  String paddingTop = getRuleValue(rules, "padding-top");
  String paddingLeft = getRuleValue(rules, "padding-left");
  String paddingRight = getRuleValue(rules, "padding-right");
  if (padding != null) {
    List<String> parts = padding.split(new RegExp("[ \t]+"));
    if (parts.length == 1) {
      return EdgeInsets.all(lp(padding, 0.0));
    } else if (parts.length == 2) {
      return EdgeInsets.symmetric(
          vertical: lp(parts[0], 0.0), horizontal: lp(parts[1], 0.0));
    } else if (parts.length == 3) {
      return EdgeInsets.only(
          top: lp(parts[0], 0.0),
          right: lp(parts[1], 0.0),
          left: lp(parts[1], 0.0),
          bottom: lp(parts[2], 0.0));
    } else if (parts.length == 4) {
      return EdgeInsets.only(
          top: lp(parts[0], 0.0),
          right: lp(parts[1], 0.0),
          left: lp(parts[3], 0.0),
          bottom: lp(parts[2], 0.0));
    }
  } else {
    return EdgeInsets.only(
        top: lp(paddingTop, 0.0),
        right: lp(paddingRight, 0.0),
        left: lp(paddingLeft, 0.0),
        bottom: lp(paddingBottom, 0.0));
  }
}

EdgeInsetsGeometry getMargin(rules) {
  String margin = getRuleValue(rules, 'margin');
  String marginBottom = getRuleValue(rules, "margin-bottom");
  String marginTop = getRuleValue(rules, "margin-top");
  String marginLeft = getRuleValue(rules, "margin-left");
  String marginRight = getRuleValue(rules, "margin-right");
  if (margin != null) {
    List<String> parts = margin.split(new RegExp("[ \t]+"));
    if (parts.length == 1) {
      return EdgeInsets.all(lp(margin, 0.0));
    } else if (parts.length == 2) {
      return EdgeInsets.symmetric(
          vertical: lp(parts[0], 0.0), horizontal: lp(parts[1], 0.0));
    } else if (parts.length == 3) {
      return EdgeInsets.only(
          top: lp(parts[0], 0.0),
          right: lp(parts[1], 0.0),
          left: lp(parts[1], 0.0),
          bottom: lp(parts[2], 0.0));
    } else if (parts.length == 4) {
      return EdgeInsets.only(
          top: lp(parts[0], 0.0),
          right: lp(parts[1], 0.0),
          left: lp(parts[3], 0.0),
          bottom: lp(parts[2], 0.0));
    }
  } else {
    return EdgeInsets.only(
        top: lp(marginTop, 0.0),
        right: lp(marginRight, 0.0),
        left: lp(marginLeft, 0.0),
        bottom: lp(marginBottom, 0.0));
  }
}
