import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_statefulcomponent.dart';

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
    List<String> imgList;

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
        widget.renderText(widget.getAttr(widget.node, "indicator-dots"));
    String indicatorColor =
        widget.renderText(widget.getAttr(widget.node, "indicator-color"));
    String indicatoractivecolor = widget
        .renderText(widget.getAttr(widget.node, "indicator-active-color"));
    String autoplay =
        widget.renderText(widget.getAttr(widget.node, "autoplay"));
    String interval =
        widget.renderText(widget.getAttr(widget.node, "interval"));
    String duration =
        widget.renderText(widget.getAttr(widget.node, "duration"));
    String current = widget.renderText(widget.getAttr(widget.node, "current"));
    String currentitemid =
        widget.renderText(widget.getAttr(widget.node, "current-item-id"));
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
    String skiphiddenitemlayout = widget
        .renderText(widget.getAttr(widget.node, "skip-hidden-item-layout"));
    String bindchange =
        widget.renderText(widget.getAttr(widget.node, "bindchange"));
    String bindanimationfinish =
        widget.renderText(widget.getAttr(widget.node, "bindanimationfinish"));
    String margin = widget.renderText(widget.getAttr(widget.node, "margin"));
    String Paginationsmargin =
        widget.renderText(widget.getAttr(widget.node, "Paginationsmargin"));
    String paginationmargn =
        widget.renderText(widget.getAttr(widget.node, "pagination-margn"));
    String autoplayDiableOnInteraction = widget.renderText(
        widget.getAttr(widget.node, "autoplayDiableOnInteraction	"));
    String loop = widget.renderText(widget.getAttr(widget.node, "loop"));
    String paginationsize =
        widget.renderText(widget.getAttr(widget.node, "paginationsize"));
    String viewportfraction =
        widget.renderText(widget.getAttr(widget.node, "viewportfraction"));

    bool SwiperPaginations = false;
    if (indicatorDots != null) {
      if (indicatorDots == "true") {
        SwiperPaginations = true;
      } else {
        SwiperPaginations = false;
      }
    } else {
      SwiperPaginations = true;
    }
    Alignment alignment() {
      if (margin != null && margin != "") {
        if (margin == "bottomCenter") {
          return Alignment.bottomCenter;
        } else if (margin == "bottomLeft") {
          return Alignment.bottomLeft;
        } else if (margin == "bottomRight") {
          return Alignment.bottomRight;
        } else if (margin == "centerLeft") {
          return Alignment.centerLeft;
        } else {
          return Alignment.centerRight;
        }
      } else {
        return null;
      }
    }

    //分页
    SwiperPagination Pagination() {
      if (SwiperPaginations == true) {
        return new SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: widget.fromCssColor(indicatoractivecolor),
            color: widget.fromCssColor(indicatorColor),
            activeSize: widget.lp(paginationsize, 12.0),
          ),
          alignment: alignment(),
          margin: EdgeInsets.all(widget.lp(paginationmargn, 50.0)),
        );
      } else {
        return null;
      }
    }

    var isvertical;
    if (vertical == "true") {
      isvertical = Axis.vertical;
    } else if (vertical == "false") {
      isvertical = Axis.horizontal;
    } else {
      isvertical = Axis.horizontal;
    }
    bool isautoplay = false;
    bool isloop = false;
    if (autoplay == "true") {
      isautoplay = true;
    } else {
      isautoplay = false;
    }
    if (interval == null) {
      interval = '5000';
    }
    if (duration == null) {
      duration = '500';
    }
    if (loop == "true") {
      isloop = true;
    } else {
      isloop = false;
    }
    bool isautoplayDiableOnInteraction = false;
    if (autoplayDiableOnInteraction == "true") {
      isautoplayDiableOnInteraction = true;
    }
    isautoplayDiableOnInteraction = false;

    return new Column(
      children: <Widget>[
        new Container(
          height: widget.lp(height, 766.0),
          width: widget.lp(width, 500.0),
          child: Swiper(
//                  indicatorLayout: PageIndicatorLayout.COLOR,
            itemBuilder: (BuildContext context, int index) {
              return swiperItems[index];
            },
            pagination: Pagination(),
            itemCount: swiperItems.length,
            autoplay: isautoplay,
            duration: int.parse(duration),
            transformer: ScaleAndFadeTransformer(fade: 0.9, scale: 0.8),
            viewportFraction: widget.lp(viewportfraction, 0.65),
            containerHeight: widget.lp(height, 430.0),
            containerWidth: widget.lp(width, 213.0),
            scrollDirection: isvertical,
            autoplayDisableOnInteraction: isautoplayDiableOnInteraction,
            autoplayDelay: int.parse(interval),
            loop: isloop,
            /* onIndexChanged: (index){
                    print(index);
                  },*/
            onTap: (index) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
