import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'owl_statefulcomponent.dart';

class OwlVideo extends OwlStatefulComponent {
  OwlVideo(
      {Key key,
      node,
      pageCss,
      appCss,
      model,
      componentModel,
      parentNode,
      parentWidget,
      cacheContext})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

  OwlVideoState createState() => new OwlVideoState();
}

class OwlVideoState extends State<OwlVideo> {
  TargetPlatform _platform; //会跑到那个平台下
  VideoPlayerController _controller;
  VideoPlayerValue aa;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List rules = widget.getNodeCssRulesEx(widget.node, widget.pageCss);
    //搜索width和height
    String width = widget.getRuleValueEx(rules, "width");
    String height = widget.getRuleValueEx(rules, "height");
    String src = widget.renderText(widget.getAttr(widget.node, "src"));
    String loop = widget.renderText(widget.getAttr(widget.node, "loop"));
    String initialtime =
        widget.renderText(widget.getAttr(widget.node, "initial-time"));
    String duration =
        widget.renderText(widget.getAttr(widget.node, "duration"));
    String controls =
        widget.renderText(widget.getAttr(widget.node, "controls"));
    String danmulist =
        widget.renderText(widget.getAttr(widget.node, "danmu-list"));
    String danmubtn =
        widget.renderText(widget.getAttr(widget.node, "danmu-btn"));
    String enabledanmu =
        widget.renderText(widget.getAttr(widget.node, "enable-danmu"));
    String autoplay =
        widget.renderText(widget.getAttr(widget.node, "autoplay"));
    String muted = widget.renderText(widget.getAttr(widget.node, "muted"));
    String showfullscreenbtn =
        widget.renderText(widget.getAttr(widget.node, "show-fullscreen-btn"));
    String showplaybtn =
        widget.renderText(widget.getAttr(widget.node, "show-play-btn"));
    String showcenterplaybtn =
        widget.renderText(widget.getAttr(widget.node, "show-center-play-btn"));
    String enableprogressgesture = widget
        .renderText(widget.getAttr(widget.node, "enable-progress-gesture"));
    String objectFit =
        widget.renderText(widget.getAttr(widget.node, "objectFit"));
    String ProgressColors =
        widget.renderText(widget.getAttr(widget.node, "progress-colors"));
    String fullScreenByDefault =
        widget.renderText(widget.getAttr(widget.node, "fullScreenByDefault"));
    String autoInitialize =
        widget.renderText(widget.getAttr(widget.node, "autoInitialize"));
    _controller = new VideoPlayerController.network(src);

    bool isautoplay = false;
    bool iscontrols = true;
    if (autoplay == "true") {
      isautoplay = true;
    } else {
      isautoplay = false;
    }
    if (controls == "true") {
      iscontrols = true;
    } else {
      iscontrols = false;
    }
    bool isautoInitialize = false;
    if (autoInitialize == "true") {
      isautoInitialize = true;
    } else {
      isautoInitialize = false;
    }
    bool isloop = false;
    if (loop == "true") {
      isloop = true;
    } else {
      isloop = false;
    }
    bool isfullScreenByDefault = false;
    if (fullScreenByDefault == true) {
      isfullScreenByDefault = true;
    } else {
      isfullScreenByDefault = false;
    }

    return new Column(
      children: <Widget>[
        new Container(
          width: widget.lp(width, 500.0),
          height: widget.lp(height, 500.0),
          color: Colors.black,
          child: new Chewie(
            _controller,
            showControls: iscontrols,
            //  aspectRatio:2/3,//视频的宽高比。重要的是要获得正确的视频大小
            autoInitialize: true, //启动时初始化视频 这将准备播放视频
            autoPlay: isautoplay,
            //是否显示控件
            startAt: Duration(minutes: 0), //在某个时间开始播放
            //  fullScreenByDefault: isfullScreenByDefault,//定义在按下播放时播放器是否将全屏启动
            cupertinoProgressColors: ChewieProgressColors(
                playedColor: Colors
                    .red), //iosiOS上用于控件的颜色。默认情况下，iOS播放器使用从原始iOS 11设计中采样的颜色。
            looping: isloop, //是否循环播放
            //用于Material Progress Bar的颜色。默认情况下，“材质”播放器使用主题中的颜色。
            materialProgressColors: ChewieProgressColors(
                playedColor: widget.fromCssColor(ProgressColors)), //进度条颜色
            //  placeholder: new Text("占位符",style: TextStyle(color: Colors.deepOrange),),
          ),
        ),
      ],
    );
  }
}
