#!/bin/bash
# 深蓝蕴车路宝Android打包工具
# Author：Sherwin.Chen
# Date：2016.05.25
# Update: 2015.06.25 by Sherwin.chen

#脚本使用说明  SLY_PackTool.sh app_data_xxx 0  请将xcocebuild 工具升级xcode7以上才能支持新语法.
#参数1  app_data_xxx 【绝对路径地址】文件夹中需要提供如下文件, 生成的APK包将会放在此文件夹上.
#ic_launcher-web.png, ic_launcher_144.png, ic_launcher_48.png,
#ic_launcher_72.png, ic_launcher_96.png, package_configure.xml,
#start_page_bg.png

#参数2  生成IPA包的名称


#脚本工作目录
ShellPath=$(cd "$(dirname "$0")"; pwd)

cd "${ShellPath}"

#Plist配置文件名
MDM_PLIST="info.plist"

#解包APK副本路径
APKCopy="${ShellPath}/src_apk/xcar.apk"

#工作副本目录,  可更新路径，绝对路径，脚本内自定义
Workspace="workspace"

#打包资源文件夹绝对路径
INPUT_PATH="$1"

#step 0x01 检查参数
echo "(0x00)-->校验打包资源文件夹是否存在..."
if [ ! -d "${INPUT_PATH}" ]; then
	echo "打包资源文件夹不存在，请检察脚本参数1."
	exit 1
else
	echo "(0x00) √  "
fi

if [ ! -n "$2" ] ;then
	echo "APK包名不存在，请检察脚本参数2."
	exit 1
else
	echo "————————————————————————————————————————"
fi
############################################


#step 0x02  将副本APK拷贝至工作区，若工作区已存在，则删除；

echo "(0x02)-->正在拷贝APK副本到临时工作目录..."
TEMP_ID=`date +%Y%m%d%H%M%S`
TEMP_F="temp${TEMP_ID}"

#临时工作目录，完成操作后，删除此临时工作目录
Project_TEMP="${Workspace}/${TEMP_F}"
mkdir -p "${Project_TEMP}"

DUP_APK="SHERWIN.apk"
DUP_APK_PATH="${Project_TEMP}/$DUP_APK"
cp -rf "${APKCopy}" "${Project_TEMP}/${DUP_APK}"
echo "(0x02) √  "

#step 0x03  解包APK
dec_dir="X_CHEN"
echo "(0x03)-->执行解包操作,耗时操作，请稍等..."
./apktoolx.sh d "${ShellPath}/${DUP_APK_PATH}"  -f -o "${ShellPath}/${Project_TEMP}/$dec_dir/"

echo "(0x03) √  "
echo ""

#step 0x04  替换图片资源
echo "(0x04)-->替换图片资源..."
MAIN_DIR="${ShellPath}/${Project_TEMP}/$dec_dir/"
RES_DIR="${MAIN_DIR}res"
MDPI="${RES_DIR}/drawable-mdpi-v4/"
HDPI="${RES_DIR}/drawable-hdpi-v4/"
XHDPI="${RES_DIR}/drawable-xhdpi-v4/"
XXHDPI="${RES_DIR}/drawable-xxhdpi-v4/"

ADT_CIG="package_configure.xml"
Sart_PNG="start_page_bg.png"
ICON_PNG="ic_launcher.png"

cp -rf "${INPUT_PATH}/start_page_bg.png" "${XXHDPI}"
cp -rf "${INPUT_PATH}/ic_launcher_48.png" "${MDPI}${ICON_PNG}"
cp -rf "${INPUT_PATH}/ic_launcher_72.png" "${HDPI}${ICON_PNG}"
cp -rf "${INPUT_PATH}/ic_launcher_96.png" "${XHDPI}${ICON_PNG}"
cp -rf "${INPUT_PATH}/ic_launcher_144.png" "${XXHDPI}${ICON_PNG}"

cp -rf "${INPUT_PATH}/$Sart_PNG" "${MAIN_DIR}$Sart_PNG"

# 读取Plist内容(其余配置信息后续加)
APP_Identify=$(/usr/libexec/PlistBuddy -c "Print:CFBundleIdentifier" "${INPUT_PATH}/${MDM_PLIST}")
APP_DisplayName=$(/usr/libexec/PlistBuddy -c "Print:CFBundleDisplayName" "${INPUT_PATH}/${MDM_PLIST}")
APP_Version=$(/usr/libexec/PlistBuddy -c "Print:CFBundleVersion" "${INPUT_PATH}/${MDM_PLIST}")
MDM_AgentID=$(/usr/libexec/PlistBuddy -c "Print:app_agent_id" "${INPUT_PATH}/${MDM_PLIST}")
MDM_CompanyInfo=$(/usr/libexec/PlistBuddy -c "Print:app_company_info" "${INPUT_PATH}/${MDM_PLIST}")
MDM_VersionCode=$(/usr/libexec/PlistBuddy -c "Print:app_version_code" "${INPUT_PATH}/${MDM_PLIST}")
MDM_BaiduMapKey=$(/usr/libexec/PlistBuddy -c "Print:app_baidumap_key" "${INPUT_PATH}/${MDM_PLIST}")
MDM_app_server_host=$(/usr/libexec/PlistBuddy -c "Print:app_server_host" "${INPUT_PATH}/${MDM_PLIST}")

echo $MDM_app_server_host
exit 0
#修改程序名称

#修改公司名称

#修改版本号

#修改百度KEY

#替换参数配置文件
//cp -rf "${INPUT_PATH}/$ADT_CIG" "${MAIN_DIR}${ADT_CIG}"
echo "(0x01) √  "


#step 0x03 执行打包脚本
#编译出发布版：	ant clean auto-release
#编译出调试版：	ant clean auto-debug
echo "(0x02)-->开始编译，耗时操作,请稍等..."

cd "${MAIN_DIR}"

ant auto-release

APK_PATH="${MAIN_DIR}bin/xcar.apk"

#查询打包是否成功
if [ ! -f "${APK_PATH}" ]; then
  echo "----------------------------------------------------"
	echo "--> ERROR-错误501：找不到签名生成的IPA包, SO? 打包APP失败."
	exit 7
else
  echo "----------------------------------------------"
	echo "(0x03) 编译APP完成! √ "
  echo ""
fi


#step 0x04 copy APK 到指定的目录
mv -f "${APK_PATH}" "${INPUT_PATH}/$2"

#清理工作区
rm -rf "${Project_TEMP}"
echo "(0x04)-->Nice Worker! -->打包成功!  GET √ "

echo '----------------------------------------------------'
echo "安装包--->  ${INPUT_PATH}/$2"
echo '----------------------------------------------------'
