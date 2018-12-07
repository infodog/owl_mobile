#!/usr/bin/env node


const fs = require('fs');
const path = require('path');
const createFlutterProject = require('./lib/createFlutterProject');
var ncp = require('ncp').ncp;

var config = {
    wxapp:'owl_wechat',
    flutter:'owl_flutter'
}
var projectName = process.argv[2];

if(!projectName){
    console.log("usage:owlmobile-init <projectName>");
    return;
}

var cwd = process.cwd();

fs.mkdirSync(path.resolve(cwd,config.flutter));
fs.mkdirSync(path.resolve(cwd,config.wxapp));


fs.writeFileSync(path.resolve(cwd,'owlmobile.json'),JSON.stringify(config),{flag:'w'});

function makeDir(dir){
    try{
        fs.mkdirSync(dir,{recursive:true});
    }
    catch(e){
        console.log(e);
    }
}

//构建flutter app

console.log("creating flutter project " + projectName + "......");
createFlutterProject(path.join(cwd,config.flutter),projectName);

console.log("flutter project created");

var flutterPath = path.join(cwd,config.flutter);
var templatePath = path.resolve(__dirname,'../templates/flutter/owl_flutter');


//将main复制到 flutter目录
makeDir(path.resolve(flutterPath,'lib','builders'));
ncp(path.resolve(templatePath,'lib','builders'),path.resolve(flutterPath,'lib','builders'),function(e){
    if(e){
        console.log(e);
    }
    else{
        console.log(path.resolve(flutterPath,'lib','builders') + " upgraded")
    }
});

makeDir(path.resolve(flutterPath,'lib','components'));
ncp(path.resolve(templatePath,'lib','components'),path.resolve(flutterPath,'lib','components'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','components') + " upgraded")
});

makeDir(path.resolve(flutterPath,'lib','utils'));
ncp(path.resolve(templatePath,'lib','utils'),path.resolve(flutterPath,'lib','utils'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','utils') + " upgraded")
});

makeDir(path.resolve(flutterPath,'lib','widgets'));
ncp(path.resolve(templatePath,'lib','widgets'),path.resolve(flutterPath,'lib','widgets'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','widgets') + " upgraded")
});

makeDir(path.resolve(flutterPath,'assets'));
ncp(path.resolve(templatePath,'assets'),path.resolve(flutterPath,'assets'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'assets') + " upgraded")
});

makeDir(path.resolve(flutterPath,'lib','model'));
ncp(path.resolve(templatePath,'lib','model'),path.resolve(flutterPath,'lib','model'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','model') + " upgraded")
});


ncp(path.resolve(templatePath,'lib','main.dart'),path.resolve(flutterPath,'lib','main.dart'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','main.dart') + " upgraded")
});


ncp(path.resolve(templatePath,'pubspec.yaml'),path.resolve(flutterPath,'pubspec.yaml'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','pubspec.yaml') + " upgraded")
});


makeDir(path.resolve(flutterPath,'test_driver'));
ncp(path.resolve(templatePath,'test_driver'),path.resolve(flutterPath,'test_driver'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'test_driver') + " upgraded")
});


var wxAppTemplatePath = path.resolve(__dirname, '../templates/wechat/owl_wechat');
ncp(wxAppTemplatePath,path.resolve(cwd,config.wxapp),function(err){
    if(err){
        return console.err(err);
    }
    console.log('done');
});










