// pages/shop_cart/shop_cart.js
Page({

  /**
   * 页面的初始数据
   */
  "data": {
    "top_edit":true,
    "top_finish":false,
    "del_show":false,
    "not_shop_box":false,
    "all_choose_show":true,
    "js_show":true,
    "sc_show":false,
    "bottom_show":true,
    "cart_product":[
      {
        "all_choose":true,
        "icon":"../../img/riben.png",
        "top_text":"CPB肌肤之钥",
        "list":[
            {
            "choose":true,
            "img":"../../img/del/cpb.png",
            "text_show":false,
            "msg":"肌肤之钥CPB口红 瑰丽唇膏4g持久不易脱色 滋润显色易上色",
            "xz":"颜色:203",
            "price":"￥660",
            "price_zs":"円65000 円32000"
            },
            {
            "choose": true,
              "img": "../../img/del/cpb.png",
            "text_show": false,
            "msg": "肌肤之钥CPB口红 瑰丽唇膏4g持久不易脱色 滋润显色易上色",
            "xz": "颜色:203",
            "price": "￥660",
            "price_zs": "円65000 円32000"
            },
            {
            "choose": true,
              "img": "../../img/del/cpb.png",
            "text_show": false,
            "msg": "肌肤之钥CPB口红 瑰丽唇膏4g持久不易脱色 滋润显色易上色",
            "xz": "颜色:203",
            "price": "￥660",
            "price_zs": "円65000 円32000"
            }
          ]
      },
      {
        "all_choose": false,
        "icon": "../../img/hang.png",
        "top_text": "Whoo 后",
        "list": [
          {
            "choose": true,
            "img": "../../img/del/chanp.png",
            "text_show": true,
            "msg": "Whoo后拱辰享乳液 水沄平衡110ml 补水保湿精华乳",
            "xz": "110ml",
            "price": "￥450",
            "price_zs": "₩68000 ₩38000"
          },
          {
            "choose": false,
            "img": "../../img/del/chanp.png",
            "text_show": false,
            "msg": "Whoo后拱辰享乳液 水沄平衡110ml 补水保湿精华乳",
            "xz": "110ml",
            "price": "￥450",
            "price_zs": "₩68000 ₩38000"
          },
          {
            "choose": false,
            "img": "../../img/del/chanp.png",
            "text_show": false,
            "msg": "Whoo后拱辰享乳液 水沄平衡110ml 补水保湿精华乳",
            "xz": "110ml",
            "price": "￥450",
            "price_zs": "₩68000 ₩38000"
          }
         
        ]
      }
  
    ],
    /*你可能会喜欢产品*/
    "tj_cont_list":[
      {
        "img":"../../img/del/skii.png",
        "msg": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "icon":"../../img/riben.png",
        "icon_text":"SKII",
        "price": "￥450",
        "price_dz":"",
        "dz_show":false,
        "price_hs":'円89000',
        "gfpj":"../../img/xx.png"
      },
      {
        "img": "../../img/del/xuehuaxiu.png",
        "msg": "雪花秀致美润白气垫粉底液气垫bb霜含替芯",
        "icon": "../../img/hang.png",
        "icon_text": "雪花秀",
        "price": "￥450",
        "price_dz": "7.5折",
        "dz_show": true,
        "price_hs": '₩38000 ₩68000',
        "gfpj": "../../img/xx1.png"
      },
      {
        "img": "../../img/del/skii.png",
        "msg": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "icon": "../../img/riben.png",
        "icon_text": "SKII",
        "price": "￥450",
        "price_dz": "",
        "dz_show": false,
        "price_hs": '円89000',
        "gfpj": "../../img/xx.png"
      },
      {
        "img": "../../img/del/xuehuaxiu.png",
        "msg": "雪花秀致美润白气垫粉底液气垫bb霜含替芯",
        "icon": "../../img/hang.png",
        "icon_text": "雪花秀",
        "price": "￥450",
        "price_dz": "7.5折",
        "dz_show": true,
        "price_hs": '₩38000 ₩68000',
        "gfpj": "../../img/xx1.png"
      },
      {
        "img": "../../img/del/skii.png",
        "msg": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "icon": "../../img/riben.png",
        "icon_text": "SKII",
        "price": "￥450",
        "price_dz": "",
        "dz_show": false,
        "price_hs": '円89000',
        "gfpj": "../../img/xx.png"
      },
      {
        "img": "../../img/del/xuehuaxiu.png",
        "msg": "雪花秀致美润白气垫粉底液气垫bb霜含替芯",
        "icon": "../../img/hang.png",
        "icon_text": "雪花秀",
        "price": "￥450",
        "price_dz": "7.5折",
        "dz_show": true,
        "price_hs": '₩38000 ₩68000',
        "gfpj": "../../img/xx1.png"
      },
      {
        "img": "../../img/del/skii.png",
        "msg": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "icon": "../../img/riben.png",
        "icon_text": "SKII",
        "price": "￥450",
        "price_dz": "",
        "dz_show": false,
        "price_hs": '円89000',
        "gfpj": "../../img/xx.png"
      },
      {
        "img": "../../img/del/xuehuaxiu.png",
        "msg": "雪花秀致美润白气垫粉底液气垫bb霜含替芯",
        "icon": "../../img/hang.png",
        "icon_text": "雪花秀",
        "price": "￥450",
        "price_dz": "7.5折",
        "dz_show": true,
        "price_hs": '₩38000 ₩68000',
        "gfpj": "../../img/xx1.png"
      },
      {
        "img": "../../img/del/skii.png",
        "msg": "sk-iisk2 神仙水skii护肤精华露补水紧致提亮肤色",
        "icon": "../../img/riben.png",
        "icon_text": "SKII",
        "price": "￥450",
        "price_dz": "",
        "dz_show": false,
        "price_hs": '円89000',
        "gfpj": "../../img/xx.png"
      },
      {
        "img": "../../img/del/xuehuaxiu.png",
        "msg": "雪花秀致美润白气垫粉底液气垫bb霜含替芯",
        "icon": "../../img/hang.png",
        "icon_text": "雪花秀",
        "price": "￥450",
        "price_dz": "7.5折",
        "dz_show": true,
        "price_hs": '₩38000 ₩68000',
        "gfpj": "../../img/xx1.png"
      }
    ]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  "onLoad": function (options) {

  },

})