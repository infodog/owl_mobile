import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:owl_flutter/components/owl_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils/owl.dart';

class __pageName extends StatelessWidget {
  __pageName({this.params, this.appCss});

  var pageNode = __pageNode;
  var pageCss = __pageCss;
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
              pageCss: pageCss,
              appCss: appCss);
        },
      ),
    );
  }
}

class __ScreenModel extends Model {
  static dynamic Page(modelConfig) {
    return modelConfig;
  }

  __ScreenModel(this.params) {
    this.pageJs = __pageJs;
  }
  var pageModel;
  Map<String, String> params;
  var pageJs;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    Function(dynamic) f = this.pageJs['onLoad'];
    f({});
  }
}
