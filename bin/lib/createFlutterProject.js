const {lstatSync, readdirSync} = require('fs')
const fs = require('fs')
const {join, resolve} = require('path')
const {spawnSync} = require('child_process')

function isEmpty(dir){
    var files = readdirSync(dir)
    if(files.length==0){
        return true
    }
    return false
}
function createFlutterProject(dir,projectName){

    if(!isEmpty(dir)){
        console.log(dir + " is not empty, exit.")
        return;
    }
    spawnSync("flutter",["create","--project-name",projectName,"-i", "swift", "-a", "kotlin", dir],{cwd:dir,stdio: 'inherit'}); 
}

module.exports = createFlutterProject