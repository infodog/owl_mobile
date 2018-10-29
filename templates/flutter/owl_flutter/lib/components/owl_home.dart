import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl_flutter/owl_generated/owl_route.dart';
import 'package:owl_flutter/utils/uitools.dart';

import '../utils/owl.dart';

class OwlHome extends StatefulWidget {
  OwlHome(this.url, this.params);

  var url;
  var params;
  var currentIndex = 0;
  @override
  OwlHomeState createState() {
    // TODO: implement createState
    return OwlHomeState();
  }
}

class OwlHomeState extends State<OwlHome> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> ani;
  initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    ani = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    ani.addListener(this.printAni);
  }

  printAni() {
    print(ani.value);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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
      if (pagePath == widget.url) {
        widget.currentIndex = i;
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

    return WxTabBar(
      items: barItems,
      currentIndex: widget.currentIndex,
      backgroundColor: barBackgroundColor,
      activeColor: activeColor,
      inactiveColor: itemColor,
      ani: ani,
      animationController: animationController,
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
    if (index == widget.currentIndex) {
      effectiveParams = widget.params;
    }
    Widget screen =
        getScreen(url, effectiveParams, owl.getApplication().appCss);
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return WxTabScaffold(tabBar: buildTabBar(context), tabBuilder: tabBuilder);
  }
}

const Color _kDefaultTabBarBackgroundColor = Color(0xCCF8F8F8);
const Color _kDefaultTabBarBorderColor = Color(0x4C000000);
const double _kTabBarHeight = 50.0;

class WxTabBar extends CupertinoTabBar {
  WxTabBar(
      {Key key,
      items,
      onTap,
      currentIndex = 0,
      backgroundColor,
      activeColor = CupertinoColors.activeBlue,
      inactiveColor = CupertinoColors.inactiveGray,
      iconSize = 30.0,
      this.ani,
      this.animationController})
      : super(
            key: key,
            items: items,
            onTap: onTap,
            currentIndex: currentIndex,
            backgroundColor: backgroundColor,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            iconSize: iconSize);

  Animation<double> ani;
  AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget result = new DecoratedBox(
      decoration: new BoxDecoration(
        border: const Border(
          top: BorderSide(
            color: _kDefaultTabBarBorderColor,
            width: 0.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        color: backgroundColor,
      ),
      // TODO(xster): allow icons-only versions of the tab bar too.
      child: new SizedBox(
        height: _kTabBarHeight + bottomPadding,
        child: IconTheme.merge(
          // Default with the inactive state.
          data: new IconThemeData(
            color: inactiveColor,
            size: iconSize,
          ),
          child: new DefaultTextStyle(
            // Default with the inactive state.
            style: new TextStyle(
              fontFamily: '.SF UI Text',
              fontSize: 10.0,
              letterSpacing: 0.1,
              fontWeight: FontWeight.w400,
              color: inactiveColor,
            ),
            child: new Padding(
              padding: new EdgeInsets.only(bottom: bottomPadding),
              child: new Row(
                // Align bottom since we want the labels to be aligned.
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildTabItems(),
              ),
            ),
          ),
        ),
      ),
    );

    if (!opaque) {
      // For non-opaque backgrounds, apply a blur effect.
      result = new ClipRect(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: result,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildTabItems() {
    final List<Widget> result = <Widget>[];

    for (int index = 0; index < items.length; index += 1) {
      final bool active = index == currentIndex;
      result.add(
        _wrapActiveItem(
          new Expanded(
            child: new Semantics(
              selected: active,
              // TODO(xster): This needs localization support. https://github.com/flutter/flutter/issues/13452
              hint: 'tab, ${index + 1} of ${items.length}',
              child: new GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null
                    ? null
                    : () {
                        animationController
                          ..reset()
                          ..forward();
                        onTap(index);
                      },
                child: new Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Expanded(
                          child: new Center(
                              child: index == currentIndex
                                  ? ScaleTransition(
                                      child: items[index].activeIcon,
                                      scale: ani)
                                  : items[index].icon)),
                      items[index].title,
                    ],
                  ),
                ),
              ),
            ),
          ),
          active: active,
        ),
      );
    }

    return result;
  }

  /// Change the active tab item's icon and title colors to active.
  Widget _wrapActiveItem(Widget item, {@required bool active}) {
    if (!active) return item;

    return IconTheme.merge(
      data: new IconThemeData(color: activeColor),
      child: DefaultTextStyle.merge(
        style: new TextStyle(color: activeColor),
        child: item,
      ),
    );
  }

  /// Create a clone of the current [CupertinoTabBar] but with provided
  /// parameters overridden.
  WxTabBar copyWith(
      {Key key,
      List<BottomNavigationBarItem> items,
      Color backgroundColor,
      Color activeColor,
      Color inactiveColor,
      Size iconSize,
      int currentIndex,
      ValueChanged<int> onTap,
      Animation ani,
      AnimationController animationController}) {
    return WxTabBar(
        key: key ?? this.key,
        items: items ?? this.items,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        activeColor: activeColor ?? this.activeColor,
        inactiveColor: inactiveColor ?? this.inactiveColor,
        iconSize: iconSize ?? this.iconSize,
        currentIndex: currentIndex ?? this.currentIndex,
        onTap: onTap ?? this.onTap,
        ani: ani ?? this.ani,
        animationController: animationController ?? this.animationController);
  }
}

class WxTabScaffold extends StatefulWidget {
  /// Creates a layout for applications with a tab bar at the bottom.
  ///
  /// The [tabBar], [tabBuilder] and [currentTabIndex] arguments must not be null.
  ///
  /// The [currentTabIndex] argument can be used to programmatically change the
  /// currently selected tab.
  const WxTabScaffold({
    Key key,
    @required this.tabBar,
    @required this.tabBuilder,
  })  : assert(tabBar != null),
        assert(tabBuilder != null),
        super(key: key);

  /// The [tabBar] is a [CupertinoTabBar] drawn at the bottom of the screen
  /// that lets the user switch between different tabs in the main content area
  /// when present.
  ///
  /// Setting and changing [CupertinoTabBar.currentIndex] programmatically will
  /// change the currently selected tab item in the [tabBar] as well as change
  /// the currently focused tab from the [tabBuilder].

  /// If [CupertinoTabBar.onTap] is provided, it will still be called.
  /// [CupertinoTabScaffold] automatically also listen to the
  /// [CupertinoTabBar]'s `onTap` to change the [CupertinoTabBar]'s `currentIndex`
  /// and change the actively displayed tab in [CupertinoTabScaffold]'s own
  /// main content area.
  ///
  /// If translucent, the main content may slide behind it.
  /// Otherwise, the main content's bottom margin will be offset by its height.
  ///
  /// Must not be null.
  final WxTabBar tabBar;

  /// An [IndexedWidgetBuilder] that's called when tabs become active.
  ///
  /// The widgets built by [IndexedWidgetBuilder] is typically a [CupertinoTabView]
  /// in order to achieve the parallel hierarchies information architecture seen
  /// on iOS apps with tab bars.
  ///
  /// When the tab becomes inactive, its content is still cached in the widget
  /// tree [Offstage] and its animations disabled.
  ///
  /// Content can slide under the [tabBar] when they're translucent.
  /// In that case, the child's [BuildContext]'s [MediaQuery] will have a
  /// bottom padding indicating the area of obstructing overlap from the
  /// [tabBar].
  ///
  /// Must not be null.
  final IndexedWidgetBuilder tabBuilder;

  @override
  _WxTabScaffoldState createState() => _WxTabScaffoldState();
}

class _WxTabScaffoldState extends State<WxTabScaffold> {
  int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.tabBar.currentIndex;
  }

  @override
  void didUpdateWidget(WxTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabBar.currentIndex != oldWidget.tabBar.currentIndex) {
      _currentPage = widget.tabBar.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stacked = <Widget>[];

    Widget content = _TabSwitchingView(
      currentTabIndex: _currentPage,
      tabNumber: widget.tabBar.items.length,
      tabBuilder: widget.tabBuilder,
    );

    if (widget.tabBar != null) {
      final MediaQueryData existingMediaQuery = MediaQuery.of(context);

      // TODO(xster): Use real size after partial layout instead of preferred size.
      // https://github.com/flutter/flutter/issues/12912
      final double bottomPadding = widget.tabBar.preferredSize.height +
          existingMediaQuery.padding.bottom;

      // If tab bar opaque, directly stop the main content higher. If
      // translucent, let main content draw behind the tab bar but hint the
      // obstructed area.
      if (widget.tabBar.opaque) {
        content = Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: content,
        );
      } else {
        content = MediaQuery(
          data: existingMediaQuery.copyWith(
            padding: existingMediaQuery.padding.copyWith(
              bottom: bottomPadding,
            ),
          ),
          child: content,
        );
      }
    }

    // The main content being at the bottom is added to the stack first.
    stacked.add(content);

    if (widget.tabBar != null) {
      stacked.add(Align(
        alignment: Alignment.bottomCenter,
        // Override the tab bar's currentIndex to the current tab and hook in
        // our own listener to update the _currentPage on top of a possibly user
        // provided callback.
        child: widget.tabBar.copyWith(
            currentIndex: _currentPage,
            onTap: (int newIndex) {
              setState(() {
                _currentPage = newIndex;
              });
              // Chain the user's original callback.
              if (widget.tabBar.onTap != null) widget.tabBar.onTap(newIndex);
            }),
      ));
    }

    return Stack(
      children: stacked,
    );
  }
}

