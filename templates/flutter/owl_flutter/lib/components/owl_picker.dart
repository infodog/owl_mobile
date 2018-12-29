import 'package:flutter/cupertino.dart';
import 'package:owl_flutter/builders/owl_component_builder.dart';
import 'package:owl_flutter/components/owl_statefulcomponent.dart';
import 'package:owl_flutter/utils/date_util.dart';
import 'package:owl_flutter/utils/json_util.dart';
import 'package:owl_flutter/widgets/wx_multi_column_picker.dart';
import 'package:owl_flutter/widgets/wx_regions_picker.dart';

const double _kPickerSheetHeight = 264.0;
const double _kPickerTopBarHeight = 48.0;
const double _kPickerTopBarLeftPadding = 16.0;
const double _kPickerTopBarRightPadding = 16.0;
const double _kPickerItemHeight = 32.0;

const double _kItemFontSize = 14.0;

const double _kBarFontSize = 18.0;

const Color _kCancelTextColor = Color(0xff333333);
const Color _kOkTextColor = Color(0xff33ff33);

class OwlPicker extends OwlStatefulComponent {
  OwlPicker(
      {Key key,
      node,
      pageCss,
      appCss,
      model,
      componentModel,
      parentNode,
      parentWidget,
      cacheContext,
      this.maxLines = 1})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

  @override
  OwlPickerState createState() {
    return new OwlPickerState();
  }

  int maxLines = 1;
}

class OwlPickerState extends State<OwlPicker> {
  double topBarFontSize;
  double itemFontSize;
  Color okTextColor;
  Color cancelTextColor;

  String mode;
  dynamic value;
  dynamic start;
  dynamic end;
  var range;
  var rangeKey;
  int columnsCount;
  var selectedRegion;
  Function(dynamic e) bindChange;
  Function(dynamic e) bindCancel;
  Function(dynamic e) bindColumnChange;
  bool disabled;

