import 'ole_network.dart';
class OleHudProgress {
  static void showProgress([String tip]){
    OleNetWork.showProgress(tip);
  }
  static void dissmissProgress(){
   OleNetWork.dissmissProgress();
  }

  static void toast(String tip) {
    OleNetWork.toast(tip);
  }
}