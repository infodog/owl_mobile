import '../owl_generated/owl_app.dart';

class owl {
  static void login(app) {}

  static void getUserInfo(app, page) {}

  static bool canIUse(buttonName) {
    return true;
  }

  static void navigateTo(url) {}

  static bool isHomeTabUrl(url) {
    var tabBar = owl.getApplication().appJson['tabBar'];
    if (tabBar == null) {
      return null;
    }

    var list = tabBar['list'];

    if (list == null) {
      return false;
    }
    for (int i = 0; i < list.length; i++) {
      var item = list[i];
      if (url == item['pagePath']) {
        return true;
      }
    }
    return false;
  }

  static OwlApp owlapp = OwlApp();
  static OwlApp getApplication() {
    return owlapp;
  }
}
