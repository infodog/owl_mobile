import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:owl_flutter/utils/wx.dart';
import 'package:scoped_model/scoped_model.dart';

class ScreenModel extends Model {
  ScreenModel(this.params, BuildContext buildContext) {
    wx = WeiXinAdapter(buildContext);
    componentModel = {};
    widgetCaches = {};
  }

  var pageModel;
  Map params;
  var pageJs;
  var data;
  var componentModel;
  bool isDirty;

  Map<dynamic, List<Widget>> widgetCaches;

  WeiXinAdapter wx;

  clearDirty(){
    isDirty = false;
  }

  setDirty(){
    isDirty = true;
  }
  void setData(Map<dynamic, dynamic> data) {
    setDirty();
    var o = this.pageJs["data"];
    data.forEach((dynamic key, dynamic value) {
      List parts = key.split(".");
      for (int i = 0; i < parts.length; i++) {
        var part = parts[i];
        int begin = part.indexOf('[');
        int end = part.indexOf(']');

        if (begin == -1) {
          if (i == parts.length - 1) {
            o[part] = value;
          } else {
            if (o[part] == null) {
              o[part] = {};
              o = o[part];
            } else {
              o = o[part];
            }
          }
        } else {
          var k = part.substring(0, begin);
          var idx = part.substring(begin + 1, end);

          if (o[k] == null) {
            o[k] = [];
            o = [];
          } else {
            o = o[k];
          }

          idx = int.parse(idx);
          if (o.length <= idx) {
            o.length = idx + 1;
          }
          if (i == parts.length - 1) {
            o[idx] = value;
          } else {
            if (o[idx] == null) {
              o[idx] = {};
            }
            o = o[idx];
          }
        }
      }
    });
    notifyListeners();
  }

  dynamic getData(String objPath) {
    if (componentModel != null) {
      if (componentModel['includedScreenModel'] == true) {
        //do nothing
      } else {
        var screenModel = this.pageJs['data'];
        screenModel.forEach((k, v) {
          if (!componentModel.containsKey(k)) {
            componentModel[k] = v;
          }
        });
        componentModel['includedScreenModel'] = true;
      }
    } else {
      componentModel = {};
      var screenModel = this.pageJs['data'];
      screenModel.forEach((k, v) {
        componentModel[k] = v;
      });
      componentModel['includedScreenModel'] = true;
    }
    var o = this.componentModel;
    List parts = objPath.split(".");
    for (int i = 0; i < parts.length; i++) {
      var part = parts[i];
      int begin = part.indexOf('[');
      int end = part.indexOf(']');

      if (begin == -1) {
        if (o[part] == null) {
          return null;
        } else {
          o = o[part];
        }
      } else {
        var k = part.substring(0, begin);
        var idx = part.substring(begin + 1, end);

        if (o[k] == null) {
          o[k] = [];
          o = [];
        } else {
          o = o[k];
        }

        idx = int.parse(idx);
        if (o.length <= idx) {
          o.length = idx + 1;
        }

        if (o[idx] == null) {
          o[idx] = {};
        }
        o = o[idx];
      }
    }
    return o;
  }

  var contextData = [];

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    Function(dynamic) f = this.pageJs['onLoad'];
    if (f != null) {
      f({});
    }
  }
}
