import 'package:flutter/material.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:owl_flutter/utils/uitools.dart';

class OwlScrollView extends OwlComponent {
  OwlScrollView({Key key, node, pageCss, appCss, model, componentModel})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel);

  @override
  Widget build(BuildContext context) {
    List rules = getNodeCssRules(node, pageCss);
    //搜索width和height

    String paddingLeft = getRuleValue(rules, "padding-left");
    String paddingRight = getRuleValue(rules, "padding-right");
    String paddingTop = getRuleValue(rules, "padding-top");
    String paddingBottom = getRuleValue(rules, "padding-bottom");

    List children = node['children'];
    String scrollX = node['scroll-x'];
    String scrollY = node['scroll-y'];
    assert(children != null);

    List<Widget> listChildren = [];
    for (int i = 0; i < children.length; i++) {
      List<Widget> childWidgets = OwlComponentBuilder.buildList(
          node: children[i],
          pageCss: pageCss,
          appCss: appCss,
          model: model,
          componentModel: componentModel);
      listChildren.addAll(childWidgets);
    }
    Axis scrollDirection = Axis.vertical;
    if (scrollX == 'true') {
      scrollDirection = Axis.horizontal;
    } else if (scrollY == 'true') {
      scrollDirection = Axis.vertical;
    }
    ListView listView = new ListView(
      padding: EdgeInsets.only(
          left: lp(paddingLeft, 0.0),
          right: lp(paddingRight, 0.0),
          top: lp(paddingTop, 0.0),
          bottom: lp(paddingBottom, 0.0)),
      shrinkWrap: true,
      children: listChildren,
      scrollDirection: scrollDirection,
    );
    return listView;
  }
}
