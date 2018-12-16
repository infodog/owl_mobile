// pages/test.js
Page({

  /**
   * 页面的初始数据
   */
  "data": {
    "aa": "",
    "height": '200rpx',
    "colors": ["red", "green", "blue", "orange", "purple"],
    "selectedColor": "blue",
    "theDate": "2018-10-22",
    "curTime": "18:20",
    "theregion": ["广东省", "广州市", "越秀区"],
    "multiArray": [{
      "name": "广东省", "children": [{ "name": "guangzhou", "children": [{ "name": "yuexiu" }, { "name": "tianhe" }] }, { "name": "shenzhen", "children": [{ "name": "futian" }, { "name": "nanshan" }] }]
    },
    { "name": "hunan", "children": [{ "name": "guangzhou", "children": [{ "name": "yuexiu" }, { "name": "tianhe" }] }, { "name": "shenzhen", "children": [{ "name": "futian" }, { "name": "nanshan" }] }] }],
    "multiIndex": [0, 0, 0],
    "pictures":[],
    "responseData":"",
    "postResponseData":""
  },
  "setColor": function (e) {
    var idx = e["detail"]["value"];
    this.setData({ "selectedColor": this.data["colors"][idx] });
  },
  "setTheDate": function (e) {
    this.setData({ "theDate": e["detail"]["value"] });
  },

  "setCurTime": function (e) {
    this.setData({ "curTime": e["detail"]["value"] });
  },
  "setRegion": function (e) {
    // console.log('picker发送选择改变，携带值为', e.detail)
    this.setData({
      "theregion": e["detail"]["value"]
    });
  },
  "bindMultiPickerChange": function (e) {
    this.setData({
      "multiIndex": e["detail"]["value"]
    });
  },
  //跳转"go":function(e){
  "go": function (e) {
    var link = e["currentTarget"]["dataset"]["link"];
    wx.navigateTo({
      "url": link
    });
  },
  "selectPictures": function (e) {
    var self = this;
    wx.chooseImage({ "count": 2,"success":function(ret){
      // console.log("selected files",ret.tempFilePaths,ret.tempFiles);
      self.setData({ "pictures": ret["tempFilePaths"]});
    } });
  },
  "goGetRequest":function(e){
    var self = this;
    wx.request({
      "url":'http://rap2api.taobao.org/app/mock/data/701492',
      "header":{"cookie":"isid=12312312312312"},
      "method":"GET",
      "success":function(res){
          // console.log(res);
        self.setData({ "responseData": res["data"] });
      }
    });
  },
  "goPostRequest": function (e) {
    var self = this;

    wx.request({
      "url": 'http://localhost/owl_fileuploader/handlers/onPost.jsx',
      "data": {"course_id":"1"},
      "header": {"Content-Type":"application/x-www-form-urlencoded"},
      "method": "post",
      "success": function (res) {
        // console.log(res);
        self.setData({ "postResponseData": res["data"] });
      }
    });
  }
});