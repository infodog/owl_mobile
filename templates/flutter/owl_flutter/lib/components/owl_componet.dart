import 'package:flutter/material.dart';
import 'package:owl_flutter/utils/uitools.dart';

import '../model/ScreenModel.dart';

abstract class OwlComponent extends StatelessWidget with UiTools {
  OwlComponent(
      {Key key,
      this.node,
      this.pageCss,
      this.appCss,
      this.pageJson,
      ScreenModel model,
      Map componentModel,
      this.parentNode,
      this.parentWidget,
      this.cacheContext})
      : super(key: key) {
    this.model = model;
    this.componentModel = componentModel;
    if (model != null) {
      model.componentModel = componentModel;
    }
  }

  final Map<dynamic, dynamic> node;
  final Map<dynamic, dynamic> pageCss;
  final Map<dynamic, dynamic> appCss;
  final Map<dynamic, dynamic> pageJson;
  final Map<dynamic, dynamic> parentNode;
  final Widget parentWidget;
  Map<dynamic, List<Widget>> cacheContext;
}
