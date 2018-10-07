import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:owl_flutter/components/owl_page.dart';
import 'package:owl_flutter/model/ScreenModel.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils/owl.dart';

class __pageName extends StatelessWidget {
  __pageName({this.params, this.appCss});

  var pageNode = __pageNode;
  var pageCss = __pageCss;
  var pageJson = __pageConfig;
  var appCss;
  Map<String, String> params;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<__ScreenModel>(
      model: __ScreenModel(this.params),
      child: ScopedModelDescendant<__ScreenModel>(
        builder: (context, child, model) {
          return new OwlPage(
              node: pageNode,
              key: Key('__pageName'),
              pageJson: pageJson,
              pageCss: pageCss,
              appCss: appCss,
              model: model);
        },
      ),
    );
  }
}

class __ScreenModel extends ScreenModel {
  static dynamic Page(var modelConfig) {
    return modelConfig;
  }

  __ScreenModel(params) : super(params) {
    this.pageJs = __pageJs;
  }
}
