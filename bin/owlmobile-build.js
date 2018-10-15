#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const appProcessor = require('./lib/appProcessor.js')
const pageProcessor = require('./lib/pageProcessor.js')
var ncp = require('ncp').ncp;

//读取owlmoobile.json
var cwd = process.cwd();
var configcontent = fs.readFileSync(path.resolve(cwd,'owlmobile.json'));
var config = JSON.parse(configcontent);

var wxappPath = path.resolve(cwd,config.wxapp);
var flutterPath = path.resolve(cwd,config.flutter);
//首先处理app.json
var appJson = appProcessor.processApp(wxappPath,flutterPath);

//处理用到的每一个page
var pages = appJson.pages

for(var i=0; i<pages.length; i++){
    var page = pages[i];
    pageProcessor.processPage(wxappPath,flutterPath,page);
}

mkdir(path.resolve(flutterPath,'assets','img'));

ncp(path.resolve(wxappPath,'img'),path.resolve(flutterPath,'assets','img'),function(err){
    if(err){
        return console.err(err);
    }
    console.log('build finished.')
});




function mkdir(path) {
    try {
        fs.mkdirSync(path)
    } catch (e) {
    }
}