  void _getDataFromModel() {
    mode = widget.getAttr(widget.node, "mode");
    //获取数据
    String disabledString = widget.getAttr(widget.node, "disabled");
    if (disabledString == 'true' || disabledString == 'TRUE') {
      disabled = true;
    } else {
      disabled = false;
    }
    topBarFontSize = _kBarFontSize;
    String strBarFontSize = widget.getAttr(widget.node, "topBarFontSize");
    topBarFontSize = widget.lp(strBarFontSize, _kBarFontSize);

    String strOkTextColor = widget.getAttr(widget.node, "okColor");
    String strCancelTextColor = widget.getAttr(widget.node, "cancelColor");
    okTextColor = widget.fromCssColor(strOkTextColor) ?? _kOkTextColor;
    cancelTextColor =
        widget.fromCssColor(strCancelTextColor) ?? _kCancelTextColor;

    String strItemFontSize = widget.getAttr(widget.node, "itemFontSize");
    this.itemFontSize = widget.lp(strItemFontSize, _kItemFontSize);

    switch (mode) {
      case 'selector':
        String selectorValue = widget.getAttr(widget.node, "value");
        if (selectorValue != null) {
          value = int.parse(selectorValue);
        } else {
          value = null;
        }

        String rangeObjectPath = widget.getPlainAttr(widget.node, "range");
        if (rangeObjectPath.indexOf("{{") == 0) {
          rangeObjectPath = getMiddle(rangeObjectPath, "{{", "}}");
        }
        range = widget.model.getData(rangeObjectPath);
        rangeKey = widget.getAttr(widget.node, "range-key");
        String bindChangeName = widget.getAttr(widget.node, "bindchange");
        bindChange = widget.model.pageJs[bindChangeName];

        String bindCancelName = widget.getAttr(widget.node, "bindcancel");
        bindCancel = widget.model.pageJs[bindCancelName];
        break;
      case 'date':
        String strValue = widget.getAttr(widget.node, "value");
        value = DateTime.tryParse(strValue);
        if (value == null) {
          value = DateTime.now();
        }
        String strStart = widget.getAttr(widget.node, "start");
        if (strStart != null) {
          start = DateTime.tryParse(strStart);
        }
        if (start == null) {
          start = DateTime(2015, 1, 1);
        }

        String strEnd = widget.getAttr(widget.node, "end");
        if (strEnd != null) {
          end = DateTime.tryParse(strEnd);
        }

        if (end == null) {
          end = DateTime(2020, 12, 31);
        }

        //Not supported,do not know how to implement
        String strFields = widget.getAttr(widget.node, "fields");

        String bindChangeName = widget.getAttr(widget.node, "bindchange");
        bindChange = widget.model.pageJs[bindChangeName];

        String bindCancelName = widget.getAttr(widget.node, "bindcancel");
        bindCancel = widget.model.pageJs[bindCancelName];
        break;
      case 'time':
        String strValue = widget.getAttr(widget.node, "value");
        if (strValue != null) {
          List<String> parts = strValue.split(":");
          int hh = int.parse(parts[0]);
          int mm = int.parse(parts[1]);
          value = DateTime(2018, 1, 1, hh, mm);
        }
        String strStart = widget.getAttr(widget.node, "start");
        if (strStart != null) {
          List<String> parts = strStart.split(":");
          int hh = int.parse(parts[0]);
          int mm = int.parse(parts[1]);
          value = DateTime(2018, 1, 1, hh, mm);
        }

        if (start == null) {
          start = DateTime(2018, 1, 1, 0, 0);
        }

        String strEnd = widget.getAttr(widget.node, "end");
        if (strEnd != null) {
          List<String> parts = strStart.split(":");
          int hh = int.parse(parts[0]);
          int mm = int.parse(parts[1]);
          value = DateTime(2018, 1, 1, hh, mm);
        }
        if (end == null) {
          end = DateTime(2018, 1, 1, 23, 59);
        }

        String bindChangeName = widget.getAttr(widget.node, "bindchange");
        bindChange = widget.model.pageJs[bindChangeName];

        String bindCancelName = widget.getAttr(widget.node, "bindcancel");
        bindCancel = widget.model.pageJs[bindCancelName];
        break;
      case 'multiSelector':
        String rangeString = widget.getPlainAttr(widget.node, "range");
        if (rangeString.startsWith("{{")) {
          String objPath = getMiddle(rangeString, "{{", "}}");
          range = widget.model.getData(objPath);
        } else {
          //出错了
          print("range 不能是一个字符串，应该是一个列表，检查是否忘记加上{{ }}");
        }
        rangeKey = widget.getAttr(widget.node, "range-key");

        String bindChangeName = widget.getAttr(widget.node, "bindchange");
        bindChange = widget.model.pageJs[bindChangeName];

        String bindCancelName = widget.getAttr(widget.node, "bindcancel");
        bindCancel = widget.model.pageJs[bindCancelName];

        String bindColumnChangeName =
            widget.getAttr(widget.node, "bindcolumnchange");
        bindColumnChange = widget.model.pageJs[bindColumnChangeName];

        String valueString = widget.getPlainAttr(widget.node, "value");
        if (valueString.startsWith("{{")) {
          String objPath = getMiddle(valueString, "{{", "}}");
          value = widget.model.getData(objPath);
        } else {
          //出错了
          print("value 不能是一个字符串，应该是一个列表，检查是否忘记加上{{ }}");
        }

        String strColumnsCount = widget.getAttr(widget.node, "columnsCount");
        columnsCount = int.parse(strColumnsCount);
        break;
      case 'region':
        String valueString = widget.getPlainAttr(widget.node, "value");
        if (valueString.startsWith("{{")) {
          String objPath = getMiddle(valueString, "{{", "}}");
          value = widget.model.getData(objPath);
        } else {
          //出错了
          print("value 不能是一个字符串，应该是一个列表，检查是否忘记加上{{ }}");
        }
        String bindChangeName = widget.getAttr(widget.node, "bindchange");
        bindChange = widget.model.pageJs[bindChangeName];

        String bindCancelName = widget.getAttr(widget.node, "bindcancel");
        bindCancel = widget.model.pageJs[bindCancelName];

        String strColumnsCount = widget.getAttr(widget.node, "columnsCount");
        columnsCount = int.parse(strColumnsCount);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromModel();
  }

  void didUpdateWidget(Widget oldWidget) {
    _getDataFromModel();
  }

  Widget buildTopBar(BuildContext context) {
    return Container(
      height: _kPickerTopBarHeight,
      padding: EdgeInsets.fromLTRB(
          _kPickerTopBarLeftPadding, 0.0, _kPickerTopBarRightPadding, 0.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(0xfff0f0f0),
                  width: 2.0,
                  style: BorderStyle.solid))),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (bindCancel != null) {
                  bindCancel({});
                }
              },
              child: Text(
                "取消",
                style: DefaultTextStyle.of(context).style.merge(TextStyle(
                    color: cancelTextColor,
                    fontSize: topBarFontSize,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    shadows: [])),
              )),
          Expanded(child: Container()),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (bindChange != null) {
                  if (mode == 'time') {
                    DateTime t = value;
                    String v = HHMM(t);
                    bindChange({
                      "detail": {"value": v}
                    });
                    return;
                  } else if (mode == 'date') {
                    DateTime t = value;
                    String v = YYYYMMDD(t);
                    bindChange({
                      "detail": {"value": v}
                    });
                    return;
                  } else if (mode == 'region') {
                    bindChange(selectedRegion);
                  } else {
                    bindChange({
                      "detail": {"value": value}
                    });
                  }
                }
              },
              child: Text(
                "确定",
                style: DefaultTextStyle.of(context).style.merge(TextStyle(
                    color: okTextColor,
                    fontSize: topBarFontSize,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    shadows: [])),
              ))
        ],
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker, BuildContext context) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: Column(children: [
        buildTopBar(context),
        Expanded(
            child: DefaultTextStyle(
          style:
              TextStyle(color: CupertinoColors.black, fontSize: itemFontSize),
          child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
              top: false,
              child: picker,
            ),
          ),
        ))
      ]),
    );
  }

  Widget buildSingleColumnPicker(Widget displayWidget) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: value);

    List<Widget> listItems = [];
    for (int i = 0; i < range.length; i++) {
      var item = range[i];
      if (item is String) {
        listItems.add(Center(child: Text(item)));
      } else {
        String text = item[rangeKey];
        listItems.add(Center(child: Text(text)));
      }
    }
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
                CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.white,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        value = index;
                      });
                    },
                    children: listItems),
                context);
          },
        );
      },
      child: displayWidget,
    );
  }

  Widget buildDatePicker(Widget widget) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: value,
                  minimumDate: start,
                  maximumDate: end,
                  onDateTimeChanged: (DateTime t) {
                    setState(() {
                      value = t;
                    });
                  },
                ),
                context);
          },
        );
      },
      child: widget,
    );
  }

  Widget buildTimePicker(Widget widget) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: value,
                  minimumDate: start,
                  maximumDate: end,
                  onDateTimeChanged: (DateTime t) {
                    setState(() {
                      print("time picker changes:" + t.toString());
                      value = t;
                    });
                  },
                ),
                context);
          },
        );
      },
      child: widget,
    );
  }

  Widget buildMultiSelectorPicker(Widget widget) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
                WxMultiColumnPicker(
                  range: this.range,
                  value: this.value,
                  rangeKey: rangeKey,
                  columnsCount: columnsCount,
                  columnChangeListener: (int columnIndex, int valueIndex) {
                    setState(() {
                      value[columnIndex] = valueIndex;
                      for (int i = columnIndex + 1; i < columnsCount; i++) {
                        value[i] = 0;
                      }
                    });
                  },
                ),
                context);
          },
        );
      },
      child: widget,
    );
  }

  Widget buildRegionPicker(Widget widget) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
                WxRegionsPicker(
                  value: this.value,
                  columnsCount: columnsCount,
                  changeListener: (e) {
                    setState(() {
                      selectedRegion = e;
                    });
                  },
                ),
                context);
          },
        );
      },
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var children = widget.node['children'];
    if (children == null || children.length != 1) {
      print("------error---- picker 必须带一个view，也只能有一个view作为它的儿子。");
      return null;
    }
    var child = children[0];

    var widgets = OwlComponentBuilder.buildList(
        node: child,
        pageCss: widget.pageCss,
        appCss: widget.appCss,
        model: widget.model,
        componentModel: widget.componentModel,
        parentNode: widget.node,
        parentWidget: widget,
        cacheContext: widget.cacheContext);
    if (widgets.length > 1) {
      print("------error---- picker 必须带一个view，也只能有一个view作为它的儿子。");
      return null;
    }

    switch (mode) {
      case 'selector':
        return buildSingleColumnPicker(widgets[0]);
      case 'date':
        return buildDatePicker(widgets[0]);
      case 'time':
        return buildTimePicker(widgets[0]);
      case 'multiSelector':
        return buildMultiSelectorPicker(widgets[0]);
      case 'region':
        return buildRegionPicker(widgets[0]);
    }
    return null;
  }
}
