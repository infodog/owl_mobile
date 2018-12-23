const fs = require('fs');
const path = require('path')
const template = require('art-template')
const cssutil = require('./cssutil')
const xmlutil = require('./xmlutil.js')

const uuidv1 = require('uuid/v1');


function getAttr(node, attrName) {
    if (typeof node == 'string') {
        return null;
    }
    var attrs = node['attrs'];
    if (attrs == null) {
        return null;
    }
    for (var i = 0; i < attrs.length; i++) {
        var attr = attrs[i];
        if (attr['name'] == attrName) {
            return attr['value'];
        }
    }
    return null;
}


function getNodeRules(node,pageCss){
    var cssClass = getAttr(node, "class");
    var style = getAttr(node, "style");
    if(cssClass && cssClass.indexOf("{{") > -1){
        node.dclass = true;
        return [];
    }
    else if(style && style.indexOf("{{") > -1){
        node.dstyle = true;
    }

    var rules = getEffectiveCssRules(cssClass, style, pageCss);
    return rules;
}

function isRuleEffective( selectors,  classes) {
    var isEffective = false;
    if (selectors == null || classes == null) {
        return false;
    }
    for (var i = 0; i < classes.length; i++) {
        var className = classes[i];
        var selector = '.' + className;
        if (selectors.indexOf(selector) >= 0) {
            isEffective = true;
        }
    }
    return isEffective;
}

function addOrReplaceRule(rules, rule) {
    if (rule['property'] != null) {
        rule['property'] = rule['property'].toLowerCase();
    }
    if (rule['value'] != null && typeof rule['value'] == 'string') {
        rule['value'] = rule['value'].toLowerCase();
    } else {
    }

    for (var i = 0; i < rules.length; i++) {
        if (rules[i]['property'] == rule['property']) {
            rules[i] = rule;
            console.log('rule replaced........' + rule['property']);
            return;
        }
    }
    rules.push(rule);
}

function getEffectiveCssRules(classString, style,  pageCss) {
    var rules = [];
    if (classString != null) {
        var classes = classString.split(/\s+/);
        var pageRules = pageCss["stylesheet"]["rules"];
        for (var i = 0; i < pageRules.length; i++) {
            var rule = pageRules[i];
            var type = rule['type'];
            if (type == 'rule') {
                var selectors = rule['selectors'];
                if (isRuleEffective(selectors, classes)) {
                    var newRules = rule["declarations"];
                    newRules.forEach(function(r) {
                        addOrReplaceRule(rules, r);
                    });
                }
            }
        }
    }

    if (style != null) {
        style = style.toLowerCase();
        var styleRules = style.split(";");
        for (var i = 0; i < styleRules.length; i++) {
            var s = styleRules[i];
            var pair = s.split(":");
            if (pair.length == 2) {
                var rule = {
                    "type": "declaration",
                    "property": pair[0].trim(),
                    "value": pair[1].trim()
                };
                addOrReplaceRule(rules, rule);
            }
        }
    }

    return rules;
}

function preProcessNode(pageNode, pageCss){
    var nodeName = Object.keys(pageNode)[0];
    // console.log(nodeName);
    if(nodeName=='_text'){
        return;
    }
    var node = pageNode[nodeName];
    var nodeId = uuidv1();
    node.nodeId = nodeId;

    var rules = getNodeRules(node,pageCss);
    node.rules = rules;
    if(node.children){
        node.children.forEach(function(childNode){
            preProcessNode(childNode,pageCss);
        });
    }
}

var pageProcessor = {

    processPage:function(wxAppPath,flutterPath,pageName){
        var cwd = process.cwd();
        var pageClass = pageName.replace(/\//g,"_");
        var pageClassFile = path.resolve(cwd,flutterPath,'lib/owl_generated',pageClass + ".dart");
        var pageClassTemplateFile = path.resolve(cwd,flutterPath,'projectTemplates/owl_generated/owl_screen.dart');
        if(!fs.existsSync(pageClassTemplateFile)){
            pageClassTemplateFile = path.resolve(__dirname,'../../templates/flutter/owl_flutter/lib/owl_generated/owl_screen.dart');
        }
        // var pageClassTemplateFile = path.resolve(__dirname,'../../templates/flutter/owl_flutter/lib/owl_generated/owl_screen.dart');

        var pageWxmlFile = path.join(wxAppPath,pageName + ".wxml");
        var pageWxssFile = path.join(wxAppPath,pageName + ".wxss");
        var pageJsonFile = path.join(wxAppPath,pageName + ".json");
        var pageJsFile = path.join(wxAppPath,pageName + ".js");
        var pageDartFile = path.join(wxAppPath,pageName + ".dart");

        if(fs.existsSync(pageDartFile)){
            var pageJsContent = fs.readFileSync(pageDartFile,{encoding: 'utf-8'});
        }
        else{
            var pageJsContent = fs.readFileSync(pageJsFile,{encoding: 'utf-8'});
        }

        // console.log(pageJsFile);

        var beginPos = pageJsContent.indexOf("//dartbegin");
        if(beginPos>-1){
            pageJsContent = pageJsContent.substring(beginPos+"//dartbegin".length);
        }

        pageJsContent = pageJsContent.replace(/function/g,"");

        var pageNode = xmlutil.parseFile(pageWxmlFile);
        var pageCss = cssutil.parseFile(pageWxssFile);
        // console.log(pageWxmlFile);
        preProcessNode(pageNode,pageCss);

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