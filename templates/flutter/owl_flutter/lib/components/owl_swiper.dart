import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_statefulcomponent.dart';
import 'package:owl_flutter/components/owl_swiper_item.dart';
import 'package:owl_flutter/utils/json_util.dart';
import 'package:owl_flutter/utils/uitools.dart';

class OwlSwiper extends OwlStatefulComponent {
  OwlSwiper(
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
  OwlSwiperState createState() {
    return OwlSwiperState();
  }
}

class OwlSwiperState extends State<OwlSwiper> {
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
          parentWidget: widget);
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
//        color: Color.fromARGB(50, 128, 0, 0),
        child: Swiper(
          indicatorLayout: PageIndicatorLayout.SCALE,
          itemBuilder: (BuildContext context, int index) {
            return new Image(
                image: images[index],
                fit: BoxFit.cover,
                width: lp(width, 320.0),
                height: lp(height, 200.0));
          },
          itemCount: images.length,
          autoplay: autoplay == 'true',
          viewportFraction: 1.0,
          scale: 1.0,
          containerHeight: lp(height, 200.0),
          containerWidth: lp(width, 320.0),
        ));
  }
}
