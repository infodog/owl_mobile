var owl = require('../../utils/owl.js');


//dartbegin
Page({

  /**
   * 页面的初始数据
   */
  "data": {
    "toUrls":[
      "pages/examples/products/productList",
      "../examples/products/productList",
      "/pages/examples/products/productList"
    ],
    "imgUrls": [
      '../../img/banner.png',
      '../../img/banner1_1024.jpg',
      '../../img/banner2_1024.jpg'
    ],

   

    "indicatorDots": false,
    "autoplay": true,
    "interval": 2000,
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

  "onBannerTap": function (e) {
    var idx = e["currentTarget"]['dataset']['idx'];
    var url = this.data['toUrls'][parseInt(idx)];
    return wx.switchTab({ 'url': url });
  },
  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  "onReady": function () {

  },

  /**
   * 生命周期函数--监听页面显示
   */
  "onShow": function () {

  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  "onHide": function () {

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  "onUnload": function () {

  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  "onPullDownRefresh": function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  "onReachBottom": function () {

  },

  /**
   * 用户点击右上角分享
   */
  "onShareAppMessage": function () {

  }
})