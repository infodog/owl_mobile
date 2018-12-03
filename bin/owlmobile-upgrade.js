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

var flutterPath = path.resolve(cwd,config.flutter);

var templatePath = path.resolve(__dirname,'../templates/flutter/owl_flutter');

ncp(path.resolve(templatePath,'lib','builders'),path.resolve(flutterPath,'lib','builders'),function(e){
    if(e){
        console.log(e);
    }
    else{
        console.log(path.resolve(flutterPath,'lib','builders') + " upgraded")
    }
});

ncp(path.resolve(templatePath,'lib','components'),path.resolve(flutterPath,'lib','components'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','components') + " upgraded")
});

ncp(path.resolve(templatePath,'lib','utils'),path.resolve(flutterPath,'lib','utils'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','utils') + " upgraded")
});

ncp(path.resolve(templatePath,'lib','widgets'),path.resolve(flutterPath,'lib','widgets'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'lib','widgets') + " upgraded")
});

ncp(path.resolve(templatePath,'assets'),path.resolve(flutterPath,'assets'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'assets') + " upgraded")
});

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
// ncp(path.resolve(templatePath,'pubspec.yaml'),path.resolve(flutterPath,'pubspec.yaml'),function(err){
//     if(err){
//         return console.log(err);
//     }
//     console.log(path.resolve(flutterPath,'lib','pubspec.yaml') + " upgraded")
// });

ncp(path.resolve(templatePath,'test_driver'),path.resolve(flutterPath,'test_driver'),function(err){
    if(err){
        return console.log(err);
    }
    console.log(path.resolve(flutterPath,'test_driver') + " upgraded")
});
