const fs = require('fs');
const {
    resolve,
} = require('path');

var DOMParser = require('xmldom').DOMParser;

var xmlutil = {
    elem2json: function (elem) {
        if(elem.nodeType==3){
            //this is a text node
            var text = elem.textContent;
            if(text){
                text = text.trim();
                if(text){
                    return {_text:text}
                }
                else{
                    return null;
                }

            }
            return null;
        }
        var tagName = elem.tagName
        if(!tagName){
            return null;
        }
        var ret = {}
        ret[tagName] = {attrs: [], children: []}
        var attrs = ret[tagName].attrs
        var children = ret[tagName].children
        if(elem.attributes){
            for (var i = 0; i < elem.attributes.length; i++) {
                var attrib = elem.attributes[i]
                attrs.push({name: attrib.name, value: attrib.value})
            }
        }

        var nodeLists = elem.childNodes;
        if(nodeLists){
            var array = Array.from(nodeLists);
            array.forEach(function(item){
                var child = xmlutil.elem2json(item);
                if(child){
                    children.push(child);
                }

            });
        }

        return ret;

    },
    parseString: function (xmlstring) {
        var doc = new DOMParser().parseFromString(xmlstring)
        var result = xmlutil.elem2json(doc.documentElement);
        return result;

    },

    parseFile: function (file) {
        let cwd = process.cwd()
        var content = fs.readFileSync(resolve(cwd, file), {encoding: 'utf-8'})
        var result = xmlutil.parseString(content)
        return result
    },
}

module.exports = xmlutil;