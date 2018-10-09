import 'package:flutter/material.dart';
import 'package:owl_flutter/model/ScreenModel.dart';
import 'package:reflected_mustache/mustache.dart';

abstract class OwlStatefulComponent extends StatefulWidget {
  OwlStatefulComponent(
      {Key key,
      this.node,
      this.pageCss,
      this.appCss,
      this.pageJson,
      this.model,
      this.componentModel})
      : super(key: key);

  final Map<String, dynamic> node;
  final Map<String, dynamic> pageCss;
  final Map<String, dynamic> appCss;
  final Map<String, dynamic> pageJson;
  final ScreenModel model;
  final Map componentModel;

  String renderText(String text) {
    Template template = new Template(text);
    if (componentModel != null) {
      if (componentModel['includedScreenModel'] == true) {
        //do nothing
      } else {
        var screenModel = model.pageJs['data'];
        screenModel.forEach((k, v) {
          if (!componentModel.containsKey(k)) {
            componentModel[k] = v;
          }
        });
        componentModel['includedScreenModel'] = true;
      }
      return template.renderString(componentModel);
    } else {
      var pageJs = model.pageJs;
      return template.renderString(pageJs['data']);
    }
  }
}
