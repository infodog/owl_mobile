import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_statefulcomponent.dart';
import '../utils/json_util.dart';

class OwlSwiper extends OwlStatefulComponent {
  OwlSwiper(
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
  OwlSwiperState createState() {
    return OwlSwiperState();
  }
}

class OwlSwiperState extends State<OwlSwiper> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List rules = widget.getNodeCssRulesEx(widget.node, widget.pageCss);
    //搜索width和height
    String width = widget.getRuleValueEx(rules, "width");
    String height = widget.getRuleValueEx(rules, "height");
    var children = widget.node['children'];
    List<Widget> swiperItems = [];
    for (int i = 0; i < children.length; i++) {
      var childNode = children[i];
      swiperItems.addAll(OwlComponentBuilder.buildList(
          node: childNode,
          pageCss: widget.pageCss,
          appCss: widget.appCss,
          model: widget.model,
          componentModel: widget.componentModel,
          parentNode: widget.node,
          parentWidget: widget,
          cacheContext: widget.cacheContext));
    }

    String indicatorDots =
        widget.renderText(getAttr(widget.node, "indicator-dots"));
    String indicatorColor =
        widget.renderText(getAttr(widget.node, "inicator-color"));
    String indicatorActiveColor =
        widget.renderText(getAttr(widget.node, "indicator-active-color"));
    String autoplay = widget.renderText(getAttr(widget.node, "autoplay"));
    String current = widget.renderText(getAttr(widget.node, "current"));
    String interval = widget.renderText(getAttr(widget.node, "interval"));
    String duration = widget.renderText(getAttr(widget.node, "duration"));
    String circular = widget.renderText(getAttr(widget.node, "circular"));
    String vertical = widget.renderText(getAttr(widget.node, "vertical"));
    String previousMargin =
        widget.renderText(getAttr(widget.node, "previous-margin"));
    String nextMargin = widget.renderText(getAttr(widget.node, "next-margin"));
    String displayMultipleItems =
        widget.renderText(getAttr(widget.node, "display-multiple-items"));
    String bindchange = widget.renderText(getAttr(widget.node, "bindchange"));

    if (interval == null) {
      interval = '5000';
    }
    if (duration == null) {
      duration = '500';
    }

    return new Container(
        height: widget.lp(height, 200.0),
        width: widget.lp(width, 320.0),
//        color: Color.fromARGB(50, 128, 0, 0),
        child: Swiper(
          indicatorLayout: PageIndicatorLayout.SCALE,
          itemBuilder: (BuildContext context, int index) {
            return swiperItems[index];
          },
          itemCount: swiperItems.length,
          autoplay: autoplay == 'true',
          viewportFraction: 1.0,
          scale: 1.0,
          containerHeight: widget.lp(height, 200.0),
          containerWidth: widget.lp(width, 320.0),
        ));
  }
}
