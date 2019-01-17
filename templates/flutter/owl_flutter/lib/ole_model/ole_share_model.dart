class OleShareModel{

  String title;
  String detail;
  String imageURL;
  String redirectURL;


  Map toMap(){
    Map map = Map();
    map["title"] = title ??"";
    map["detail"] = detail ??"";
    map["imageURL"] = imageURL ??"";
    map["redirectURL"] = redirectURL ??"";

    return map;
  }

}