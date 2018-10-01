#!/usr/bin/env node

const xmlutil = require('./lib/xmlutil.js')
const cssutil = require('./lib/cssutil.js')

const fs = require('fs')
const path = require('path')


var json = xmlutil.parseFile('../example/EnjoyCrossBuy/pages/index/index.wxml')
console.log(JSON.stringify(json))

var cssObj = cssutil.parseFile('../example/EnjoyCrossBuy/pages/index/index.wxss')
console.log(JSON.stringify(cssObj))

var cwd = process.cwd()

var configFile = resolve(cwd, 'owlmobileconfig.json')

if (process.argv.length > 2) {
    configFile = resolve(cwd, process.argv[2])
}

var content = fs.readFileSync(configFile, {encoding: 'utf-8'})
var config = JSON.parse(content);

//1.首先处理app.json
var cwd = process.cwd();

var wechatPath = config.wechatPath;
var wechatFullPath = fs.resovle(cwd,wechatPath);

var flutterPath = config.flutterPath;
var flutterFullPath = fs.resolve(cwd,flutterPath);

var owlappPath = path.join(flutterFullPath,"owlapp");
fs.mkdirSync(owlappPath);

//


var fileContent = fs.readFileSync(resolve(wechatFullPath,'app.json'), {encoding: 'utf-8'});
var app = JSON.parse(fileContent);

var pages = app.pages;
var tabbar = app.tabBar;


var appPath = path.join(wechatFullPath,'app.json');
fs.copyFileSync(appPath,path.join(owlappPath,'app.json'));


for(var i=0; i<pages.length; i++){
    var page = pages[i];
    processPage(page);
}


function processPage(page,wechatFullPath,owlappPath){
    var pageWxml = page + ".wxml";
    var pageWxmlPath = path.join(wechatFullPath,pageWxml);

    var pageWxss = page + ".wxss";
    var pageWxssPath = path.join(wechatFullPath,pageWxss);

    var pageConfig = page + ".json";
    var pageConfigPath = path.join(wechatFullPath,pageConfig);

    var pageScript = page + ".js";
    var pageScriptPath = path.join(wechatFullPath,pageScript);



    var pageWxmlJson = xmlutil.parseFile(pageWxmlPath);

    var owlPageDir = path.join(owlappPath,page);
    fs.mkdirSync(owlPageDir);

    fs.writeFileSync(path.join(owlPageDir,page + "_wxml.json"), JSON.stringify(pageWxmlJson), {flag: 'w'});
    fs.copyFileSync(pageWxssPath,path.join(owlPageDir,pageWxss));
    fs.copyFileSync(pageScriptPath,path.join(owlPageDir,pageScriptPath));
    fs.copyFileSync(pageConfigPath,path.join(owlPageDir,pageConfig));
}






