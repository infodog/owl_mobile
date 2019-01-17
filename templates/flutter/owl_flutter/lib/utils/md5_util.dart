import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
class MD5util{
  static String hexMD5(String data){
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    new DateTime.now().toString();
    return hex.encode(digest.bytes);
  }
}