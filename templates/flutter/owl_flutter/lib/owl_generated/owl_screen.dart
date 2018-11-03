import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/owl_page.dart';
import '../components/owl_page_cupertino.dart';
import '../model/ScreenModel.dart';
import '../utils/owl.dart';
import '../utils/uitools.dart';
import '../utils/wx.dart';

class __pageName extends StatelessWidget {
  __pageName({this.params, this.appCss, this.url});

  var pageNode = __pageNode;
  var pageCss = __pageCss;
  var pageJson = __pageConfig;
  var appJson;
  var appCss;
  var appNavigationBottomBar;
  var url;

  Map<dynamic, dynamic> params;

  Widget buildTabBar(BuildContext context) {
    var tabBar = owl.getApplication().appJson['tabBar'];
    if (tabBar == null) {
      return null;
    }

    var list = tabBar['list'];
    var color = tabBar['color'];
    var selectedColor = tabBar['selectedColor'];
    var backgroundColor = tabBar['backgroundColor'];
    var borderStyle = tabBar['borderStyle'];
    if (list == null) {
      return null;
    }
    var currentIndex = -1;

    for (int i = 0; i < list.length; i++) {
      var item = list[i];
      if (item['pagePath'] == url) {
        currentIndex = i;
      }
    }
    if (currentIndex == -1) {
      return null;
    }

    Color activeColor = fromCssColor(selectedColor);
    Color itemColor = fromCssColor(color);
    Color barBackgroundColor = fromCssColor(backgroundColor);

    List<BottomNavigationBarItem> barItems = [];
    for (int i = 0; i < list.length; i++) {
      var item = list[i];

      var iconPath = item['iconPath'];
      var text = item['text'];
      var selectedIconPath = item['selectedIconPath'];

      int posIcon = iconPath.indexOf('img');
      var assetKeyIcon = 'assets/' + iconPath.substring(posIcon);

      int posSelectedIcon = selectedIconPath.indexOf('img');
      var assetKeySelectedIcon =
          'assets/' + selectedIconPath.substring(posSelectedIcon);

      BottomNavigationBarItem barItem = BottomNavigationBarItem(
        icon: Image.asset(assetKeyIcon, width: 24.0, height: 24.0),
        activeIcon:
            Image.asset(assetKeySelectedIcon, width: 24.0, height: 24.0),
        backgroundColor: barBackgroundColor,
        title: Text(text,
            style:
                TextStyle(color: i == currentIndex ? activeColor : itemColor)),
      );
      barItems.add(barItem);
    }

    return new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: barBackgroundColor,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color:
                        itemColor))), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          items: barItems,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int selected) {
            var item = list[selected];
            owl.navigateTo({"url": item['pagePath']}, context);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<__ScreenModel>(
      model: __ScreenModel(this.params, context),
      child: ScopedModelDescendant<__ScreenModel>(
        builder: (context, child, model) {
          return new OwlPage(
            node: pageNode,
            key: Key('__pageName'),
            pageJson: pageJson,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            cacheContext: model.widgetCaches,
          );
        },
      ),
    );

    /*return ScopedModel<__ScreenModel>(
      model: __ScreenModel(this.params, context),
      child: ScopedModelDescendant<__ScreenModel>(
        builder: (context, child, model) {
          return new OwlPageCupertino(
              node: pageNode,
              key: Key('__pageName'),
              pageJson: pageJson,
              pageCss: pageCss,
              appCss: appCss,
              model: model);
        },
      ),
    );*/
  }
}

class __ScreenModel extends ScreenModel {
  static Page(var modelConfig) {
    return modelConfig;
  }

  __ScreenModel(params, BuildContext buildContext)
      : super(params, buildContext) {
    this.pageJs = __pageJs;
    this.data = pageJs['data'];
  }
}
