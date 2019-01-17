import 'package:flutter/material.dart';
import 'flutter_page1.dart';
void main() {
  runApp(null);
}

class SampleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget widget = MaterialApp(
        title: "heheh",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Page1(),
        );

    return widget;
  }
}

class SampleAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SampleAppPageState();
  }
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title: Text("fucking"),
            ),
        body: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (BuildContext ctx, int pos) {
              return widgets.elementAt(pos);
            },
            ),
        );
  }


  Widget getRow(int i) {
    return Padding(
        child: Text("sasss $i"),
        padding: EdgeInsets.all(10.0),
        );
  }
}