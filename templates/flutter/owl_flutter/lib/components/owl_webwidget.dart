import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/components/owl_statefulcomponent.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OwlWebWidget extends OwlStatefulComponent {
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
  OwlWebWidgetState createState() {
    // TODO: implement createState
    return OwlWebWidgetState();
  }
}

class OwlWebWidgetState extends State<OwlWebWidget> {
  WebViewController controller;
  bool captureScroll;
  bool captureTap;
  bool enableJavascript;

  updateSettings() {
    String sCaptureScroll = widget.getAttr(widget.node, "captureScroll");
    if (sCaptureScroll == 'false') {
      captureScroll = false;
    } else {
      captureScroll = true;
    }

    String sCaptureTap = widget.getAttr(widget.node, "captureTap");
    if (sCaptureTap == 'false') {
      captureTap = false;
    } else {
      captureTap = true;
    }

    String sEnableJavascript = widget.getAttr(widget.node, "enableJavascript");
    if (sEnableJavascript == 'false') {
      enableJavascript = false;
    } else {
      enableJavascript = true;
    }
  }

  initState() {
    updateSettings();
  }

  var shouldLoadUrl;
  void onWebViewCreated(WebViewController controller) {
    this.controller = controller;

    if (shouldLoadUrl != null) {
      controller.loadUrl(shouldLoadUrl);
      shouldLoadUrl = null;
    }
  }

  void didUpdateWidget(dynamic oldWidget) {
    String url = widget.getAttr(widget.node, "src");
    if (controller != null) {
      controller.loadUrl(url);
    } else {
      shouldLoadUrl = url;
    }
    updateSettings();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String src = widget.getAttr(widget.node, "src");
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = Set();

    if (captureScroll) {
      gestureRecognizers
        ..add(Factory<VerticalDragGestureRecognizer>(() {
          return VerticalDragGestureRecognizer();
        }))
        ..add(Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer()));
    }

    if (captureTap) {
      gestureRecognizers
          .add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()));
    }

    JavaScriptMode jmode;
    if (enableJavascript) {
      jmode = JavaScriptMode.unrestricted;
    } else {
      jmode = JavaScriptMode.disabled;
    }
    WebView w = WebView(
        initialUrl: src,
        onWebViewCreated: this.onWebViewCreated,
        javaScriptMode: jmode,
        gestureRecognizers: gestureRecognizers);

    return Flexible(child: w, fit: FlexFit.tight, flex: 1);
  }
}
