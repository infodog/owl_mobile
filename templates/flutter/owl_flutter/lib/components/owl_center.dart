import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './owl_componet.dart';
import '../builders/owl_component_builder.dart';

class OwlCenter extends OwlComponent {
  OwlCenter(
      {Key key,
      node,
      pageCss,
      appCss,
      model,
      componentModel,
      parentNode,
      parentWidget,
      cacheContext})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

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
        componentModel: componentModel,
        parentNode: node,
        parentWidget: this,
        cacheContext: cacheContext);
    if (childWidgets.length >= 1) {
      return Center(child: childWidgets[0]);
    }
    return FittedBox();
  }
}
