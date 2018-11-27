import 'package:flutter/widgets.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:owl_flutter/components/owl_statefulcomponent.dart';

import '../components/owl_center.dart';
import '../components/owl_column.dart';
import '../components/owl_expanded.dart';
import '../components/owl_form.dart';
import '../components/owl_image.dart';
import '../components/owl_input.dart';
import '../components/owl_page.dart';
import '../components/owl_row.dart';
import '../components/owl_scroll_view.dart';
import '../components/owl_swiper.dart';
import '../components/owl_text.dart';
import '../components/owl_view.dart';
import '../components/owl_wrap.dart';
import '../model/ScreenModel.dart';
import '../utils/json_util.dart';

class OwlActionBuilder {
  static Widget build(
      {Key key,
      Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss,
      ScreenModel model,
      Map componentModel,
      Map<String, dynamic> parentNode,
      Widget parentWidget,
      Map<dynamic, List<Widget>> cacheContext}) {
    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    nodeName = node.keys.first;
    var childNode = node[nodeName];
    Widget widget;
    Map oldComponentModel = model.componentModel;
    model.componentModel = componentModel;

    switch (nodeName) {
      case "action":
        widget = OwlView(
            key: key,
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);
        break;
    }
    Widget w = null;
    if (widget is OwlComponent) {
      w = (widget as OwlComponent)
          .wrapGestureDetector(widget, childNode, model);
    } else if (widget is OwlStatefulComponent) {
      w = (widget as OwlStatefulComponent)
          .wrapGestureDetector(widget, childNode, model);
    }

    model.componentModel = oldComponentModel;
    return w;
  }

  static List<Widget> buildList(
      {Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss,
      ScreenModel model,
      componentModel,
      parentNode,
      parentWidget,
      Map<dynamic, List<Widget>> cacheContext}) {
    if (cacheContext.containsKey(node)) {
      return cacheContext[node];
    }
    List<Widget> result = _buildList(
        node: node,
        pageCss: pageCss,
        appCss: appCss,
        model: model,
        componentModel: componentModel,
        parentNode: parentNode,
        parentWidget: parentWidget,
        cacheContext: cacheContext);
    cacheContext[node] = result;
    return result;
  }

  static List<Widget> _buildList(
      {Map<String, dynamic> node,
      Map<String, dynamic> pageCss,
      Map<String, dynamic> appCss,
      ScreenModel model,
      componentModel,
      parentNode,
      parentWidget,
      Map<dynamic, List<Widget>> cacheContext}) {
    List<Widget> result = [];

    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    model.componentModel = componentModel;
    nodeName = node.keys.first;
    if (nodeName == '_text') {
      result.add(OwlText(
          node: node,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: parentNode,
          parentWidget: parentWidget,
          cacheContext: cacheContext));
      return result;
    }
    var childNode = node[nodeName];

    var wxif = getPlainAttr(childNode, 'wx:if');
    if (wxif != null) {
      //获取 {{ xxx }} 中间的xxx部分
      String wxifExpr = getMiddle(wxif, "{{", "}}");
      bool brevert = false;
      if (wxifExpr.startsWith("!")) {
        wxifExpr = wxifExpr.substring(1);
        brevert = true;
      }
      var r = model.getData(wxifExpr);
      if (r == false || r == 'false' || r == null) {
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

    var wxfor = getPlainAttr(childNode, 'wx:for');
    if (wxfor != null) {
      var wxforItem = getPlainAttr(childNode, 'wx:for-item');
      var wxforIndex = getPlainAttr(childNode, 'wx:for-index');

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
          Widget widget = OwlActionBuilder.build(
              node: node,
              pageCss: pageCss,
              appCss: appCss,
              model: model,
              componentModel: newComponentModel,
              parentNode: parentNode,
              parentWidget: parentWidget,
              cacheContext: {});
          if (widget != null) {
            result.add(widget);
          }
        }
      } else {
        return result;
      }
    } else {
      //no for statement
      Widget widget = OwlActionBuilder.build(
          node: node,
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: parentNode,
          parentWidget: parentWidget,
          cacheContext: cacheContext);
      if (widget != null) {
        result.add(widget);
      }
    }
    return result;
  }
}
