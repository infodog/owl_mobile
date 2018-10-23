import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/owl_generated/owl_route.dart';
import 'package:owl_flutter/utils/uitools.dart';

import '../utils/owl.dart';

class OwlHome extends StatelessWidget {
  OwlHome(this.url, this.params);

  var url;
  var params;
  var currentIndex = 0;

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

    Color activeColor = fromCssColor(selectedColor);
    Color itemColor = fromCssColor(color);
    Color barBackgroundColor = fromCssColor(backgroundColor);

    List<BottomNavigationBarItem> barItems = [];
    for (int i = 0; i < list.length; i++) {
      var item = list[i];

      var iconPath = item['iconPath'];
      var text = item['text'];
      var selectedIconPath = item['selectedIconPath'];

      var pagePath = item['pagePath'];
      if (pagePath == url) {
        currentIndex = i;
      }
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
          title: Text(text));
      barItems.add(barItem);
    }

    return CupertinoTabBar(
      items: barItems,
      currentIndex: currentIndex,
      backgroundColor: barBackgroundColor,
      activeColor: activeColor,
      inactiveColor: itemColor,
//      onTap: (int selected) {
//        var item = list[selected];
//        owl.getApplication().navigateTo({"url": item['pagePath']}, context);
//      },
    );
  }

  Widget tabBuilder(BuildContext context, int index) {
    var tabBar = owl.getApplication().appJson['tabBar'];
    if (tabBar == null) {
      return null;
    }

    var list = tabBar['list'];

    if (list == null) {
      return null;
    }

    var item = list[index];
    var url = item['pagePath'];
    var effectiveParams = {};
    if (index == this.currentIndex) {
      effectiveParams = this.params;
    }
    Widget screen =
        getScreen(url, effectiveParams, owl.getApplication().appCss);
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: buildTabBar(context), tabBuilder: tabBuilder);
  }
}
