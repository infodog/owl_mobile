//app.js
var owl = require('./utils/owl.js');

//dartbegin
App({
    'onLaunch': function () {
        owl.login(this);
        owl.getUserInfo(this,null);

    },
    'globalData': {
        'userInfo': null
    },
  
});