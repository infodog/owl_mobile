import 'package:flutter/cupertino.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';

class OwlForm extends OwlComponent {
  OwlForm(
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

    Widget containerChild = null;

    List<Widget> listChildren = [];
    for (int i = 0; i < children.length; i++) {
      List<Widget> childWidgets = OwlComponentBuilder.buildList(
          node: children[i],
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel,
          parentNode: node,
          parentWidget: this);
      listChildren.addAll(childWidgets);
    }
    if (listChildren.length > 1) {
      containerChild = new Column(children: listChildren);
    } else {
      containerChild = listChildren[0];
    }

    return Form(child: containerChild);
  }
}
