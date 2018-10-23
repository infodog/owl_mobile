import 'package:flutter/cupertino.dart';
{{each pages as value}}import '{{value.className}}.dart';
  {{/each}}

  var home_route='{{homeUrl}}';




Widget getScreen(String path, Map<dynamic,dynamic> params, Map<String, dynamic> appCss) {
  switch (path) {
    {{each pages as value}}
    case '{{value.path}}': return {{value.className}}(params:params, appCss:appCss,url:'{{value.path}}');
    {{/each}}
  }
}