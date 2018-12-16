import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_statefulcomponent.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

import '../owl_generated/owl_app.dart';
import '../utils/owl.dart';

class OwlPage extends OwlStatefulComponent {
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

  @override
  OwlPageState createState() {
    // TODO: implement createState
    return OwlPageState();
  }
}

class OwlPageState extends State<OwlPage> {
  bool hasAppBar = false;

  RefreshController _refreshController;

  Widget _buildHeader(context, mode) {
    return new ClassicIndicator(
        mode: mode,
        releaseText: "放手刷新",
        refreshingText: "刷新中",
        completeText: "刷新完成",
        noDataText: "无更多数据",
        failedText: "刷新失败",
        idleText: "下拉刷新");
  }

  Widget _buildFooter(context, mode) {
    return new ClassicIndicator(
        mode: mode,
        releaseText: "放手获取更多",
        refreshingText: "刷新中",
        completeText: "刷新完成",
        noDataText: "无更多数据",
        failedText: "刷新失败",
        idleText: "上拉下载更多");
  }

  initState() {
    _refreshController = RefreshController();
    widget.model.refreshController = _refreshController;
  }

  AppBar buildAppBar() {
    OwlApp app = Owl.getApplication();
    String title = null;

    if (widget.pageJson == null) {
      hasAppBar = false;
      return null;
    }

    if (widget.pageJson.containsKey('showAppBar') &&
        widget.pageJson['showAppBar'] == false) {
      hasAppBar = false;
      return null;
    }

    if (widget.pageJson.containsKey('showAppBar') == false) {
      hasAppBar = false;
      return null;
    }

    hasAppBar = true;

    if (widget.pageJson != null) {
      title = widget.pageJson['navigationBarTitleText'];
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
    String appBarBackgroundColor;
    if (app.appJson['window'] != null) {
      appBarBackgroundColor =
          app.appJson['window']['navigationBarBackgroundColor'];
    }
    if (widget.pageJson['navigationBarBackgroundColor'] != null) {
      appBarBackgroundColor = widget.pageJson['navigationBarBackgroundColor'];
    }

    String navigationBarTextStyle =
        app.appJson['window']['navigationBarTextStyle'];
    if (widget.pageJson['navigationBarTextStyle'] != null) {
      navigationBarTextStyle = widget.pageJson['navigationBarTextStyle'];
    }

    Color titleColor = widget.fromCssColor("#000000");
    if (navigationBarTextStyle == 'white') {
      titleColor = widget.fromCssColor("#ffffff");
    }

    return AppBar(
      title: new Text(title),
      backgroundColor: widget.fromCssColor(appBarBackgroundColor),
      elevation: 0.0,
      textTheme: TextTheme(
          title: TextStyle(
              color: titleColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWidget(BuildContext context) {
    widget.setScreenWidth(context);
    String alignment = widget.getAttr(widget.node, 'alignment');

    var fixednodes = [];
    var nonFixedNodes = [];
    List<Widget> childWidgets = [];
    List<Widget> fixedWidgets = [];
    Map<Widget, int> widget2zindex = {};

    String rootNodeName = "";
    if (widget.node.keys.length == 0) {
      return null;
    }
    rootNodeName = widget.node.keys.first;
    var children = widget.node[rootNodeName]['children'];
    for (var i = 0; i < children.length; i++) {
      Map<String, dynamic> child = children[i];
      var nodeName = child.keys.first;
      if (child[nodeName] is Map) {
        List childRules =
            widget.getNodeCssRulesEx(child[nodeName], widget.pageCss);
        var position = widget.getRuleValueEx(childRules, 'position');
        if (position == 'absolute' || position == 'fixed') {
          fixednodes.add(child);
          var zIndexStr = widget.getRuleValueEx(childRules, 'z-index');
          int zIndex = 0;
          if (zIndexStr != null) {
            zIndex = int.parse(zIndexStr);
          }
          var widgets = OwlComponentBuilder.buildList(
              node: child,
              pageCss: widget.pageCss,
              appCss: widget.appCss,
              model: widget.model,
              componentModel: widget.componentModel,
              parentNode: widget.node,
              parentWidget: widget,
              cacheContext: widget.cacheContext);
          fixedWidgets.addAll(widgets);

          for (var j = 0; j < widgets.length; j++) {
            widget2zindex[widgets[j]] = zIndex;
          }
        } else {
          nonFixedNodes.add(child);
          var widgets = OwlComponentBuilder.buildList(
              node: child,
              pageCss: widget.pageCss,
              appCss: widget.appCss,
              model: widget.model,
              componentModel: widget.componentModel,
              parentNode: widget.node,
              parentWidget: widget,
              cacheContext: widget.cacheContext);
          childWidgets.addAll(widgets);
        }
      } else {
        nonFixedNodes.add(child);
        var widgets = OwlComponentBuilder.buildList(
            node: child,
            pageCss: widget.pageCss,
            appCss: widget.appCss,
            model: widget.model,
            componentModel: widget.componentModel,
            parentNode: widget.node,
            parentWidget: widget,
            cacheContext: widget.cacheContext);
        childWidgets.addAll(widgets);
      }
    }

    List rules =
        widget.getNodeCssRulesEx(widget.node[rootNodeName], widget.pageCss);
    //搜索width和height
    String width = widget.getRuleValueEx(rules, "width");
    double lpWidth = widget.lp(width, null);
    String height = widget.getRuleValueEx(rules, "height");
    String color = widget.getRuleValueEx(rules, "color");
    String backgroundColor = widget.getRuleValueEx(rules, 'background-color');

    String minWidth = widget.getRuleValueEx(rules, "min-width");
    String maxWidth = widget.getRuleValueEx(rules, "max-width");
    String minHeight = widget.getRuleValueEx(rules, "min-height");
    String maxHeight = widget.getRuleValueEx(rules, "max-height");
    String borderRadius = widget.getRuleValueEx(rules, "border-radius");

    String backgroundImage = widget.getRuleValueEx(rules, "background-image");
    String backgroundPosition =
        widget.getRuleValueEx(rules, "background-position");
    String backgroundRepeat = widget.getRuleValueEx(rules, "background-repeat");
    String backgroundSize = widget.getRuleValueEx(rules, 'background-size');

    String position = widget.getRuleValueEx(rules, "position");

    Color bColor = widget.fromCssColor(backgroundColor);
    Border border = widget.getBorder(rules);
    String className = widget.getAttr(widget.node, 'class'); //{{aaaa}} => 1

    String flexDirection = widget.getRuleValueEx(rules, "flex-direction");
    String justifyContent = widget.getRuleValueEx(rules, "justify-content");
    String alignItems = widget.getRuleValueEx(rules, "align-items");

    String boxShadow = widget.getRuleValueEx(rules, 'box-shadow');
    List<BoxShadow> shadows = widget.parseBoxShadow(boxShadow);

    String scrollX = widget.getAttr(widget.node, 'scroll-x');
    String scrollY = widget.getAttr(widget.node, 'scroll-y');
    Axis scrollDirection = Axis.vertical;
    if (scrollX == 'true') {
      scrollDirection = Axis.horizontal;
    } else if (scrollY == 'true') {
      scrollDirection = Axis.vertical;
    }

    Widget container = Container(
        key: ValueKey(className),
        child: widget.wrapFlex(
            children: childWidgets,
            flexDirection: flexDirection,
            justifyContent: justifyContent,
            alignItems: alignItems),
        width: widget.lp(width, null),
        height: widget.lp(height, null),
//        alignment: Alignment.topLeft,
        padding: widget.getPadding(rules),
        margin: widget.getMargin(rules),
        decoration: BoxDecoration(
            color: bColor,
            image: widget.createDecorationImage(
                backgroundImage: backgroundImage,
                backgroundPosition: backgroundPosition,
                backgroundSize: backgroundSize,
                backgroundRepeat: backgroundRepeat),
            border: border,
            boxShadow: shadows,
            borderRadius: borderRadius == null
                ? null
                : BorderRadius.circular(widget.lp(borderRadius, 0.0))),
        constraints: BoxConstraints(
            minWidth: widget.lp(minWidth, 0.0),
            minHeight: widget.lp(minHeight, 0.0),
            maxWidth: widget.lp(maxWidth, double.infinity),
            maxHeight: widget.lp(maxHeight, double.infinity)));

    Widget realView = null;
    if (widget.hasTextStyles(rules)) {
      Color textcolor = widget.fromCssColor(color);
      var fontWeight = widget.getRuleValueEx(rules, "font-weight");
      var fontSize = widget.getRuleValueEx(rules, "font-size");
      var fontFamily = widget.getRuleValueEx(rules, "font-family");
      var letterSpacing = widget.getRuleValueEx(rules, "letter-spacing");
      var fontStyle = widget.getRuleValueEx(rules, "font-style");
      var textOverflow = widget.getRuleValueEx(rules, "text-overflow");
      var maxLines = widget.getRuleValueEx(rules, "max-lines");
      var lineHeight = widget.getRuleValueEx(rules, 'line-height');
      var textAlign = widget.getRuleValueEx(rules, 'text-align');

      TextStyle style;

      if (lineHeight != null) {
        double effectiveFontSize = widget.lp(fontSize, null) ??
            DefaultTextStyle.of(context).style.fontSize;
        double height = widget.lp(lineHeight, null) / effectiveFontSize;
        style = TextStyle(
            color: textcolor,
            fontWeight: widget.getFontWeight(fontWeight),
            fontSize: widget.lp(fontSize, null),
            fontFamily: fontFamily,
            height: height,
            letterSpacing: widget.lp(letterSpacing, null),
            fontStyle:
                fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);
      } else {
        style = TextStyle(
            color: textcolor,
            fontWeight: widget.getFontWeight(fontWeight),
            fontSize: widget.lp(fontSize, null),
            fontFamily: fontFamily,
            letterSpacing: widget.lp(letterSpacing, null),
            fontStyle:
                fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal);
      }

      realView = DefaultTextStyle(
          child: container,
          textAlign: widget.getTextAlign(textAlign) == null
              ? DefaultTextStyle.of(context).textAlign
              : widget.getTextAlign(textAlign),
          style: DefaultTextStyle.of(context).style.merge(style),
          overflow: widget.getTextOverflow(textOverflow),
          maxLines: maxLines == null ? null : int.parse(maxLines));
    } else {
      realView = container;
    }

    Widget v;
    String screen = widget.getRuleValueEx(rules, 'screen-mode');
    if (screen == 'full') {
      v = SizedBox.expand(child: realView);
    } else {
      v = ListView(children: [realView]);
      bool enablePullDown = false;

      if (widget.pageJson['enablePullDownRefresh'] != null) {
        var onPullDownRefresh = widget.model.pageJs['onPullDownRefresh'];
        if (onPullDownRefresh != null) {
          enablePullDown = true;
        }
      }
      bool enablePullUp = false;
      var onReachBottom = widget.model.pageJs['onReachBottom'];
      if (onReachBottom != null) {
        enablePullUp = true;
      }

      SmartRefresher _smartRefresher = new SmartRefresher(
          enablePullDown: enablePullDown,
          enablePullUp: enablePullUp,
          onRefresh: _onRefresh,
          controller: _refreshController,
          headerBuilder: _buildHeader,
          footerBuilder: _buildFooter,
          headerConfig: RefreshConfig(triggerDistance: 70),
//        onOffsetChange: _onOffsetCallback,
          child: v);
      v = _smartRefresher;
    }

    //检查下面的子元素是否有position=absolute
    Widget finalPage = null;
    if (fixedWidgets.length > 0) {
      List<Widget> stackChildren = [v];
      widget2zindex[v] = 0;

      stackChildren.addAll(fixedWidgets);
      stackChildren.sort((w1, w2) {
        return widget2zindex[w1].compareTo(widget2zindex[w2]);
      });
      finalPage = Stack(children: stackChildren);
    } else {
      finalPage = v;
    }

    if (hasAppBar) {
      return finalPage;
    } else {
      return SafeArea(child: finalPage);
    }
  }

  Widget buildBody(BuildContext context) {
    return _buildWidget(context);
  }

  void _onRefresh(bool up) {
    if (up) {
      var onPullDownRefresh = widget.model.pageJs['onPullDownRefresh'];
      if (onPullDownRefresh != null) {
        onPullDownRefresh();
      }
      Timer(Duration(seconds: 1), () {
        _refreshController.sendBack(up, RefreshStatus.completed);
      });
      print("up....");
    } else {
      var onReachBottom = widget.model.pageJs['onReachBottom'];
      if (onReachBottom != null) {
        onReachBottom();
      }
      Timer(Duration(seconds: 1), () {
        _refreshController.sendBack(up, RefreshStatus.idle);
      });
      print("down....");
    }
  }

  @override
  Widget build(BuildContext context) {
    OwlApp app = Owl.getApplication();
    String backgroundColor;
    if (app.appJson['window'] != null) {
      backgroundColor = app.appJson['window']['backgroundColor'];
    }
    if (widget.pageJson['backgroundColor'] != null) {
      backgroundColor = widget.pageJson['backgroundColor'];
    }

    return new Scaffold(
        appBar: buildAppBar(),
        body: buildBody(context),
        backgroundColor: widget.fromCssColor(backgroundColor),
        bottomNavigationBar: widget.bottomBar);
  }
}
