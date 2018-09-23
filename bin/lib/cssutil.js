const fs = require('fs');
const {
    resolve,
} = require('path');

var css = require('css');

var cssutil = {
    parseFile: function (file) {
        let cwd = process.cwd()
        var source = resolve(cwd, file);
        var content = fs.readFileSync(source, {encoding: 'utf-8'})
        var result = css.parse(content,{source})

        var rules = result.stylesheet.rules;
        if(rules){
            rules.forEach(rule=>{
                delete rule.position;
                var declarations = rule.declarations;
                if(declarations){
                    declarations.forEach(declaration=>{
                        delete declaration.position;
                    })
                }
            })

        }

        return result
    },

}

module.exports = cssutil;