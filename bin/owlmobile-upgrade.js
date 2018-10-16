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

var templatePath = path.resolve(__dirname,'../../templates/flutter/owl_flutter');

ncp(path.resolve(templatePath,'lib','builders'),path.resolve(flutterPath,'lib','builders'));
ncp(path.resolve(templatePath,'lib','components'),path.resolve(flutterPath,'lib','components'));
ncp(path.resolve(templatePath,'lib','model'),path.resolve(flutterPath,'lib','model'));
ncp(path.resolve(templatePath,'lib','utils'),path.resolve(flutterPath,'lib','utils'));
ncp(path.resolve(templatePath,'lib','main.dart'),path.resolve(flutterPath,'lib','main.dart'));
ncp(path.resolve(templatePath,'pubspec.yaml'),path.resolve(flutterPath,'pubspec.yaml'));
