import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OwlWebWidget extends OwlComponent {
  OwlWebWidget(
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
    // TODO: implement build
    String src = getAttr(node, "src");
    WebView w = WebView(
        initialUrl: src,
        javaScriptMode: JavaScriptMode.unrestricted,
        gestureRecognizers: [
          Factory<VerticalDragGestureRecognizer>(() {
            return VerticalDragGestureRecognizer();
          }),
          Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer())
        ].toSet());

    return Flexible(child: w, fit: FlexFit.tight, flex: 1);
  }
}
