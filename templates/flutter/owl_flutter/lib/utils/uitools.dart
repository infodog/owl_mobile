import 'package:flutter/material.dart';
import 'package:owl_flutter/utils/json_util.dart';
import 'package:reflected_mustache/mustache.dart';

import '../model/ScreenModel.dart';

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

abstract class UiTools {
  ScreenModel model;
  Map componentModel;

  static Color parseCssColor(String cssColor) {
    if (cssColor == null) {
      return null;
    }
    if (cssColor.startsWith("#")) {
      cssColor = cssColor.replaceFirst("#", "");
      int inColor = int.parse(cssColor, radix: 16);
      return Color(inColor).withAlpha(0xff);
    } else {
      var beginPos = cssColor.indexOf("rgba(");
      if (beginPos == -1) {
        return null;
      }
      var endPos = cssColor.indexOf(")");
      if (endPos == -1) {
        return null;
      }
      var args = cssColor.substring(beginPos + 5, endPos);
      var parts = args.split(",");
      if (parts.length != 4) {
        return null;
      }

      int r = int.parse(parts[0]);
      int g = int.parse(parts[1]);
      int b = int.parse(parts[2]);
      int a = (double.parse(parts[3]) * 255).round();
      return Color.fromARGB(a, r, g, b);
    }
  }

