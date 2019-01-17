import 'package:flutter/material.dart';
import 'page_jumpper.dart';
class OleAppBar {

  static void _doNativeBack(){
      PageJumpper.notityNativePop();
  }
  static Widget backNativeButtom(){

      return Container(width: 40.0,height: 30.0 ,
          child: IconButton(icon:  new Icon(Icons.arrow_back_ios),onPressed: _doNativeBack,),
          );
  }

}