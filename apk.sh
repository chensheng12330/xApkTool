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
#主源码工程
WorkCopy="${ShellPath}/trunk_new/"

#工作副本目录,  可更新路径，绝对路径，脚本内自定义
Workspace="${ShellPath}/workspace/"

#打包源文件夹绝对路径
INPUT_PATH="$1"

#step 0x00 检查参数
echo "(0x00)-->校验打包资源文件夹是否存在..."
if [ ! -d "${INPUT_PATH}" ]; then
	echo "打包资源文件夹不存在，请检察脚本参数1."
	exit 3
else
	echo "(0x00) √  "
fi

if [ ! -n "$2" ] ;then
	echo "APK包名不存在，请检察脚本参数2."
	exit 3
else
	echo "————————————————————————————————————————"
fi
############################################


#step 0x01  将整个 trunk_new 目录拷贝至工作区，若工作区已存在，则删除；

echo "(0x01)-->正在拷贝项目副本到临时工作目录..."
TEMP_ID=`date +%Y%m%d%H%M%S`
TEMP_F="temp${TEMP_ID}"
mkdir -p  "${TEMP_F}"

Project_TEMP="${ShellPath}/${TEMP_F}"
cp -rf "${WorkCopy}" "${Project_TEMP}/trunk_new/"
#Project_TEMP=workspace/temp2016052304/
echo "(0x01) √  "


#step 0x02  替换图片资源
echo "(0x02)-->替换图片资源..."
MAIN_DIR="${Project_TEMP}/trunk_new/main/"
RES_DIR="${MAIN_DIR}res"
MDPI="${RES_DIR}/drawable-mdpi/"
HDPI="${RES_DIR}/drawable-hdpi/"
XHDPI="${RES_DIR}/drawable-xhdpi/"
XXHDPI="${RES_DIR}/drawable-xxhdpi/"


ADT_CIG="package_configure.xml"
Sart_PNG="start_page_bg.png"
ICON_PNG="ic_launcher.png"

cp -rf "${INPUT_PATH}/start_page_bg.png" "${XXHDPI}"
cp -rf "${INPUT_PATH}/ic_launcher_48.png" "${MDPI}${ICON_PNG}"
cp -rf "${INPUT_PATH}/ic_launcher_72.png" "${HDPI}${ICON_PNG}"
cp -rf "${INPUT_PATH}/ic_launcher_96.png" "${XHDPI}${ICON_PNG}"
cp -rf "${INPUT_PATH}/ic_launcher_144.png" "${XXHDPI}${ICON_PNG}"

cp -rf "${INPUT_PATH}/$Sart_PNG" "${MAIN_DIR}$Sart_PNG"

#替换参数配置文件
cp -rf "${INPUT_PATH}/$ADT_CIG" "${MAIN_DIR}${ADT_CIG}"
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
