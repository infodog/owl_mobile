import 'package:flutter/cupertino.dart';
{{each pages as value}}import '{{value.className}}.dart';
  {{/each}}

  var home_route='{{homeUrl}}';

  List<String>  pageUrls = [];

  void initPageUrls(){
    {{each pages as value}}pageUrls.add('{{value.path}}');
    {{/each}}
  }




Widget getScreen(String path, Map<dynamic,dynamic> params, Map<String, dynamic> appCss) {
  switch (path) {
    {{each pages as value}}
    case '{{value.path}}': return {{value.className}}(params:params, appCss:appCss,url:'{{value.path}}');
    {{/each}}
  }
}