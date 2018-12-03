import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_statefulcomponent.dart';
import '../components/owl_swiper_item.dart';

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

    List rules = widget.getNodeCssRulesEx(widget.node, widget.pageCss);
    //搜索width和height
    String width = widget.getRuleValueEx(rules, "width");
    String height = widget.getRuleValueEx(rules, "height");
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
          cacheContext: widget.cacheContext);
      for (int j = 0; j < swiperItems.length; j++) {
        OwlSwiperItem item = swiperItems[j];
        if (item != null) {
          images.add(item.getImage());
        }
      }
    }

    String indicatorDots =
        widget.renderText(widget.getAttr(widget.node, "indicator-dots"));
    String indicatorColor =
        widget.renderText(widget.getAttr(widget.node, "inicator-color"));
    String indicatorActiveColor = widget
        .renderText(widget.getAttr(widget.node, "indicator-active-color"));
    String autoplay =
        widget.renderText(widget.getAttr(widget.node, "autoplay"));
    String current = widget.renderText(widget.getAttr(widget.node, "current"));
    String interval =
        widget.renderText(widget.getAttr(widget.node, "interval"));
    String duration =
        widget.renderText(widget.getAttr(widget.node, "duration"));
    String circular =
        widget.renderText(widget.getAttr(widget.node, "circular"));
    String vertical =
        widget.renderText(widget.getAttr(widget.node, "vertical"));
    String previousMargin =
        widget.renderText(widget.getAttr(widget.node, "previous-margin"));
    String nextMargin =
        widget.renderText(widget.getAttr(widget.node, "next-margin"));
    String displayMultipleItems = widget
        .renderText(widget.getAttr(widget.node, "display-multiple-items"));
    String bindchange =
        widget.renderText(widget.getAttr(widget.node, "bindchange"));

    if (interval == null) {
      interval = '5000';
    }
    if (duration == null) {
      duration = '500';
    }

    return new Container(
        height: widget.lp(height, 200.0),
        width: widget.lp(width, 320.0),
        color: Color.fromARGB(50, 128, 50, 50),
        child: new Carousel(
            images: images,
            dotSize: 4.0,
            dotSpacing: 15.0,
            boxFit: BoxFit.fitWidth,
            showIndicator: indicatorDots == 'true',
            dotColor: widget.fromCssColor(indicatorActiveColor) == null
                ? widget.fromCssColor("#ffffff")
                : widget.fromCssColor(indicatorActiveColor),
            indicatorBgPadding: 5.0,
            dotBgColor: widget.fromCssColor(indicatorColor),
            borderRadius: false,
            autoplay: autoplay == 'true',
            autoplayDuration: Duration(milliseconds: int.parse(interval)),
            animationDuration: Duration(milliseconds: int.parse(duration))));
  }
}
