
function login(app) {
    wx.login({
        success: res => {
            // 发送 res.code 到后台换取 openId, sessionKey, unionId
            console.log("login return:",res);
        }
    })
}

function getUserInfo(app,page) {
    if (app.globalData.userInfo) {
        page.setData({
            userInfo: app.globalData.userInfo,
            hasUserInfo: true
        })
        return;
    }
    if(!page){
        //在app.js中调用
        wx.getSetting({
            success: res => {
                console.log('owlGetUserInfo success',res);
                if (res.authSetting['scope.userInfo']) {
                    // 已经授权，可以直接调用 getUserInfo 获取头像昵称，不会弹框
                    wx.getUserInfo({
                        success: res => {
                            // 可以将 res 发送给后台解码出 unionId
                            app.globalData.userInfo = res.userInfo
                            // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
                            // 所以此处加入 callback 以防止这种情况
                            if (app.userInfoReadyCallback) {
                                app.userInfoReadyCallback(res)
                            }
                        }
                    })
                }
            }
        })
    }
    else{
        //在page中调用
        var canIUse = wx.canIUse('button.open-type.getUserInfo')
        page.setData({canIUse:canIUse});
        if (canIUse){
            // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
            // 所以此处加入 callback 以防止这种情况
            app.userInfoReadyCallback = res => {
                page.setData({
                    userInfo: res.userInfo,
                    hasUserInfo: true
                })
            }
        } else {
            // 在没有 open-type=getUserInfo 版本的兼容处理
            wx.getUserInfo({
                success: res => {
                    app.globalData.userInfo = res.userInfo
                    page.setData({
                        userInfo: res.userInfo,
                        hasUserInfo: true
                    })
                }
            })
        }
    }

}

function canIUse(buttonName){
    //wx.canIUse('button.open-type.getUserInfo')
    return wx.canIUse(buttonName);
}

function navigateTo(url){
    return wx.navigateTo({url:url});
}

function getApplication(){
    return getApp(); //wechat api
}

function addToList(arr,elem){
    arr.push(elem);
}


function removeFromList(arr, index){
    arr.splice(arr,index,1);
}

function insert(arr,index,elem){
    arr.splice(arr,index,0,elem);
}

module.exports = {
    login,
    getUserInfo,
    canIUse,
    navigateTo,
    getApplication
}
