# xApkTool
xApkTool

# xapk.sh
用户使用： xapk.sh
xapk.sh android打包工具，使用方法

#使用方法
使用示例 SLY_PackTool.sh app_data_xxx myAppName

#工具包介绍
XmlRW    xml读写工具，用来配置解包后的maniface.xml文件。
src_apk  被解包的APK源文件集合. 文件名对应 mdm.plist 文件appid值. 例如：com.temobi.xcar.ipa
apktool  解包/封包工具/必备
apktoolx.sh            用来操作apktool进行相关的命令动作.
Epo2016IntApp.keystore 加密证书
xcar_data     打包资源目录,资源文件目录如下：

#xcar_data
@资源配置文件
mdm.plist	
@APP 图标
ic_launcher_144.png	
ic_launcher_72.png
ic_launcher-web.png	
ic_launcher_48.png	
ic_launcher_96.png	

@启动图片
start_page_bg.png