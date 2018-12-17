import 'data_util.dart';

class DataHandler {
  static final DataHandler _singleton = new DataHandler._internal();

  factory DataHandler() {
    return _singleton;
  }

  DataHandler._internal();

  String session;

  void setSession(String session){
    print(session);

    if (session != this.session){
      this.session = session ;
      var result = DataUtils.setAccessToken(session);
      print("setSession");

      print(result);

    }
  }

  Future<String> getSession() async{
    if (null == this.session){
      String jsession = await DataUtils.getAccessToken();

      print("getSession----");

      print(jsession);
      if(jsession != null) this.session = jsession;
    }
    return session;
  }
}
