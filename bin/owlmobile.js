#!/usr/bin/env node

const xmlutil = require('./lib/xmlutil.js')
const cssutil = require('./lib/cssutil.js')

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
var config = JSON.parse(content)


//1.首先处理app.json

