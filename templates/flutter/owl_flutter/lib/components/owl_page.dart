import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_scroll_view.dart';

import '../components/owl_componet.dart';
import '../owl_generated/owl_app.dart';
import '../utils/owl.dart';
import '../utils/uitools.dart';

class OwlPage extends OwlComponent {
  OwlPage(
      {Key key,
      node,
      pageCss,
      appCss,
      pageJson,
      model,
      componentModel,
      parentNode,
      parentWidget,
      this.bottomBar,
      cacheContext})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            pageJson: pageJson,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

  final Widget bottomBar;
  AppBar buildAppBar(context) {
    OwlApp app = owl.getApplication();
    String title = null;

    if (pageJson != null) {
      title = pageJson['navigationBarTitleText'];
    }

    if (title == null) {
      if (app.appJson['window'] != null &&
          app.appJson['window']['navigationBarTitleText'] != null) {
        title = app.appJson['window']['navigationBarTitleText'];
      }
    }
    if (title == null) {
      title = 'owlmobile';
    }
    String backgroundColor;
    if (app.appJson['window'] != null) {
      backgroundColor = app.appJson['window']['navigationBarBackgroundColor'];
    }
    if (pageJson['navigationBarBackgroundColor'] != null) {
      backgroundColor = pageJson['navigationBarBackgroundColor'];
    }

    String navigationBarTextStyle =
        app.appJson['window']['navigationBarTextStyle'];
    if (pageJson['navigationBarTextStyle'] != null) {
      navigationBarTextStyle = pageJson['navigationBarTextStyle'];
    }

    Color titleColor = fromCssColor("#000000");
    if (navigationBarTextStyle == 'white') {
      titleColor = fromCssColor("#ffffff");
    }

    return AppBar(
      title: new Text(title),
      backgroundColor: fromCssColor(backgroundColor),
      elevation: 0.0,
      textTheme: TextTheme(
          title: TextStyle(
              color: titleColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
    );


  }

  Widget _buildWidget(BuildContext context) {
    setScreenWidth(context);
    String alignment = getAttr(node, 'alignment');

    var fixednodes = [];
    var nonFixedNodes = [];
    List<Widget> childWidgets = [];
    List<Widget> fixedWidgets = [];
    Map<Widget, int> widget2zindex = {};

    String rootNodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    rootNodeName = node.keys.first;
    var children = node[rootNodeName]['children'];
    for (var i = 0; i < children.length; i++) {
      Map<String, dynamic> child = children[i];
      var nodeName = child.keys.first;
      if (child[nodeName] is Map) {
        List childRules = getNodeCssRulesEx(child[nodeName], pageCss);
        var position = getRuleValueEx(childRules, 'position');
        if (position == 'absolute' || position == 'fixed') {
          fixednodes.add(child);
          var zIndexStr = getRuleValueEx(childRules, 'z-index');
          int zIndex = 0;
          if (zIndexStr != null) {
            zIndex = int.parse(zIndexStr);
          }
          var widgets = OwlComponentBuilder.buildList(
              node: child,
              pageCss: pageCss,
              appCss: appCss,
              model: model,
              componentModel: componentModel,
              parentNode: node,
              parentWidget: this,
              cacheContext: cacheContext);
          fixedWidgets.addAll(widgets);

          for (var j = 0; j < widgets.length; j++) {
            widget2zindex[widgets[j]] = zIndex;
          }
        } else {
          nonFixedNodes.add(child);
          var widgets = OwlComponentBuilder.buildList(
              node: child,
              pageCss: pageCss,
              appCss: appCss,
              model: model,
              componentModel: componentModel,
              parentNode: node,
              parentWidget: this,
              cacheContext: cacheContext);
          childWidgets.addAll(widgets);
        }
      } else {
        nonFixedNodes.add(child);
        var widgets = OwlComponentBuilder.buildList(
            node: child,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: node,
            parentWidget: this,
            cacheContext: cacheContext);
        childWidgets.addAll(widgets);
      }
    }

    List rules = getNodeCssRulesEx(node[rootNodeName], pageCss);
    //搜索width和height
    String width = getRuleValueEx(rules, "width");
    double lpWidth = lp(width, null);
    String height = getRuleValueEx(rules, "height");
    String color = getRuleValueEx(rules, "color");
    String backgroundColor = getRuleValueEx(rules, 'background-color');

    String minWidth = getRuleValueEx(rules, "min-width");
    String maxWidth = getRuleValueEx(rules, "max-width");
    String minHeight = getRuleValueEx(rules, "min-height");
    String maxHeight = getRuleValueEx(rules, "max-height");
    String borderRadius = getRuleValueEx(rules, "border-radius");

    String backgroundImage = getRuleValueEx(rules, "background-image");
    String backgroundPosition = getRuleValueEx(rules, "background-position");
    String backgroundRepeat = getRuleValueEx(rules, "background-repeat");
    String backgroundSize = getRuleValueEx(rules, 'background-size');

    String position = getRuleValueEx(rules, "position");

    Color bColor = fromCssColor(backgroundColor);
    Border border = getBorder(rules);
    String className = getAttr(node, 'class'); //{{aaaa}} => 1

    String flexDirection = getRuleValueEx(rules, "flex-direction");
    String justifyContent = getRuleValueEx(rules, "justify-content");
    String alignItems = getRuleValueEx(rules, "align-items");

    String boxShadow = getRuleValueEx(rules, 'box-shadow');
    List<BoxShadow> shadows = parseBoxShadow(boxShadow);

    String scrollX = getAttr(node, 'scroll-x');
    String scrollY = getAttr(node, 'scroll-y');
    Axis scrollDirection = Axis.vertical;
    if (scrollX == 'true') {
      scrollDirection = Axis.horizontal;
    } else if (scrollY == 'true') {
      scrollDirection = Axis.vertical;
    }

    Widget container = Container(
        key: ValueKey(className),
        child: wrapFlex(
            children: childWidgets,
            flexDirection: flexDirection,
            justifyContent: justifyContent,
            alignItems: alignItems),
        width: lp(width, null),
        height: lp(height, null),
//        alignment: Alignment.topLeft,
        padding: getPadding(rules),
        margin: getMargin(rules),
        decoration: BoxDecoration(
            color: bColor,
            image: createDecorationImage(
                backgroundImage: backgroundImage,
                backgroundPosition: backgroundPosition,
                backgroundSize: backgroundSize,
                backgroundRepeat: backgroundRepeat),
            border: border,
            boxShadow: shadows,
            borderRadius: borderRadius == null
                ? null
                : BorderRadius.circular(lp(borderRadius, 0.0))),
        constraints: BoxConstraints(
            minWidth: lp(minWidth, 0.0),
            minHeight: lp(minHeight, 0.0),
            maxWidth: lp(maxWidth, double.infinity),
            maxHeight: lp(maxHeight, double.infinity)));

    Widget realView = null;
    if (hasTextStyles(rules)) {
      Color textcolor = fromCssColor(color);
      var fontWeight = getRuleValueEx(rules, "font-weight");
      var fontSize = getRuleValueEx(rules, "font-size");
      var fontFamily = getRuleValueEx(rules, "font-family");
      var letterSpacing = getRuleValueEx(rules, "letter-spacing");
      var fontStyle = getRuleValueEx(rules, "font-style");
      var textOverflow = getRuleValueEx(rules, "text-overflow");
      var maxLines = getRuleValueEx(rules, "max-lines");
      var lineHeight = getRuleValueEx(rules, 'line-height');
      var textAlign = getRuleValueEx(rules, 'text-align');

      TextStyle style;

      if (lineHeight != null) {
        double effectiveFontSize =
            lp(fontSize, null) ?? DefaultTextStyle.of(context).style.fontSize;
        double height = lp(lineHeight, null) / effectiveFontSize;
        style = TextStyle(
            color: textcolor,
            fontWeight: getFontWeight(fontWeight),
            fontSize: lp(fontSize, null),
            fontFamily: fontFamily,
            height: height,
            letterSpacing: lp(letterSpacing, null),
            fontStyle:
                fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);
      } else {
        style = TextStyle(
            color: textcolor,
            fontWeight: getFontWeight(fontWeight),
            fontSize: lp(fontSize, null),
            fontFamily: fontFamily,
            letterSpacing: lp(letterSpacing, null),
            fontStyle:
                fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);
      }

      realView = DefaultTextStyle(
          child: container,
          textAlign: getTextAlign(textAlign) == null
              ? DefaultTextStyle.of(context).textAlign
              : getTextAlign(textAlign),
          style: DefaultTextStyle.of(context).style.merge(style),
          overflow: getTextOverflow(textOverflow),
          maxLines: maxLines == null ? null : int.parse(maxLines));
    } else {
      realView = container;
    }

    Widget v = ListView(children: [realView]);
    String screen = getRuleValueEx(rules, 'screen-mode');
    if (screen == 'full') {
      v = SizedBox.expand(child: realView);
    }
    //检查下面的子元素是否有position=absolute
    if (fixedWidgets.length > 0) {
      List<Widget> stackChildren = [v];
      widget2zindex[v] = 0;

      stackChildren.addAll(fixedWidgets);
      stackChildren.sort((w1, w2) {
        return widget2zindex[w1].compareTo(widget2zindex[w2]);
      });
      return Stack(children: stackChildren);
    } else {
      return v;
    }
  }


  Widget buildBody(BuildContext context) {
    String nodeName = "";
    if (node.keys.length == 0) {
      return null;
    }
    nodeName = node.keys.first;
    var childNode = node[nodeName];
    var childrenBody = OwlScrollView(
        node: childNode,
        pageCss: pageCss,
        appCss: appCss,
        model: model,
        componentModel: componentModel,
        parentNode: node,
        parentWidget: this,
        cacheContext: cacheContext);

//    return childrenBody;
    return _buildWidget(context);
  }


  Future<void> _refresh() {
    var onPullDownRefresh = model.pageJs['onPullDownRefresh'];
    if (onPullDownRefresh != null) {
      return Future(onPullDownRefresh);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: buildAppBar(context),
        body: RefreshIndicator(onRefresh: _refresh, child: buildBody(context)),
        backgroundColor: Color(0xffffffff),
        bottomNavigationBar: bottomBar);
  }
}
