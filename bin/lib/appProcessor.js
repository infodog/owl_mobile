const fs = require('fs');
const path = require('path')
const template = require('art-template')
const cssutil = require('./cssutil');

var appProcessor = {
    processApp:function(wxappPath,flutterDir){
        var appJsonFile = path.resolve(wxappPath,"app.json");
        var appJsonContent = fs.readFileSync(appJsonFile, {encoding: 'utf-8'});
        var appJson = JSON.parse(appJsonContent);
        var pages = appJson.pages;
        var routesTemplatePath = path.resolve(__dirname,"../../templates/flutter/owl_flutter/lib/owl_generated/owl_route.dart");
        var routesSource = fs.readFileSync(routesTemplatePath, {encoding: 'utf-8'})
        var render= template.compile(routesSource);

        var page2class = pages.map(function(page){
            var className = page.replace(/\//g,"_");
            return {path:page,className:className};
        });
        var routesContent = render({pages:page2class,homeUrl:pages[0]});

        //写入owl_route.dart
        var routesFile = path.resolve(flutterDir,'lib/owl_generated/owl_route.dart');
        fs.writeFileSync(routesFile,routesContent,{flag:'w'});

        var appCssFile = path.resolve(wxappPath,"app.wxss");
        var appCss  = cssutil.parseFile(appCssFile);

        var appJsFile = path.resolve(wxappPath,"app.js");
        var appJsContent = fs.readFileSync(appJsFile,{encoding: 'utf-8'});

        var beginPos = appJsContent.indexOf("//dartbegin");
        if(beginPos>-1){
            appJsContent = appJsContent.substring(beginPos);
        }
        appJsContent = appJsContent.replace(/function/g,"");

        var owlAppTemplatePath = path.resolve(__dirname,"../../templates/flutter/owl_flutter/lib/owl_generated/owl_app.dart");
        var owlAppSource =  fs.readFileSync(owlAppTemplatePath, {encoding: 'utf-8'})

        owlAppSource = owlAppSource.replace("__appJson",JSON.stringify(appJson));
        owlAppSource = owlAppSource.replace("__appCss", JSON.stringify(appCss));
        owlAppSource = owlAppSource.replace("__appJs", appJsContent);

        //写入owl_app.dart
        var owlAppFile = path.resolve(flutterDir,'lib/owl_generated/owl_app.dart');
        fs.writeFileSync(owlAppFile,owlAppSource,{flag:'w'});
        return appJson;
    }
}

module.exports = appProcessor;