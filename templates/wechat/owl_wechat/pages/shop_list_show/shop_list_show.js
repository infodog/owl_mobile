// pages/shop_list_show/shop_list_show.js
Page({

 
  "data": {
    "meun_other":false,
    "meun_pic":true,
    "content_show":true,
    "dagou_show1":true,
    "dagou_show2": false,
    "dagou_show3": false,
    "dagou_show4": false,
    "cover_list_chose":true,
    "cover_list_chose1":false,
    "bg_cover_show":false,
    "bg_cover_tc":false,
    "gx_item_choose":false,
    "sx_over_bg":false,
    "tj_search":false,
    "search":true,
    "bg_tc_cont_list":[
      { "text":"Elixir/怡丽丝尔", "show": false },
      { "text": "Dr.Jart+/蒂佳婷", "show": true },
      { "text": "utena/佑天兰", "show": false },
      { "text": "Kracie/肌美精", "show": false },
      { "text": "Curel/珂润", "show": false },
      { "text": "kose高丝", "show": false },
      { "text": "IPSA/茵芙莎", "show": false },
      { "text": "A.H.C/爱和纯", "show": false },
      { "text": "悦诗风吟", "show": false },
      { "text": "MEDIHEAL/美迪惠尔", "show": false },
      { "text": "VTMissha/谜尚", "show": false },
      { "text": "it's skin/伊思", "show": false },
      { "text": "SU:M37°/苏秘、37°", "show": false },
      { "text": "The history of whoo/后", "show": false },


    ],
    "shop_cont_list": [
      {
        "img": "../../img/shop_list1.png",
        "text": "日本石泽研究所毛穴抚子大米面膜收缩毛孔10片装",
        "icon": "../../img/riben.png",
        "icon_text": "石泽研究所",
        "price": "￥85",
        "price_zs": "円33000 円43000",
        "gfpj": "../../img/xx.png",
        "last": true,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list2.png",
        "text": "JM面膜JMsolution蜂蜜补水保湿美白提亮肤色",
        "icon": "../../img/hang.png",
        "icon_text": "JM",
        "price": "￥68",
        "price_zs": "₩18000 ₩25000 ",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text":"库存紧张",
        "sell_finish": true
      },
      {
        "img": "../../img/shop_list1.png",
        "text": "日本石泽研究所毛穴抚子大米面膜收缩毛孔10片装",
        "icon": "../../img/riben.png",
        "icon_text": "石泽研究所",
        "price": "￥85",
        "price_zs": "円33000 円43000",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list2.png",
        "text": "JM面膜JMsolution蜂蜜补水保湿美白提亮肤色",
        "icon": "../../img/hang.png",
        "icon_text": "JM",
        "price": "￥68",
        "price_zs": "₩18000 ₩25000 ",
        "gfpj": "../../img/xx.png",
        "last": true,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list1.png",
        "text": "日本石泽研究所毛穴抚子大米面膜收缩毛孔10片装",
        "icon": "../../img/riben.png",
        "icon_text": "石泽研究所",
        "price": "￥85",
        "price_zs": "円33000 円43000",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list2.png",
        "text": "JM面膜JMsolution蜂蜜补水保湿美白提亮肤色",
        "icon": "../../img/hang.png",
        "icon_text": "JM",
        "price": "￥68",
        "price_zs": "₩18000 ₩25000 ",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list1.png",
        "text": "日本石泽研究所毛穴抚子大米面膜收缩毛孔10片装",
        "icon": "../../img/riben.png",
        "icon_text": "石泽研究所",
        "price": "￥85",
        "price_zs": "円33000 円43000",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list2.png",
        "text": "JM面膜JMsolution蜂蜜补水保湿美白提亮肤色",
        "icon": "../../img/hang.png",
        "icon_text": "JM",
        "price": "￥68",
        "price_zs": "₩18000 ₩25000 ",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list1.png",
        "text": "日本石泽研究所毛穴抚子大米面膜收缩毛孔10片装",
        "icon": "../../img/riben.png",
        "icon_text": "石泽研究所",
        "price": "￥85",
        "price_zs": "円33000 円43000",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      },
      {
        "img": "../../img/shop_list2.png",
        "text": "JM面膜JMsolution蜂蜜补水保湿美白提亮肤色",
        "icon": "../../img/hang.png",
        "icon_text": "JM",
        "price": "￥68",
        "price_zs": "₩18000 ₩25000 ",
        "gfpj": "../../img/xx.png",
        "last": false,
        "last_text": "库存紧张",
        "sell_finish": false
      }
    ]
  },
  "go": function (e) {

    var url = e['currentTarget']['dataset']['url'];
    wx.navigateTo({ 'url': url });
  },

  "onLoad": function (options) {
  
  },

})