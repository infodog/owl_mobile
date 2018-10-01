//index.js
//获取应用实例


var owl = require('../../utils/owl.js');


//dartbegin
Page({
  "data": {
    "motto": 'Hello World',
    "userInfo": {},
    "hasUserInfo": false,
  },
  //事件处理函数
  "bindViewTap": function() {
    owl.navigateTo('../logs/logs');
  },
  "toExampleList":function(){
    owl.navigateTo('../examples/examples');
  },
  "onLoad": function(){
      var app = owl.getApplication();
      owl.getUserInfo(app,this);
  }
})
