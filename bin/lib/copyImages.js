const fs = require('fs')
const path = require('path')
const yaml = require('js-yaml');

/**
 * Look ma, it's cp -R.
 * @param {string} src The path to the thing to copy.
 * @param {string} dest The path to the new copy.
 */
var copyRecursiveSync = function(src, dest) {
    var exists = fs.existsSync(src);
    var stats = exists && fs.statSync(src);
    var isDirectory = exists && stats.isDirectory();
    if (exists && isDirectory) {
        fs.mkdirSync(dest);
        fs.readdirSync(src).forEach(function(childItemName) {
            copyRecursiveSync(path.join(src, childItemName),
                path.join(dest, childItemName));
        });
    } else {
        fs.copyFileSync(src, dest);
    }
};

var copyImages = function(src, dest){
    var srcImgPath = path.join(src,"images");
    var destImgPath = path.join(dest,"images");
    copyRecursiveSync(srcImgPath,destImgPath);

    var yamlPath = path.join(dest,"pubspec.yaml");

    try {
        var doc = yaml.safeLoad(fs.readFileSync(yamlPath, 'utf8'));
        var assets = doc['flutter']['assets'];
        if(!assets){
            assets = [];
        }
        if(assets.indexOf("images/") == -1){
            assets.push("images/")
        }

        var pubspecContent = yaml.dump(doc);
        fs.writeFileSync(yamlPath,pubspecContent,{flag:'w'})
    } catch (e) {
        console.log(e);
    }

}

