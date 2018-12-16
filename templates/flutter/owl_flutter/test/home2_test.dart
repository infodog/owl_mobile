import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owl_flutter/components/owl_home.dart';

import '../lib/utils/owl.dart';

void main() {
  testWidgets('home2 smoke test', (WidgetTester tester) async {
    var app = Owl.getApplication();
    // var home2 = pages_home_home2(params:{}, appCss:app.appCss,url:'pages/home/home2');

    var home = MaterialApp(
      title: 'Owl Applications',
      home: OwlHome('pages/home/home2', {}),
    );
    // Build our app and trigger a frame.
    await tester.pumpWidget(home);
  });
}
