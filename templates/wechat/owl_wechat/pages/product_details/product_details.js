// pages/product_details/product_details.js
Page({

 
  "data": {
    "click_gwc":true,
    "click_gwc_cont":true,
    "all_shop_title":false,
    "gwc_tc_show":false,
    "imgUrls": [
      '../../img/product1.png',
      '../../img/product1.png',
      '../../img/product1.png',
      '../../img/product1.png'
    ],
    "pro_cont_list":[
      { 
        "img": "../../img/skii.png",
         "title":"sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "com_pic":"../../img/riben.png",
        "com_text":"SKII",
        "price":"￥450",
        "zekou": "7.5折",
        "show":true,
        "zs":"円89000",
        "gfpj":"../../img/xx.png",
        "link": ""
      },
      {
        "img": "../../img/skii.png",
        "title": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "com_pic": "../../img/riben.png",
        "com_text": "SKII",
        "price": "￥450",
        "zekou":"7.5折",
        "show": true,
        "zs": "円89000",
        "gfpj": "../../img/xx.png",
        "link": ""
      },
      {
        "img": "../../img/skii.png",
        "title": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "com_pic": "../../img/riben.png",
        "com_text": "SKII",
        "price": "￥450",
        "zekou": "7.5折",
        "show": true,
        "zs": "円89000",
        "gfpj": "../../img/xx.png",
        "link":""
      },
      {
        "img": "../../img/skii.png",
        "title": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "com_pic": "../../img/riben.png",
        "com_text": "SKII",
        "price": "￥450",
        "zekou": "7.5折",
        "show": true,
        "zs": "円89000",
        "gfpj": "../../img/xx.png",
        "link": ""
      },
      {
        "img": "../../img/skii.png",
        "title": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "com_pic": "../../img/riben.png",
        "com_text": "SKII",
        "price": "￥450",
        "zekou": "7.5折",
        "show": true,
        "zs": "円89000",
        "gfpj": "../../img/xx.png",
        "link": ""
      }
    ],
    "indicatorDots": false,
    "autoplay": true,
    "interval": 2000,
    "duration": 500,
    "motto": 'Hello World',
    "userInfo": {},
    "hasUserInfo": false,
  },

  
  "onLoad": function (options) {

  },
  "go": function (e) {

    var url = e['currentTarget']['dataset']['url'];
    wx.navigateTo({ 'url': url });
  }
  
})