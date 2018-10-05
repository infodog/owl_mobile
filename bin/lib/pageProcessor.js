const fs = require('fs');
const path = require('path')
const template = require('art-template')
const cssutil = require('./cssutil')
const xmlutil = require('./xmlutil.js')

var pageProcessor = {
    processPage:function(wxAppPath,flutterPath,pageName){
        var cwd = process.cwd();
        var pageClass = pageName.replace(/\//g,"_");
        var pageClassFile = path.resolve(cwd,flutterPath,'lib/owl_generated',pageClass + ".dart");
        var pageClassTemplateFile = path.resolve(__dirname,'../../templates/flutter/owl_flutter/lib/owl_generated/owl_screen.dart');

        var pageWxmlFile = path.join(wxAppPath,pageName + ".wxml");
        var pageWxssFile = path.join(wxAppPath,pageName + ".wxss");
        var pageJsonFile = path.join(wxAppPath,pageName + ".json");
        var pageJsFile = path.join(wxAppPath,pageName + ".js");
        var pageJsContent = fs.readFileSync(pageJsFile,{encoding: 'utf-8'});
        console.log(pageJsFile);
        var beginPos = pageJsContent.indexOf("//dartbegin");
        if(beginPos>-1){
            pageJsContent = pageJsContent.substring(beginPos+"//dartbegin".length);
        }

        pageJsContent = pageJsContent.replace(/function/g,"");

        var pageNode = xmlutil.parseFile(pageWxmlFile);
        var pageCss = cssutil.parseFile(pageWxssFile);

        var pageJsonContent = fs.readFileSync(pageJsonFile,{encoding: 'utf-8'});

        var pageClassTemplateContent = fs.readFileSync(pageClassTemplateFile, {encoding: 'utf-8'});

        var pageClassSource = pageClassTemplateContent.replace(/__pageName/g,pageClass);
        pageClassSource = pageClassSource.replace(/__pageNode/g,JSON.stringify(pageNode));
        pageClassSource = pageClassSource.replace(/__pageCss/g,JSON.stringify(pageCss));
        pageClassSource = pageClassSource.replace(/__pageJs/g,pageJsContent);
        pageClassSource = pageClassSource.replace(/__pageConfig/g,pageJsonContent);

        fs.writeFileSync(pageClassFile,pageClassSource,{flag:'w'});
    }
}

module.exports = pageProcessor;