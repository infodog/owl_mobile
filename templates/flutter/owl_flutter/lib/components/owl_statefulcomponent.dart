import 'package:flutter/material.dart';
import 'package:owl_flutter/utils/uitools.dart';

import '../model/ScreenModel.dart';

abstract class OwlStatefulComponent extends StatefulWidget with UiTools {
  OwlStatefulComponent(
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
    if(model!=null){
      model.componentModel = componentModel;
    }
    
  }

  final Map<String, dynamic> node;
  final Map<String, dynamic> pageCss;
  final Map<String, dynamic> appCss;
  final Map<String, dynamic> pageJson;

  final Map<String, dynamic> parentNode;
  final Widget parentWidget;
  Map<dynamic, List<Widget>> cacheContext;
}
