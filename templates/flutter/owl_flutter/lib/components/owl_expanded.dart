import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';

class OwlExpanded extends OwlComponent {
  OwlExpanded(
      {Key key,
      node,
      pageCss,
      appCss,
      model,
      componentModel,
      parentNode,
      parentWidget})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget);

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
        parentWidget: this);
    if (childWidgets.length > 0) {
      return Expanded(child: childWidgets[0]);
    }
    return null;
  }
}
