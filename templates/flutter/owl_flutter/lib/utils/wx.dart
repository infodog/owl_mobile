import 'package:flutter/cupertino.dart';

import 'owl.dart';

int parseInt(String s) {
  return int.parse(s);
}

class WeiXinAdapter {
  WeiXinAdapter(this.buildContext);

  BuildContext buildContext;

  void navigateTo(o) {
    owl.getApplication().navigateTo(o, buildContext);
  }

  void switchTab(o) {
    owl.getApplication().switchTab(o, buildContext);
  }
}
