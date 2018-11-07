// This line imports the extension
import 'package:flutter_driver/driver_extension.dart';
import 'package:owl_flutter/main.dart';
import 'package:owl_flutter/owl_generated/owl_route.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` of your app or call `runApp` with whatever widget
  // you are interested in testing.
  appMain(home_route);
}
