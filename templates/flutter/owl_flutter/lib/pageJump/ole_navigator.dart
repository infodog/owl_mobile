import 'ole_route.dart';
import 'ole_routers.dart';
import 'ole_page.dart';
import 'package:flutter/material.dart';
import 'page_jumpper.dart';
import 'dart:async';
class OleNavigator{

  static OleNavigator  _navigator = new OleNavigator();

  static int id = 0;
  static Widget rootPage;
  List _routeStack = new List();

  static List stackPages(){
    return new List.from(_navigator._routeStack);
  }



  static String idPrefix(){
    return "ole_route_id_";
  }

  static OleRoute finishedPage(String rid){
    //判断是否还在路由栈里,如果有,则要删除且告诉前端
    int index = -1;
    for(OleRoute r in _navigator._routeStack){
      if(r.id!=null && r.id ==rid){
          index = _navigator._routeStack.indexOf(r);
          break;
      }
    }
    if(index !=-1){
      OleRoute r = _navigator._routeStack[index];
      //r后面的都删除
      _navigator._routeStack.removeRange(index,_navigator._routeStack.length -1);
      return r;
    }

    return null;
  }
  static String pushPage(OlePage page,{bool repalacement = false,BuildContext context,Function whenPoped}){

    NavigatorState navState = OleRoutes.globalState;
    if(context != null){
      navState = Navigator.of(context);
    }
    print("nav state"+ navState.toString());
    OleRoute oleRoute = new OleRoute(page);


    oleRoute.id =  idPrefix() + (id++).toString();
    Future future;//
     if(repalacement){
       _navigator._routeStack.removeLast();
       future= navState.pushReplacement(oleRoute);
     }else{
       future= navState.push(oleRoute);
     }


    future.whenComplete((){

      if(whenPoped !=null){
        whenPoped(oleRoute.id);
      }
    });
    _navigator._routeStack.add(oleRoute);
    return oleRoute.id;

  }


  static OleRoute  popPage({BuildContext context}){
    OleRoute r = _navigator._routeStack.removeLast();

    NavigatorState navState = OleRoutes.globalState;
    if(context != null){
      navState = Navigator.of(context);
    }
    navState.pop();

    return r;//r.page;
  }

  static void popPageTo(String id){

    bool predicate(Route route){
      if(route is OleRoute){
        if(route.id == id || route.settings.name =="/"){
          return true;
        }
      }
      return false;
    }

    NavigatorState navState = OleRoutes.globalState;
    if(id == "root"){
      for(Route r in _navigator._routeStack){
        navState.pop(r);
      }
      _navigator._routeStack.clear();

      return;
    }
    //判断 必须包含这个id 否则不行
    bool flag = false;
    for(Route r in _navigator._routeStack){
      String rid = (r as OleRoute).id;
      if(rid ==id){
        flag = true;
      }
    }
    if(flag == false){
      print("can not pop to a route with id=${id},it is not in stack");
      return ;
    }

    OleRoute r = _navigator._routeStack.last;

    print("need pop to ${id},and current last id = ${r.id}");
    if(r.id == id){//当前就是最后一个 不需要
      return;
    }



    navState.popUntil(predicate);

    //从栈中删除
    while(r.id != id){
      _navigator._routeStack.removeLast();
      r = _navigator._routeStack.last;
    }


  }


}