import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/utils/uitools.dart';

import '../components/owl_statefulcomponent.dart';
import '../utils/json_util.dart';

class OwlInput extends OwlStatefulComponent {
  OwlInput(
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
  OwlInputState createState() {
    return new OwlInputState();
  }
}

class OwlInputState extends State<OwlInput> {
  TextEditingController editingController;
  String paddingLeft;
  String paddingRight;
  String paddingTop;
  String paddingBottom;
  String fontSize;
  String color;
  String placeholder;
  bool enabled = true;
  bool obscureText = false;
  TextStyle hintTextStyle = null;

  Color cssColor;

  @override
  void initState() {
    String disabled = getAttr(widget.node, 'disabled');
    placeholder = getAttr(widget.node, 'placeholder');

    if (disabled == 'true') {
      enabled = false;
    }
    List rules = widget.getNodeCssRulesEx(widget.node, widget.pageCss);

    paddingLeft = widget.getRuleValueEx(rules, "padding-left");
    paddingRight = widget.getRuleValueEx(rules, "padding-right");
    paddingTop = widget.getRuleValueEx(rules, "padding-top");
    paddingBottom = widget.getRuleValueEx(rules, "padding-bottom");
    fontSize = widget.getRuleValueEx(rules, "font-size");
    color = widget.getRuleValueEx(rules, 'color');
    cssColor = fromCssColor(color);

    var hintTextColor = widget.getRuleValueEx(rules, 'hint-text-color');
    if (hintTextColor != null) {
      hintTextStyle = TextStyle(color: fromCssColor(hintTextColor));
      
    }

    String type = getAttr(widget.node, 'type');
    if (type != null) {
      type = type.toLowerCase();
      if (type == 'password') {
        obscureText = true;
      }
    }

    ///设置事件处理程序
    String initValue = getAttr(widget.node, 'value');
    String name = getAttr(widget.node, 'name');
    String key = getAttr(widget.node, 'key');
    if (key == null) {
      key = name;
    }
    editingController = new TextEditingController();
    this.editingController.text = widget.renderText(initValue);
    String bindinput = getAttr(widget.node, 'bindinput');
    if (bindinput != null) {
      Function(dynamic) f = widget.model.pageJs[bindinput];
      this.editingController.addListener(() {
        var e = {
          "detail": {"value": editingController.text}
        };
        f(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: this.editingController,
        obscureText: obscureText,
        style: DefaultTextStyle.of(context).style.merge(
            TextStyle(color: cssColor, fontSize: widget.lp(fontSize, null))),
        decoration: InputDecoration(
            border: InputBorder.none,
            enabled: enabled,
            hintText: placeholder,
            hintStyle: hintTextStyle,
            contentPadding: EdgeInsets.only(
                left: widget.lp(paddingLeft, 0.0),
                right: widget.lp(paddingRight, 0.0),
                top: widget.lp(paddingTop, 0.0),
                bottom: widget.lp(paddingBottom, 0.0))));
  }
}
