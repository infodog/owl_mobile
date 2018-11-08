import 'dart:async';

import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
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
  AppBar buildAppBar() {
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

  Widget buildBody() {
    var childrenBody = OwlComponentBuilder.buildList(
        node: node,
        pageCss: pageCss,
        appCss: appCss,
        model: model,
        componentModel: componentModel,
        parentNode: node,
        parentWidget: this,
        cacheContext: cacheContext);

    return PageView(children: childrenBody);
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
        appBar: buildAppBar(),
        body: RefreshIndicator(onRefresh: _refresh, child: buildBody()),
        backgroundColor: Color(0xffffffff),
        bottomNavigationBar: bottomBar);
  }
}
