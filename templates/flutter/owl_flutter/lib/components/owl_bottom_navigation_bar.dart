import 'package:flutter/material.dart';

class OwlBottomNavigationBar extends StatelessWidget {
  OwlBottomNavigationBar({Key key, this.items}) : super(key: key);
  final List items;
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navItems = [];
    items.forEach((item) {
      BottomNavigationBarItem barItem = BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(item.iconPath)),
          activeIcon: ImageIcon(AssetImage(item.selectedIconPath)),
          title: item.text);
      navItems.add(barItem);
    });

    return BottomNavigationBar(items: navItems, currentIndex: 0);
  }
}
