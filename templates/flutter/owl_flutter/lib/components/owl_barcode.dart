import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_flutter/components/owl_componet.dart';

class OwlBarCode extends OwlComponent {
  OwlBarCode(
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
    String lineWidth = getAttr(node, "lineWidth");
    String value = getAttr(node, "value");
    String barHeight = getAttr(node, "barHeight");
    String hasText = getAttr(node, "hasText");
    String codeType = getAttr(node, "codeType");
    double dLineWidth = lp(lineWidth, 2.0);
    bool bHasText = false;
    if (hasText == 'true') {
      bHasText = true;
    } else {
      bHasText = false;
    }

    return new BarCodeImage(
      data: value,
      codeType: codeType ?? BarCodeType.Code128,
      lineWidth: dLineWidth,
      barHeight: lp(barHeight, 100.0),
      hasText: bHasText,
      onError: (error) {
        print("Generate barcode failed. error msg: $error");
      },
    );
  }
}
