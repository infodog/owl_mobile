import 'package:flutter/material.dart';

import '../utils/json_util.dart';

abstract class OwlComponent extends StatelessWidget {
  OwlComponent({Key key, this.node, this.pageCss, this.appCss})
      : super(key: key);

  final Map<String, dynamic> node;
  final Map<String, dynamic> pageCss;
  final Map<String, dynamic> appCss;

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

  static void setScreenWidth(w) {
    screenWidth = w;
    if (px_rpx_ratio == 0.0) {
      px_rpx_ratio = w / rpx_width;
    }
  }

  bool isRuleEffective(List<String> selectors, List<String> classes) {
    bool isEffective = false;
    selectors.forEach((selector) {
      if (classes.contains(selector)) {
        isEffective = true;
      }
    });
    return isEffective;
  }

  void addOrReplaceRule(List rules, rule) {
    rule.property = rule.property.toLowerCase();
    rule.value = rule.value.toLowerCase();
    for (int i = 0; i < rules.length; i++) {
      if (rules[i].property == rule.property) {
        rules[i] = rule;
        return;
      }
    }
    rules.add(rule);
  }

  List<dynamic> getEffectiveCssRules(String classString, String style) {
    classString = classString.toLowerCase();
    style = style.toLowerCase();

    List<String> classes = classString.split("\\s");
    var pageRules = pageCss["stylesheet"]["rules"];

    List rules = [];
    pageRules.forEach((rule) {
      if (rule['type'] == 'rule') {
        List<String> selectors = rule.selectors;
        if (isRuleEffective(selectors, classes)) {
          List newRules = rule["declarations"];
          newRules.forEach((r) {
            addOrReplaceRule(rules, r);
          });
        }
      }
    });

    List<String> styleRules = style.split(";");
    styleRules.forEach((s) {
      List<String> pair = s.split(":");
      var rule = {"type": "declaration", "property": pair[0], "value": pair[1]};
      rules.add(rule);
    });

    return rules;
  }

  bool hasTextStyles(List rules) {
    for (int i = 0; i < rules.length; i++) {
      var rule = rules[i];
      if (text_styles.contains(rule.property)) {
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
    if (cssColor.startsWith("#")) {
      cssColor = cssColor.replaceFirst("#", "0x");
      return Color(int.parse(cssColor));
    } else {
      return null;
    }
  }

  FontWeight getFontWeight(String fontWeight) {
    //TODO:补充完整FontWeight的定义
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
        return null;
    }
  }
}
