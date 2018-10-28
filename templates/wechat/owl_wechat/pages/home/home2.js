// pages/home/home2.js
Page({

  /**
   * 页面的初始数据
   */
  "data": {
    "imgUrls": [
      '../../img/del/banner.png',
      '../../img/del/banner.png',
      '../../img/del/banner.png'
    ],
    "hot_cont_item":[
      {
        "hot_num":"TOP1",
        "selled_num":383,
        "img":"../../img/del/chungao.png",
        "title":"平价版SK-II清洁面膜…",
        "icon":"../../img/hang.png",
        "text":"whoo",
        "price":"￥280",
        "zs_price":"₩260000"
      },
      {
        "hot_num": "TOP2",
        "selled_num": 383,
        "img": "../../img/del/mm.png",
        "title": "平价版SK-II清洁面膜…",
        "icon": "../../img/hang.png",
        "text": "whoo",
        "price": "￥280",
        "zs_price": "₩260000"
      },
      {
        "hot_num": "TOP3",
        "selled_num": 383,
        "img": "../../img/del/hot_item.png",
        "title": "平价版SK-II清洁面膜…",
        "icon": "../../img/hang.png",
        "text": "whoo",
        "price": "￥280",
        "zs_price": "₩260000"
      }
    ],
    "home_recommend_list":[
      {
        "img":"../../img/del/kouhong.png",
        "text1":"人气口红好价放心买",
        "text2":"女神💄永远不嫌多",
        "text3":"快来宠幸我吧！",
        "text4":"享海购 推荐"
      },
      {
        "img": "../../img/del/xuehua.png",
        "text1": "值得投资的驻颜神器🌟",
        "text2": "雪花秀滋盈生人参焕颜",
        "text3": "拯救您的干燥肌肤",
        "text4": "享海购 推荐"
      },
      {
        "img": "../../img/del/ns.png",
        "text1": "哪些美妆好用又好看？🤔",
        "text2": "kissme防水液体眼线笔",
        "text3": "女神电眼你值得拥有！",
        "text4": "享海购 推荐"
      },
      {
        "img": "../../img/del/qiudong.png",
        "text1": "秋冬挚爱系列",
        "text2": "💖伊蒂之屋混搭眼影",
        "text3": "真正闭眼买不会错！",
        "text4": "享海购 推荐"
      },
      {
        "img": "../../img/del/meizhuang.png",
        "text1": "大牌护肤中的“奥斯卡”",
        "text2": "Whoo拱辰享面膜",
        "text3": "做精致的猪猪女孩🌸",
        "text4": "享海购 推荐"
      },
      {
        "img": "../../img/del/daaixin.png",
        "text1": "💡新品享受9折优惠",
        "text2": "MZUU 秋季新品",
        "text3": "✨明星款时髦又百搭",
        "text4": "享海购 推荐"
      }
    ],
    "circular":true,
    "indicatorDots": true,
    "autoplay": true,
    "interval": 3000,
    "duration": 500,
    "motto": 'Hello World',
    "userInfo": {},
    "hasUserInfo": false,
    
  },

  /**
   * 生命周期函数--监听页面加载
   */
  "onLoad": function (options) {

  },
  "go": function (e) {

    var url = e['currentTarget']['dataset']['url'];
    wx.navigateTo({ 'url': url });
  }
  
  
})