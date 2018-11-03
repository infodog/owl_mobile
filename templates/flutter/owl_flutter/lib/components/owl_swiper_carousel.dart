import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_statefulcomponent.dart';
import '../components/owl_swiper_item.dart';
import '../utils/json_util.dart';
import '../utils/uitools.dart';

class OwlSwiperCarousel extends OwlStatefulComponent {
  OwlSwiperCarousel(
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
  OwlSwiperCarouselState createState() {
    return OwlSwiperCarouselState();
  }
}

class OwlSwiperCarouselState extends State<OwlSwiperCarousel> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List rules = getNodeCssRules(widget.node, widget.pageCss);
    //搜索width和height
    String width = getRuleValue(rules, "width");
    String height = getRuleValue(rules, "height");
    var children = widget.node['children'];
    List images = [];
    for (int i = 0; i < children.length; i++) {
      var childNode = children[i];
      List<Widget> swiperItems = OwlComponentBuilder.buildList(
          node: childNode,
          pageCss: widget.pageCss,
          appCss: widget.appCss,
          model: widget.model,
          componentModel: widget.componentModel,
          parentNode: widget.node,
          parentWidget: widget,
          cacheContext: cacheContext);
      for (int j = 0; j < swiperItems.length; j++) {
        OwlSwiperItem item = swiperItems[j];
        if (item != null) {
          images.add(item.getImage());
        }
      }
    }

    print("++++++images.length=" + images.length.toString());
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
        height: lp(height, 200.0),
        width: lp(width, 320.0),
        color: Color.fromARGB(50, 128, 50, 50),
        child: new Carousel(
            images: images,
            dotSize: 4.0,
            dotSpacing: 15.0,
            boxFit: BoxFit.fitWidth,
            showIndicator: indicatorDots == 'true',
            dotColor: fromCssColor(indicatorActiveColor) == null
                ? fromCssColor("#ffffff")
                : fromCssColor(indicatorActiveColor),
            indicatorBgPadding: 5.0,
            dotBgColor: fromCssColor(indicatorColor),
            borderRadius: false,
            autoplay: autoplay == 'true',
            autoplayDuration: Duration(milliseconds: int.parse(interval)),
            animationDuration: Duration(milliseconds: int.parse(duration))));
  }
}
