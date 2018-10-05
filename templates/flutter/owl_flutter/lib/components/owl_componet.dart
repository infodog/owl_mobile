import 'package:flutter/material.dart';
import 'package:mustache4dart/mustache4dart.dart';

import '../utils/json_util.dart';

abstract class OwlComponent extends StatelessWidget {
  OwlComponent(
      {Key key,
      this.node,
      this.pageCss,
      this.appCss,
      this.pageJson,
      this.model})
      : super(key: key);

  final Map<String, dynamic> node;
  final Map<String, dynamic> pageCss;
  final Map<String, dynamic> appCss;
  final Map<String, dynamic> pageJson;
  final Map<String, dynamic> model;

  static double screenWidth;
  static double px_rpx_ratio = 0.0;
  static const double rpx_width = 750.00;

  static const text_styles = [
    "font-weight",
    "font-size",
    "font-family",
    "color",
    "letter-spacing",
    "font-style",
    "text-overflow",
    "line-height",
    "max-lines"
  ];

  static void setScreenWidth(BuildContext context) {
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
      print("error.....");
    }

    for (int i = 0; i < rules.length; i++) {
      if (rules[i]['property'] == rule['property']) {
        rules[i] = rule;
        return;
      }
    }
    rules.add(rule);
  }

  List getEffectiveCssRules(String classString, String style) {
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
        var rule = {
          "type": "declaration",
          "property": pair[0],
          "value": pair[1]
        };
        rules.add(rule);
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

  List<dynamic> getNodeCssRules() {
    var cssClass = getAttr(node, "class");
    var style = getAttr(node, "style");
    List rules = getEffectiveCssRules(cssClass, style);
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
      return FontWeight.normal;
    }
    fontWeight = fontWeight.toLowerCase();
    switch (fontWeight) {
      case 'bold':
        return FontWeight.w700;
      case 'normal':
        return FontWeight.w400;
      case 'light':
        return FontWeight.w300;
      default:
        return FontWeight.normal;
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
      } else if (codeUnit >= '0'.codeUnitAt(0) &&
          codeUnit <= '9'.codeUnitAt(0)) {
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

  String renderText(String text) {
    return render(text, model);
  }
}
