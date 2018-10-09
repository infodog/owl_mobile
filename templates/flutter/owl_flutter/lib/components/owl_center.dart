import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';

class OwlCenter extends OwlComponent {
  OwlCenter({Key key, node, pageCss, appCss, model, componentModel})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);

  @override
  Widget build(BuildContext context) {
    List children = node['children'];
    assert(children != null);
    assert(children.length == 1);
    List<Widget> childWidgets = OwlComponentBuilder.buildList(
        node: children[0],
        pageCss: pageCss,
        appCss: appCss,
        model: model,
        componentModel: componentModel);
    if (childWidgets.length >= 1) {
      return Center(child: childWidgets[0]);
    }
    return FittedBox();
  }
}
