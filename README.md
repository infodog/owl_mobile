# owl_mobile
## 搭建构造环境
<p>1.先安装nodejs</p>
<p>2.安装flutter</p>

## 目录结构说明：
* bin：
  <p>javascript程序，用于将小程序转换为flutter</p>
* templates:
  <p>保存owlmobile-init的时候创建的工程的内容，其中：</p>
  * flutter：
    <p>默认的flutter工程</p>
  * wechat：
    <p>默认的wechat工程</p>
    
    
# 需要手动修改的部分
## IOS
### Video_Player
Add the following entry to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

```
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```
## Android
### Video_Player

Ensure the following permission is present in your Android Manifest file, located in `/android/app/src/main/AndroidManifest.xml:

```
<uses-permission android:name="android.permission.INTERNET"/>
```
The Flutter project template adds it, so it may already be there.



