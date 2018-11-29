import 'package:flutter/cupertino.dart';
import 'package:owl_flutter/owl_generated/owl_app.dart';
import 'package:owl_flutter/widgets/wx_multi_column_picker.dart';

typedef RegionChangeListener = void Function(dynamic e);

class WxRegionsPicker extends StatefulWidget {
  WxRegionsPicker({this.value, this.changeListener});
  List<String> value;
  RegionChangeListener changeListener;

  @override
  WxRegionsPickerState createState() {
    return WxRegionsPickerState();
  }
}

class WxRegionsPickerState extends State<WxRegionsPicker> {
  List range;
  String rangeKey;
  List<int> value;
  int columnsCount = 3;

  @override
  void initState() {
    super.initState();
    this.range = OwlApp.regionsMap["root"];
    rangeKey = 'name';

    //将传进来的地区名称，换算成地区在每列中的索引
    value = new List<int>(3);
    List curColumn = range;
    for (int i = 0; i < columnsCount; i++) {
      String curRegionName = widget.value[i];
      for (int j = 0; j < curColumn.length; j++) {
        var regionObj = curColumn[j];
        if (regionObj["name"] == curRegionName) {
          value[i] = j;
          curColumn = regionObj["children"];
          break;
        }
      }
    }
  }

  void notifyChange() {
    List curColumn = range;
    List<String> regionNames = new List<String>(columnsCount);
    List<String> codes = new List<String>(columnsCount);

    for (int i = 0; i < columnsCount; i++) {
      int regionIndex = value[i];
      var regionObj = curColumn[regionIndex];
      regionNames[i] = regionObj['name'];
      codes[i] = regionObj['adcode'].toString();
      curColumn = regionObj['children'];
      if (curColumn == null || curColumn.length == 0) {
        for (int j = i + 1; j < columnsCount; j++) {
          regionNames[j] = regionObj['name'];
          codes[j] = regionObj['adcode'].toString();
        }
        break;
      }
    }

    if (widget.changeListener != null) {
      widget.changeListener({
        "detail": {"value": regionNames, "code": codes}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WxMultiColumnPicker(
      range: this.range,
      value: this.value,
      rangeKey: rangeKey,
      columnsCount: columnsCount,
      columnChangeListener: (int columnIndex, int valueIndex) {
        setState(() {
          print("columnIndex:$columnIndex, valueIndex:$valueIndex");
          value[columnIndex] = valueIndex;
          for (int i = columnIndex + 1; i < columnsCount; i++) {
            value[i] = 0;
          }
          notifyChange();
        });
      },
    );
  }
}
