import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'ole_routers.dart';
import 'ole_navigator.dart';
import 'ole_page.dart';
import 'ole_const.dart';
import 'ole_device_info.dart';
import '../owl_generated/owl_route.dart';
import '../utils/owl.dart';
import "ole_route.dart";
class PageJumpper extends Object {

    static const _channel = const MethodChannel(OleConsts.CHANNEL_PAGE_JUMP);
    static BuildContext __context;
    static void setUp(BuildContext context){
      _channel.setMethodCallHandler(methodCallBack);
      __context = context;
    }



    static void notityNativePop({BuildContext context}){//这个通知原生pop掉flutter界面
        //原生pop完了,自己的堆栈也要处理掉
        OleRoute r = OleNavigator.popPage(context: context);

        Future f = pop(r);

    }

    static String getFlutterRoute(String pageType){
        return pageType.split("flutter/").last;
    }


    static void notityNativePush(Map pageData,{BuildContext context}){

       String type = pageData["pageType"];
       if(type.startsWith("flutter/")){
         String url = getFlutterRoute(type);
         String id =  doFlutterPushNamed(url);
         pageData["pageId"] = id;
       }

       Future f = jump(pageData);
    }

    static void notityNativeReplacementPush(WidgetBuilder builder,{BuildContext context}) {

       OlePage page = new OlePage(builder(context??__context),routeName: "",animatble: false);

       Map pageData ={"pageType":"flutter/unknow"};
       //先pop,在push
       String pid = doFlutterPushPage(page,context,replacement: true);

       pageData["pageId"] = pid;

       jump(pageData);

    }




    static String doFlutterPushNamed(String name,{BuildContext context}){
      WidgetBuilder builder = (BuildContext context) => getScreen(name, {}, owl.getApplication().appCss);

      Widget widget = builder(context??__context);
      if(widget == null){

        builder = OleRoutes.routers[name];

        widget = builder(context??__context);
      }

      OlePage page = new OlePage(widget,routeName: name);



      return doFlutterPushPage(page,context,replacement: false);

    }

    static String doFlutterPushPage(OlePage page,BuildContext context,{bool replacement =false}){
      return  OleNavigator.pushPage(page,context: context,repalacement: replacement,whenPoped: (String pid){

        //当这个页面退出了,需要通知原生端,同步至此页面id
        //这里是因为有时候用户点击上面的返回按钮,也有可能拖动返回,没点击按钮,只能在此捕捉返回事件
        OleRoute r = OleNavigator.finishedPage(pid);
        //pop()
        if(r != null){
          pop(r);
        }
      });

    }




    static void syncPage(String id){
      print("====async==${id}");
    }

    static Future<Null> methodCallBack(MethodCall call) async {

          //收到跳转消息,就跳转到对应的flutter
          List args =  call.arguments;

          print("flutter invoking ${args}");
          if(call.method == "method_pop_router"){
            String router = args.first;
            print("pop to router:"+router);

            NavigatorState navState = Navigator.of(__context);
            bool predicate(Route theRouter){
              return theRouter.settings.name == router;
            }


            navState.popUntil(predicate);

          }else if(call.method == OleConsts.METHOD_PAGE_PUSH){
            Map map =  args.first;

            print("will push ${map}");
            notityNativePush(map);

          }else if(call.method ==OleConsts.METHOD_PAGE_SYNC){//同步导航栈
            String routerId = args.first;//当前页面
            syncPage(routerId);
            _channel.invokeMethod(call.method,routerId);
          }else if(call.method ==OleConsts.METHOD_INFO_SYNC){//同步设备数据

              Map info = args.first;

              if(info is Map){
                 print("get device info :${info}");
                 OleDeviceInfo.name = info["name"];
                 OleDeviceInfo.platform = info["platform"];
                 OleDeviceInfo.osVersion = info["osVersion"];

                 OleDeviceInfo.naviBarHeight = double.parse(info["naviBarHeight"]);
                 OleDeviceInfo.statusBarHeight = double.parse(info["statusBarHeight"]);
                 OleDeviceInfo.tabBarHeight = double.parse(info["tabBarHeight"]);
                 OleDeviceInfo.safeAreaBottom = double.parse(info["safeAreaBottom"]);
                 OleDeviceInfo.safeAreaTop = double.parse(info["safeAreaTop"]);

                //通知刷新
                OleDeviceInfo.notifyUpdate();
              }


          }
    }

    static Future<dynamic> jump(Map cls) async{
          try{
            print("native will jump to :${cls}");
            if(cls["tabBarHidden"] == null ){
              cls["tabBarHidden"] = "1";
            }
           return _channel.invokeMethod(OleConsts.METHOD_PAGE_PUSH,[cls]);
          }on PlatformException catch(e){
          }

    }

    static Future<dynamic> pop(OleRoute r) async {
      try{
        //通知原生
        _channel.invokeMethod(OleConsts.METHOD_PAGE_POP,r.id);
      }on PlatformException catch(e){

      }
    }




}

