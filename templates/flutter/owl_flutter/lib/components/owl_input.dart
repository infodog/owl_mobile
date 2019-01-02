import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/owl_statefulcomponent.dart';

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
      cacheContext,
      this.maxLines = 1})
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

  int maxLines = 1;
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
  TextStyle hintTextStyle;

  String inputtype;

  Color cssColor;

  TextInputType textInputType;

  Function(String) onBlur;

  void updateSetting() {
    String disabled = widget.getAttr(widget.node, 'disabled');
    placeholder = widget.getAttr(widget.node, 'placeholder');

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
    cssColor = widget.fromCssColor(color);

    var hintTextColor = widget.getRuleValueEx(rules, 'hint-text-color');
    if (hintTextColor != null) {
      hintTextStyle = TextStyle(color: widget.fromCssColor(hintTextColor));
    }

    String password = widget.getAttr(widget.node, 'password');

    if (password != null && password == 'true') {
      obscureText = true;
    } else {
      obscureText = false;
    }

    /*
    text	文本输入键盘
number	数字输入键盘
idcard	身份证输入键盘
digit
     */

    inputtype = widget.getAttr(widget.node, 'type');
    switch (inputtype) {
      case 'text':
        textInputType = TextInputType.text;
        break;
      case 'number':
        textInputType = TextInputType.number;
        break;
      case 'digit':
        textInputType =
            TextInputType.numberWithOptions(decimal: true, signed: true);
        break;
      case 'idcard':
        textInputType = TextInputType.text;
        break;
      default:
        textInputType = TextInputType.text;
    }

    if (widget.maxLines > 1) {
      textInputType = TextInputType.multiline;
    }

    ///设置事件处理程序

    String name = widget.getAttr(widget.node, 'name');
    String key = widget.getAttr(widget.node, 'key');
    if (key == null) {
      key = name;
    }
  }

  @override
  void initState() {
    editingController = new TextEditingController();
    String bindblur = widget.getAttr(widget.node, 'bindblur');

    if (bindblur != null) {
      Function(dynamic) f = widget.model.pageJs[bindblur];
      onBlur = (String v) {
        var e = {
          "detail": {"value": v}
        };
        f(e);
      };
    }

    String bindinput = widget.getAttr(widget.node, 'bindinput');
    if (bindinput != null) {
      Function(dynamic) f = widget.model.pageJs[bindinput];
      this.editingController.addListener(() {
        var e = {
          "detail": {"value": editingController.text}
        };
        f(e);
      });
    }
    String initValue = widget.getAttr(widget.node, 'value');
    this.editingController.text = widget.renderText(initValue);
    updateSetting();
  }

  void didUpdateWidget(Widget oldWidget) {
    updateSetting();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: widget.maxLines,
        keyboardType: textInputType,
        controller: this.editingController,
        obscureText: obscureText,
        onSubmitted: onBlur,
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
