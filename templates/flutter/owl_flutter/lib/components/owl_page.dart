import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:owl_flutter/owl_generated/owl_app.dart';
import 'package:owl_flutter/utils/uitools.dart';

import '../utils/owl.dart';

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
      parentWidget})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            pageJson: pageJson,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget);

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
    if (pageJson['backgroundColor'] != null) {
      backgroundColor = pageJson['backgroundColor'];
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
    var children = node['view']['children'];

    var fixednodes = [];
    var nonFixedNodes = [];
    for (var i = 0; i < children.length; i++) {
      Map<String, dynamic> child = children[i];
      var nodeName = child.keys.first;

      var position = getRuleValue(child[nodeName]['rules'], 'position');
      print("i=" +
          i.toString() +
          " position=" +
          (position == null ? 'null' : position));
      if (position == 'fixed') {
        fixednodes.add(child);
      } else {
        nonFixedNodes.add(child);
      }
    }
    if (fixednodes.length == 0) {
//      print('fixednodes.lengt=0');
      return ListView(
          children: OwlComponentBuilder.buildList(
              node: node,
              pageCss: pageCss,
              appCss: appCss,
              model: model,
              componentModel: componentModel,
              parentNode: node,
              parentWidget: this));
    } else {
//      print('fixednodes.lengt!=0');
      List<Widget> childWidgets = [];
      List<Widget> fixedWidgets = [];
      for (var i = 0; i < nonFixedNodes.length; i++) {
        var childNode = nonFixedNodes[i];
        childWidgets.addAll(OwlComponentBuilder.buildList(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: node,
            parentWidget: this));
      }

      for (var i = 0; i < fixednodes.length; i++) {
        var childNode = fixednodes[i];
        fixedWidgets.addAll(OwlComponentBuilder.buildList(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: node,
            parentWidget: this));
      }

      List<Widget> stackChildren = [ListView(children: childWidgets)];
      stackChildren.addAll(fixedWidgets);
      return Stack(children: stackChildren);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      backgroundColor: Color(0xffffffff),
    );
  }
}
