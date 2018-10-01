import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';

import '../utils/json_util.dart';

class OwlPage extends OwlComponent {
  OwlPage({Key key, node, pageCss, appCss})
      : super(key: key, node: node, pageCss: pageCss, appCss: appCss);

  AppBar buildAppBar() {
    String title = getAttr(node, "title");
    if (title == null) {
      title = 'owlmobile2333';
    }
    return AppBar(title: new Text(title));
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
    return new Scaffold(appBar: buildAppBar(), body: buildBody());
  }
}
