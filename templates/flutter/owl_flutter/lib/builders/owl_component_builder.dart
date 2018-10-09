import 'package:flutter/widgets.dart';
import 'package:owl_flutter/components/owl_center.dart';
import 'package:owl_flutter/components/owl_column.dart';
import 'package:owl_flutter/components/owl_expanded.dart';
import 'package:owl_flutter/components/owl_form.dart';
import 'package:owl_flutter/components/owl_input.dart';
import 'package:owl_flutter/components/owl_page.dart';
import 'package:owl_flutter/components/owl_row.dart';
import 'package:owl_flutter/components/owl_scroll_view.dart';
import 'package:owl_flutter/components/owl_text.dart';
import 'package:owl_flutter/components/owl_view.dart';
import 'package:owl_flutter/components/owl_wrap.dart';
import 'package:owl_flutter/model/ScreenModel.dart';
import 'package:owl_flutter/utils/json_util.dart';

class OwlComponentBuilder {
  static Widget build(
      {Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss,
      ScreenModel model,
      Map componentModel}) {
    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    nodeName = node.keys.first;
    var childNode = node[nodeName];
    switch (nodeName) {
      case "page":
        return new OwlPage(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "view":
        return new OwlView(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "column":
        return new OwlColumn(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "row":
        return new OwlRow(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "wrap":
        return new OwlWrap(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "form":
        return new OwlForm(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "input":
        return new OwlInput(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "center":
        return new OwlCenter(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "middle":
        return new OwlCenter(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "expanded":
        return new OwlExpanded(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "swipper":
        break;
      case "scroll_view":
        return new OwlScrollView(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
      case "cover_view":
        break;
      case "bottom_navigator_bar":
        break;
      case "_text":
        return OwlText(
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);
    }
  }

  static List<Widget> buildList(
      {Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss,
      ScreenModel model,
      componentModel}) {
    List<Widget> result = [];
    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    nodeName = node.keys.first;
    if (nodeName == '_text') {
      result.add(OwlText(
          node: node,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel));
      return result;
    }
    var childNode = node[nodeName];

    var wxif = getAttr(childNode, 'wx:if');
    if (wxif != null) {
      //获取 {{ xxx }} 中间的xxx部分
      String wxifExpr = getMiddle(wxif, "{{", "}}");
      bool brevert = false;
      if (wxifExpr.startsWith("!")) {
        wxifExpr = wxifExpr.substring(1);
        brevert = true;
      }
      var r = model.getData(wxifExpr);
      if (r == false || r == 'false') {
        r = false;
      } else {
        r = true;
      }
      if (brevert) {
        r = !r;
      }
      if (r == false) {
        return result;
      }
    }

    var wxfor = getAttr(childNode, 'wx:for');
    if (wxfor != null) {
      var wxforItem = getAttr(childNode, 'wx:for-item');
      var wxforIndex = getAttr(childNode, 'wx:for-index');

      if (wxforItem == null) {
        wxforItem = 'item';
      }

      if (wxforIndex == null) {
        wxforIndex = 'index';
      }

      wxfor = getMiddle(wxfor, '{{', '}}');
      var array = model.getData(wxfor);
      if (array != null && array is List) {
        for (int i = 0; i < array.length; i++) {
          var item = array[i];
          var newComponentModel = {};
          if (componentModel != null) {
            newComponentModel = Map.from(componentModel);
          }
          newComponentModel[wxforItem] = item;
          newComponentModel[wxforIndex] = i;
          Widget widget = OwlComponentBuilder.build(
              node: node,
              pageCss: pageCss,
              appCss: appCss,
              model: model,
              componentModel: newComponentModel);
          if (widget != null) {
            result.add(widget);
          }
        }
      } else {
        return result;
      }
    } else {
      //no for statement
      Widget widget = OwlComponentBuilder.build(
          node: node,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel);
      if (widget != null) {
        result.add(widget);
      }
    }
    return result;
  }
}
