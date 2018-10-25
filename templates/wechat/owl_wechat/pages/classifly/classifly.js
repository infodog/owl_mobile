// pages/classifly/classifly.js
Page({

  "data": {
   "mz_pannel_list":[
     {
       "bgimg":"../../img/Group2.png",
       "title":"护肤·精选",
       "text":"换季水乳必选口碑款",
       "img":"../../img/hf.png"
     },
     {
       "bgimg": "../../img/Group2Copy.png",
       "title": "面膜·精选",
       "text": "底子再好也要抗秋燥",
       "img": "../../img/mm.png"
     },
     {
       "bgimg": "../../img/Group2Copy2.png",
       "title": "美妆·精选",
       "text": "好用明星单品在这里",
       "img": "../../img/fendi.png"
     }
   ],
    "cl_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy3.png",
        "title": "女装·精选",
        "text": "INS博主换季都在穿这些",
        "img": "../../img/nz.png"
      },
      {
        "bgimg": "../../img/Group2Copy4.png",
        "title": "饰品·精选",
        "text": "今年地表炸裂品牌",
        "img": "../../img/ss.png"
      },
      {
        "bgimg": "../../img/Group2Copy5.png",
        "title": "配件·精选",
        "text": "潮人街拍必备单品",
        "img": "../../img/pj.png"
      }

    ],
    "jm_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy6.png",
        "title": "中古包·精选",
        "text": "经典款再不买就绝版了",
        "img": "../../img/zgb.png"
      },
      {
        "bgimg": "../../img/Group2Copy7.png",
        "title": "零钱包·精选",
        "text": "时髦女孩必背单品",
        "img": "../../img/lqb.png"
      },
      {
        "bgimg": "../../img/Group2Copy8.png",
        "title": "旅行包·精选",
        "text": "高颜值新品盘点",
        "img": "../../img/lxx.png"
      }
    ],
    "myet_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy9.png",
        "title": "喂养用品·精选",
        "text": "明星辣妈们首选用品",
        "img": "../../img/naizui.png"
      },
      {
        "bgimg": "../../img/Group2Copy10.png",
        "title": "宝宝洗护·精选",
        "text": "明星辣妈们首选用品",
        "img": "../../img/xihu.png"
      },
      {
        "bgimg": "../../img/Group2Copy11.png",
        "title": "儿童玩具·精选",
        "text": "开启幼零儿童智力",
        "img": "../../img/wanju.png"
      }
    ],
    "rhms_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy12.png",
        "title": "休闲零食·精选",
        "text": "吃货们的首选零食",
        "img": "../../img/rhsp.png"
      },
      {
        "bgimg": "../../img/Group2Copy13.png",
        "title": "特色饮品·精选",
        "text": "日韩地方特色美食",
        "img": "../../img/yinpin.png"
      },
      {
        "bgimg": "../../img/Group2Copy14.png",
        "title": "日本糕点·精选",
        "text": "日本糕点TOP3",
        "img": "../../img/gaodian.png"
      }
    ],
    "yybj_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy15.png",
        "title": "美容养颜·精选",
        "text": "Keep嫩零肌 吃出来",
        "img": "../../img/meirong.png"
      },
      {
        "bgimg": "../../img/Group2Copy16.png",
        "title": "眼部护理·精选",
        "text": "呵护眼睛必需品",
        "img": "../../img/yanbu.png"
      },
      {
        "bgimg": "../../img/Group2Copy17.png",
        "title": "膳食补充·精选",
        "text": "家里缺一瓶膳食补充剂",
        "img": "../../img/shanshi.png"
      }
    ],
    "jjsh_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy18.png",
        "title": "衣物清洁·精选",
        "text": "回购单品 限时折扣",
        "img": "../../img/yiwu.png"
      },
      {
        "bgimg": "../../img/Group2Copy19.png",
        "title": "生活日用·精选",
        "text": "精致生活必须品",
        "img": "../../img/riyong.png"
      },
      {
        "bgimg": "../../img/Group2Copy20.png",
        "title": "家纺布艺·精选",
        "text": "INS博主最爱性价比",
        "img": "../../img/jf.png"
      }
    ],
    "smjd_pannel_list": [
      {
        "bgimg": "../../img/Group2Copy21.png",
        "title": "手机数码·精选",
        "text": "回购单品 限时折扣",
        "img": "../../img/erji.png"
      },

      {
        "bgimg": "../../img/Group2Copy22.png",
        "title": "个护电器·精选",
        "text": "精致生活必须品",
        "img": "../../img/gehu.png"
      },
      {
        "bgimg": "../../img/Group2Copy23.png",
        "title": "生活家电·精选",
        "text": "INS博主最爱性价比",
        "img": "../../img/jiadian.png"
      }
    ],
  
  },

  "onLoad": function (options) {
    
  },
 

  "go":function(e){
    
    var url = e['currentTarget']['dataset']['url'];
    wx.navigateTo({'url':url});
  }
  
})