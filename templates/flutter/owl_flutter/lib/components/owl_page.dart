import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:owl_flutter/owl_generated/owl_app.dart';

import '../utils/owl.dart';

class OwlPage extends OwlComponent {
  OwlPage({Key key, node, pageCss, appCss, pageJson, model})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            pageJson: pageJson,
            model: model);

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
    return OwlComponentBuilder.build(
        node: node, pageCss: pageCss, appCss: appCss);
    /*return Center(
      child: Text('Hello World'),
    );*/
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
