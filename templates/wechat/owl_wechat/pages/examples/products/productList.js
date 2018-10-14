// pages/examples/products/productList.js
//dartbegin
Page({

    /**
     * 页面的初始数据
     */
    "data": {
        "searchText":"国庆假期",
      "recommend": ['国庆小旗', '假日旅游', '罗马假期', '口红最美', 'lamer 眼神精华', '国庆小旗', '假日旅游', '罗马假期', '口红最美', 'lamer 眼神精华', '国庆小旗'],
        "dirty":false
    },

    /**
     * 生命周期函数--监听页面加载
     */
    "onLoad": function (options) {

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
    'onPullDownRefresh': function () {

    },

    /**
     * 页面上拉触底事件的处理函数
     */
    'onReachBottom': function () {

    },

    /**
     * 用户点击右上角分享
     */
    'onShareAppMessage': function () {

    },

    'onInput' : function(event){
        var value = event["detail"]["value"];
        if(value==""){
            this.setData({ "dirty": false });
        }
        else{
            this.setData({ "dirty": true });
        }

    }
})