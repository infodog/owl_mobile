import 'package:flutter/cupertino.dart';
import 'package:owl_flutter/components/owl_componet.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OwlQr extends OwlComponent {
  OwlQr(
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
    String size = getAttr(node, "size");
    String value = getAttr(node, "value");
    String backgroudColor = getAttr(node, "backgroundColor");
    String forgroundColor = getAttr(node, "forgroundColor");
    String padding = getAttr(node, "padding");

    double qrSize = lp(size, null);
    double qrPadding = lp(padding, null);
    Color qrBackgroundColor = fromCssColor(backgroudColor);
    Color qrForgroundColor = fromCssColor(forgroundColor);

    return new QrImage(
      data: value,
      size: qrSize,
      padding: EdgeInsets.all(qrPadding),
      backgroundColor: qrBackgroundColor,
      foregroundColor: qrForgroundColor,
    );
  }
}
