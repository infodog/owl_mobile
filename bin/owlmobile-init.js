#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const createFlutterProject = require('./lib/createFlutterProject');
var ncp = require('ncp').ncp;

var config = {
    wxapp:'owl_wechat',
    flutter:'owl_flutter'
}

var cwd = process.cwd();

fs.mkdirSync(path.resolve(cwd,config.flutter));
fs.mkdirSync(path.resolve(cwd,config.wxapp));


fs.writeFileSync(path.resolve(cwd,'owlmobile.json'),JSON.stringify(config),{flag:'w'});


//构建flutter app
// createFlutterProject(path.join(cwd,config.flutter));

//将main复制到 flutter目录
var flutterTemplatePath = path.resolve(__dirname,'../templates/flutter/owl_flutter');
ncp(path.resolve(flutterTemplatePath,),path.resolve(cwd,config.flutter));

var wxAppTemplatePath = path.resolve(__dirname, '../templates/wechat/owl_wechat');
ncp(wxAppTemplatePath,path.resolve(cwd,config.wxapp));

fs.unlinkSync(path.resolve(cwd,config.flutter,'lib/owl_generated/owl_screen.dart'));








