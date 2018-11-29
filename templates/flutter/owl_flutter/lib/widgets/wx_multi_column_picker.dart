import 'package:flutter/cupertino.dart';

const double _kItemExtent = 48.0;
const double _kPickerWidth = 330.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 1.05;
const double _kPickerPadSize = 8.0;

// Considers setting the default background color from the theme, in the future.
const Color _kBackgroundColor = CupertinoColors.white;

typedef _ColumnBuilder = Widget Function(
    double offAxisFraction, TransitionBuilder itemPositioningBuilder);
typedef ChangeListener = void Function(List<int> value);
typedef ColumnChangeListener = void Function(int columnIndex, int valueIndex);

class WxMultiColumnPicker extends StatefulWidget {
  WxMultiColumnPicker(
      {this.range,
      this.value,
      this.columnChangeListener,
      this.rangeKey,
      this.columnsCount}) {}

  List<dynamic> range;
  String rangeKey;
  List<int> value; //value 每一项的值表示选择了 range 对应项中的第几个（下标从 0 开始）
  int columnsCount;
  ChangeListener changeListener;
  ColumnChangeListener columnChangeListener;

  @override
  State<StatefulWidget> createState() {
    return WxMultiColumnPickerState();
  }
}

class WxMultiColumnPickerState extends State<WxMultiColumnPicker> {
  @override
  void initState() {
    effectiveColumns = [widget.range];
    columnValues = widget.value;
    controllers = new List(widget.columnsCount);
    for (int i = 0; i < widget.columnsCount; i++) {
      int initialItem = 0;
      if (widget.value != null) {
        initialItem = widget.value[i];
      }

      FixedExtentScrollController controller =
          FixedExtentScrollController(initialItem: initialItem);
      controllers[i] = controller;
    }
  }

  List<List<dynamic>> effectiveColumns;
  List<int> columnValues;
  List<FixedExtentScrollController> controllers;
  // Builds a text label with customized scale factor and font weight.

  List getItems(int index) {
    if (index == 0) {
      return effectiveColumns[0];
    } else {
      int parentIndex = index - 1;
      assert(effectiveColumns.length > parentIndex);
      int parentValueIndex = columnValues[parentIndex];
      Map parentItem = effectiveColumns[parentIndex][parentValueIndex];
      if (parentItem != null) {
        var curItems = parentItem['children'];
        if (curItems == null) {
          curItems = [];
        }
        if (curItems.length == 0) {
          curItems = [parentItem];
        }
        if (effectiveColumns.length <= index) {
          effectiveColumns.add(curItems);
        } else {
          effectiveColumns[index] = curItems;
        }
        return curItems;
      }
      return [];
    }
  }

  Widget _buildPicker(int index) {
    List<Widget> pickerItems = [];
    List items = getItems(index);
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      String itemText;
      if (item is String) {
        itemText = item;
      } else if (item is Map) {
        itemText = item[widget.rangeKey];
      }

      pickerItems.add(Semantics(
        label: itemText,
        excludeSemantics: true,
        child: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: _kPickerPadSize),
          child: Container(
            alignment: Alignment.centerRight,
            // Adds some spaces between words.
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(itemText, maxLines: 1),
          ),
        ),
      ));
    }

    return CupertinoPicker(
        scrollController: controllers[index],
        offAxisFraction: -0.5,
        itemExtent: _kItemExtent,
        backgroundColor: _kBackgroundColor,
        onSelectedItemChanged: (int valueIndex) {
          setState(() {
            if (widget.columnChangeListener != null) {
              widget.columnChangeListener(index, valueIndex);
              for (int i = index + 1; i < widget.columnsCount; i++) {
                FixedExtentScrollController c = controllers[i];
                c.animateToItem(0,
                    duration: Duration(milliseconds: 20), curve: Curves.ease);
              }
            }
          });
        },
        children: pickerItems);
  }

  Widget _buildColumn(int index) {
    return _buildPicker(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pickers = [];
    for (int i = 0; i < widget.columnsCount; i++) {
//      print(i.toString() + "aaaaaa");
      pickers.add(Expanded(child: _buildColumn(i)));
    }
    return MediaQuery(
      data: const MediaQueryData(
        // The native iOS picker's text scaling is fixed, so we will also fix it
        // as well in our picker.
        textScaleFactor: 1.0,
      ),
      child: Row(children: pickers),
    );
  }
}