  Color fromCssColor(String cssColor) {
    return parseCssColor(cssColor);
  }

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
      List<String> classes = classString.split(RegExp("\\s"));
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
    if (node == null) {
      return null;
    }
    if (node is String) {
      return null;
    }
    return node['rules'];
  }

  List<dynamic> calcNodeCssRules(node, pageCss) {
    var cssClass = getAttr(node, "class");
    var style = getAttr(node, "style");

    List rules = getEffectiveCssRules(cssClass, style, pageCss);
    return rules;
  }

  String getRuleValue(List<dynamic> rules, String name) {
    if (rules == null) {
      return null;
    }

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
    } else {
      double v = double.parse(l);
      return v;
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
        return FontWeight.w400;
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

  List<BoxShadow> parseBoxShadow(String cssBoxShadow) {
    if (cssBoxShadow == null) {
      return null;
    }
    //首先将cssBoxShadow给切分开
    List<String> parts = cssBoxShadow.split(new RegExp("[\n]+"));
    List<BoxShadow> result = [];
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      part = part.trim();
      //首先找到color
      int colorIndex = part.indexOf("#");
      if (colorIndex == -1) {
        colorIndex = part.indexOf("rgba");
      }
      String strColor = part.substring(colorIndex);
      String numPart = part.substring(0, colorIndex);
      numPart = numPart.trim();
      List<String> numParts = numPart.split(new RegExp("[ \t]+"));
      assert(numParts.length >= 2);

      double offsetX = lp(numParts[0], null);
      double offsetY = lp(numParts[1], null);

      double blurRadius = 0.0;
      double spreadRadius = 0.0;
      if (numParts.length >= 3) {
        blurRadius = lp(numParts[2], 0.0);
      }
      if (numParts.length >= 4) {
        spreadRadius = lp(numParts[3], 0.0);
      }
      BoxShadow boxShadow = BoxShadow(
          color: fromCssColor(strColor),
          offset: Offset(offsetX, offsetY),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius);
      result.add(boxShadow);
    }
    return result;
  }

  double percentageToDouble(String percentage) {
    //percentage is like 50%
    percentage = percentage.trim();
    if (percentage.endsWith("%")) {
      percentage = percentage.substring(0, percentage.length - 1);
      return double.parse(percentage) / 100;
    } else {
      print("is not percentage.");
      return double.nan;
    }
  }

  AlignmentGeometry fromCssAlignment(String x, String y) {
    if (x == 'left' || x == 'right' || x == 'center') {
      if (y == null) {
        y = 'center';
      }
      if (x == 'left' && y == 'top') {
        return Alignment.topLeft;
      }
      if (x == 'left' && y == 'center') {
        return Alignment.centerLeft;
      }
      if (x == 'left' && y == 'bottom') {
        return Alignment.bottomLeft;
      }
      if (x == 'right' && y == 'top') {
        return Alignment.topRight;
      }
      if (x == 'right' && y == 'center') {
        return Alignment.centerRight;
      }
      if (x == 'right' && y == 'bottom') {
        return Alignment.bottomRight;
      }
      if (x == 'center' && y == 'top') {
        return Alignment.topCenter;
      }
      if (x == 'center' && y == 'center') {
        return Alignment.center;
      }
      if (x == 'center' && y == 'bottom') {
        return Alignment.bottomCenter;
      }
    } else {
      if (y == null) {
        y = '50%';
      }

      double dx = percentageToDouble(x);
      double dy = percentageToDouble(y);
      return Alignment(dx * 2 - 1, dy * 2 - 1);
    }
  }

  DecorationImage createDecorationImage(
      {String backgroundImage,
      String backgroundPosition,
      String backgroundRepeat,
      String backgroundSize}) {
    ImageProvider image;
    AlignmentGeometry alignment = Alignment.center;
    ImageRepeat repeat = ImageRepeat.noRepeat;
    BoxFit fit = BoxFit.scaleDown;

    ////image
    if (backgroundImage == null) {
      return null;
    }

    if (backgroundImage.startsWith('url(')) {
      backgroundImage = getMiddle(backgroundImage, "(", ")");
    }

    if (backgroundImage.startsWith('http')) {
      image = NetworkImage(backgroundImage);
    } else {
      String assetKey = null;
      int pos = backgroundImage.indexOf('img');
      assetKey = 'assets/' + backgroundImage.substring(pos);
      image = AssetImage(assetKey);
    }
    //backgroundPosition目前只支持%号定位
    //css:
    //x% y%	The first value is the horizontal position and the second value is the vertical.
    // The top left corner is 0% 0%. The right bottom corner is 100% 100%.
    // If you only specify one value, the other value will be 50%. . Default value is: 0% 0%

    String x, y;
    if (backgroundPosition != null) {
      backgroundPosition = backgroundPosition.trim();
      List<String> parts = backgroundPosition.split(RegExp("\\s"));
      x = parts[0];
      if (parts.length > 1) {
        y = parts[1];
      } else {
        y = null;
      }

      ///alignment
      alignment = fromCssAlignment(x, y);
    }

    ///repeat
    if (backgroundRepeat != null) {
      if (backgroundRepeat == 'no-repeat') {
        repeat = ImageRepeat.noRepeat;
      } else if (backgroundRepeat == 'repeat') {
        repeat = ImageRepeat.repeat;
      } else if (backgroundRepeat == 'repeat-x') {
        repeat = ImageRepeat.repeatX;
      } else if (backgroundRepeat == 'repeat-y') {
        repeat = ImageRepeat.repeatY;
      } else {
        repeat = ImageRepeat.noRepeat;
      }
    }

    if (backgroundSize != null) {
      if (backgroundSize == 'auto') {
        fit = BoxFit.none;
      } else if (backgroundSize == 'cover') {
        fit = BoxFit.cover;
      } else if (backgroundSize == 'contain') {
        fit = BoxFit.contain;
      }
    }

    return DecorationImage(
        image: image, fit: fit, alignment: alignment, repeat: repeat);
  }

  String renderText(String text, {bool escape = false}) {
    if (text == null) {
      return null;
    }
    Template template = new Template(text, htmlEscapeValues: escape);
    if (componentModel != null) {
      if (componentModel['includedScreenModel'] == true) {
        //do nothing
      } else {
        var screenModel = model.pageJs['data'];
        screenModel.forEach((k, v) {
          if (!componentModel.containsKey(k)) {
            componentModel[k] = v;
          }
        });
        componentModel['includedScreenModel'] = true;
      }
      return template.renderString(componentModel);
    } else {
      var pageJs = model.pageJs;
      return template.renderString(pageJs['data']);
    }
  }

  List<dynamic> getNodeCssRulesEx(Map<String, dynamic> node, pageCss) {
    String classString = getAttr(node, "class");
    String styleString = getAttr(node, "style");
    if (node.containsKey("dclass")) {
      classString = renderText(classString, escape: true);
      List rules = getEffectiveCssRules(classString, styleString, pageCss);
      return rules;
    } else {
      return node['rules'];
    }
  }

  String getRuleValueEx(List<dynamic> rules, String ruleName) {
    String ruleValue = getRuleValue(rules, ruleName);
    if (ruleValue == null) {
      return null;
    }
    if (ruleValue.indexOf("{{") > -1) {
      return renderText(ruleValue);
    } else {
      return ruleValue;
    }
  }

  double parsePercentage(String s) {
    if (s.endsWith("%")) {
      s = s.substring(0, s.length - 1);
      double d = double.parse(s) / 100;
      return d;
    }
    return null;
  }

  dynamic getPlainAttr(node, attrName) {
    if (node is String) {
      return null;
    }
    List attrs = node['attrs'];
    if (attrs == null) {
      return null;
    }
    for (int i = 0; i < attrs.length; i++) {
      var attr = attrs[i];
      if (attr['name'] == attrName) {
        String result = attr['value'];
        if (result == null) {
          return null;
        }

        return result;
      }
    }
    return null;
  }

  dynamic getAttr(node, attrName) {
    if (node is String) {
      return null;
    }
    List attrs = node['attrs'];
    if (attrs == null) {
      return null;
    }
    for (int i = 0; i < attrs.length; i++) {
      var attr = attrs[i];
      if (attr['name'] == attrName) {
        String result = attr['value'];
        if (result == null) {
          return null;
        }
        if (result.indexOf("{{") > -1) {
          return renderText(result);
        } else {
          return result;
        }
      }
    }
    return null;
  }

  Map getDataSet(node) {
    if (node is String) {
      return null;
    }
    var result = {};
    List attrs = node['attrs'];
    if (attrs == null) {
      return null;
    }
    for (int i = 0; i < attrs.length; i++) {
      var attr = attrs[i];
      if (attr['name'] != null) {
        String attrName = attr['name'];
        if (attrName.startsWith('data-')) {
          var dataName = attrName.substring(5);
          result[dataName] = attr['value'];
        }
      }
    }
    return result;
  }

  TextDecoration getTextDecorationLine(String line) {
    switch (line) {
      case 'line-through':
        return TextDecoration.lineThrough;
      case 'overline':
        return TextDecoration.overline;
      case 'underline':
        return TextDecoration.underline;
      case 'none':
        return TextDecoration.none;
    }
    return null;
  }

  TextDecorationStyle getTextDecorationStyle(String line) {
    switch (line) {
      case 'solid':
        return TextDecorationStyle.solid;
      case 'double':
        return TextDecorationStyle.double;
      case 'dotted':
        return TextDecorationStyle.dotted;
      case 'dashed':
        return TextDecorationStyle.dashed;
      case 'wavy':
        return TextDecorationStyle.wavy;
    }
    return null;
  }

  TextStyle parseTextDecoration(String textDecoration) {
    TextDecoration decoration = null;
    TextDecorationStyle decorationStyle = null;
    Color color = null;

    if (textDecoration == null) {
      return null;
    }
    List<String> parts = textDecoration.split(RegExp("\\s"));

    if (parts.length >= 1) {
      decoration = getTextDecorationLine(parts[0]);
    }
    if (decoration == null) {
      return null;
    }
    if (parts.length >= 2) {
      decorationStyle = getTextDecorationStyle(parts[1]);
    }
    if (parts.length >= 3) {
      color = fromCssColor(parts[3]);
    }

    return TextStyle(
        decoration: decoration,
        decorationStyle: decorationStyle,
        decorationColor: color);
  }

  Widget wrapGestureDetector(Widget widget, dynamic node, ScreenModel model) {
    var bindtap = getAttr(node, 'bindtap');
    if (bindtap == null) {
      return widget;
    }
    var pageBindTap = model.pageJs[bindtap];
    if (pageBindTap != null) {
      GestureTapUpCallback _onTapHandler = (TapUpDetails details) {
        Map dataset = getDataSet(node);
        dataset = dataset.map((k, v) {
          v = renderText(v);
          return MapEntry(k, v);
        });

        var id = getAttr(node, "id");
        var event = {
          'type': 'tap',
          'target': {"id": id, "dataset": dataset},
          'currentTarget': {"id": id, 'dataset': dataset},
          'detail': {
            'x': details.globalPosition.dx,
            'y': details.globalPosition.dy
          }
        };
        pageBindTap(event);
      };
      return GestureDetector(child: widget, onTapUp: _onTapHandler);
    } else {
      return widget;
    }
  }
}
