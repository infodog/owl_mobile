import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';

import '../utils/json_util.dart';

class OwlPage extends OwlComponent {
  OwlPage({Key key, node, pageCss, appCss})
      : super(key: key, node: node, pageCss: pageCss, appCss: appCss);

  AppBar buildAppBar() {
    String title = getAttr(node, "title");
    return AppBar(title: new Text(title));
  }

  Widget buildBody() {
    List children = node["children"];
    if (children.length == 1) {
      var childNode = children[0];
      return OwlComponentBuilder.build(
          node: childNode, pageCss: pageCss, appCss: appCss);
    } else {
      List<Widget> listChildren = children.map((child) =>
          OwlComponentBuilder.build(
              node: child, pageCss: pageCss, appCss: appCss));
      return ListView(children: listChildren);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: buildAppBar(), body: buildBody());
  }
}