/// A widget laying out multiple tabs with only one active tab being built
/// at a time and on stage. Off stage tabs' animations are stopped.
class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    @required this.currentTabIndex,
    @required this.tabNumber,
    @required this.tabBuilder,
  })  : assert(currentTabIndex != null),
        assert(tabNumber != null && tabNumber > 0),
        assert(tabBuilder != null);

  final int currentTabIndex;
  final int tabNumber;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => new _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  List<Widget> tabs;
  List<FocusScopeNode> tabFocusNodes;

  @override
  void initState() {
    super.initState();
    tabs = new List<Widget>(widget.tabNumber);
    tabFocusNodes = new List<FocusScopeNode>.generate(
      widget.tabNumber,
      (int index) => new FocusScopeNode(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusActiveTab();
  }

  void _focusActiveTab() {
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.detach();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: new List<Widget>.generate(widget.tabNumber, (int index) {
        final bool active = index == widget.currentTabIndex;

        if (active || tabs[index] != null) {
          tabs[index] = widget.tabBuilder(context, index);
        }

        return new Offstage(
          offstage: !active,
          child: new TickerMode(
            enabled: active,
            child: new FocusScope(
              node: tabFocusNodes[index],
              child: tabs[index] ?? new Container(),
            ),
          ),
        );
      }),
    );
  }
}
