#!/bin/sh

##### Titanium モジュールのビルド＆実行 #####

ATTR_BOLD="\033[01m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_CYAN="\033[36m"
COLOR_CYAN_ATTR_BOLD="\033[36;01m"
COLOR_LIGHT_GRAY="\033[02;37m"
COLOR_OFF="\033[00m"

printf "${COLOR_OFF}${COLOR_CYAN_ATTR_BOLD}Titanium module build${COLOR_OFF}\n\n"

# モジュールのビルド＆実行用アプリの在処.
TIMODULE_APP_PATH=~/Titanium_Studio_Workspace/timodule

# カレントディレクトリ保持.
CURRENT_DIR=${PWD}

# 引数を取得.
while getopts p:bs:T:I:C:V:P:o: OPT
do
	case $OPT in
		"p" ) FLG_p="TRUE" ; VALUE_p="$OPTARG" ;;
		"b" ) FLG_b="TRUE" ;;
		"s" ) FLG_s="TRUE" ; VALUE_s="$OPTARG" ;;
		"T" ) FLG_T="TRUE" ; VALUE_T="$OPTARG" ;;
		"I" ) FLG_I="TRUE" ; VALUE_I="$OPTARG" ;;
		"C" ) FLG_C="TRUE" ; VALUE_C="$OPTARG" ;;
		"V" ) FLG_V="TRUE" ; VALUE_V="$OPTARG" ;;
		"P" ) FLG_P="TRUE" ; VALUE_P="$OPTARG" ;;
		"o" ) FLG_o="TRUE" ; VALUE_o="$OPTARG" ;;
	esac
done

printf "Options:\n"

# Ti SDK を設定.
SDK=""
# 引数から取得.
if [ "$FLG_s" = "TRUE" ]; then SDK="${VALUE_s}"; fi
# 初期値設定.
if [ "$SDK" = "" ]; then SDK="" ; fi
# オプション設定.
if [ "$SDK" != "" ]; then OPT_SDK=" -s ${SDK}"; fi
# アウトプット.
OUT_SDK=${SDK} && if [ "$OUT_SDK" = "" ]; then OUT_SDK="[auto]"; fi

# ビルドのみの設定.
BUILDONLY=""
if [ "$FLG_b" = "TRUE" ]; then OPT_BUILDONLY=" -b"; fi
OUT_BUILDONLY="yes" && if [ "$OPT_BUILDONLY" = "" ]; then OUT_BUILDONLY="no"; fi

# プラットフォームを設定.
PLATFORM=""
if [ "$FLG_p" = "TRUE" ]; then PLATFORM="${VALUE_p}"; fi
# 初期値設定.
if [ "$PLATFORM" = "" ]; then PLATFORM="ios" ; fi
# オプション設定.
if [ "$PLATFORM" != "" ]; then OPT_PLATFORM=" -p ${PLATFORM}"; fi
# アウトプット.
OUT_PLATFORM=${PLATFORM} && if [ "$OUT_PLATFORM" = "" ]; then OUT_PLATFORM="[select]"; fi
# 
PLATFORM2=$PLATFORM
if [ "$PLATFORM" = "ios" ]; then PLATFORM2="iphone"; fi
OUT_PLATFORM2=${PLATFORM2}

# ターゲットを設定.
TARGET=""
if [ "$FLG_T" = "TRUE" ]; then TARGET="${VALUE_T}"; fi
# 初期値設定.
if [ "$TARGET" = "" ]; then
	if [ "$PLATFORM" = "ios" ]; then
		TARGET="simulator"
	elif [ "$PLATFORM" = "android" ]; then
		TARGET="emulator"
	else
		TARGET=""
	fi
fi
# オプション設定.
if [ "$TARGET" != "" ]; then OPT_TARGET=" -T ${TARGET}"; fi
# アウトプット.
OUT_TARGET=${TARGET} && if [ "$OUT_TARGET" = "" ]; then OUT_TARGET="[auto]"; fi

# デバイスIDを設定.
DEVICEID=""
if [ "$FLG_C" = "TRUE" ]; then DEVICEID="${VALUE_C}"; fi
# 初期値設定.
if [ "$DEVICEID" = "" ]; then DEVICEID="" ; fi
# オプション設定.
if [ "$DEVICEID" != "" ]; then OPT_DEVICEID=" -C '${DEVICEID}'"; fi
# アウトプット.
OUT_DEVICEID=${DEVICEID} && if [ "$OUT_DEVICEID" = "" ]; then OUT_DEVICEID="[auto/select]"; fi

# iOS 用の設定.
if [ "$PLATFORM" = "ios" ]; then
	# iOS SDK の設定.
	IOSSDK=""
	if [ "$FLG_I" = "TRUE" ]; then IOSSDK="${VALUE_I}"; fi
	# 初期値設定.
	if [ "$IOSSDK" = "" ]; then IOSSDK="" ; fi
	# オプション設定.
	if [ "$IOSSDK" != "" ]; then OPT_IOSSDK=" -I ${IOSSDK}"; fi
	# アウトプット.
	OUT_IOSSDK=${IOSSDK} && if [ "$OUT_IOSSDK" = "" ]; then OUT_IOSSDK="[auto]"; fi
	
	# Certificate を設定.
	CER=""
	if [ "$FLG_V" = "TRUE" ]; then CER="${VALUE_V}"; fi
	# 初期値設定.
	if [ "$CER" = "" ]; then CER="" ; fi
	# オプション設定.
	if [ "$CER" != "" ]; then OPT_CER=" -V '${CER}'"; fi
	# アウトプット.
	OUT_CER=${CER} && if [ "$OUT_CER" = "" ]; then OUT_CER="[select]"; fi
	
	# Provisioning Profile を設定.
	PP=""
	if [ "$FLG_P" = "TRUE" ]; then PP="${VALUE_P}"; fi
	# 初期値設定.
	if [ "$PP" = "" ]; then PP="" ; fi
	# オプション設定.
	if [ "$PP" != "" ]; then OPT_PP=" -P ${PP}"; fi
	# アウトプット.
	OUT_PP=${PP} && if [ "$OUT_PP" = "" ]; then OUT_PP="[select]"; fi
fi

# manifest をパース.
MODULE_NAME=`grep "^[\s]*name:" manifest | sed -e "s/^name:[\ ]*\(.*\)$/\1/"`
MODULE_ID=`grep "^[\s]*moduleid:" manifest | sed -e "s/^moduleid:[\ ]*\(.*\)$/\1/"`
MODULE_VER=`grep "^[\s]*version:" manifest | sed -e "s/^version:[\ ]*\(.*\)$/\1/"`

# zip ファイル名設定.
ZIP_FILE_NAME=${MODULE_ID}-${PLATFORM2}-${MODULE_VER}.zip

# zip のコピー先を設定.
COPYTO=""
if [ "$FLG_o" = "TRUE" ]; then COPYTO="${VALUE_o}"; fi
# 初期値設定.
if [ "$COPYTO" = "" ]; then COPYTO="" ; fi
	# オプション設定.
if [ "$COPYTO" != "" ]; then OPT_COPYTO="copy"; fi
# アウトプット.
OUT_COPYTO=${COPYTO} && if [ "$OUT_COPYTO" = "" ]; then OUT_COPYTO="[not copy]"; fi

echo "  ${COLOR_CYAN}Ti SDK:${COLOR_OFF} ${ATTR_BOLD}${OUT_SDK}${COLOR_OFF}"
echo "  ${COLOR_CYAN}Build only:${COLOR_OFF} ${ATTR_BOLD}${OUT_BUILDONLY}${COLOR_OFF}"
printf "  ${COLOR_CYAN}Platform:${COLOR_OFF} ${ATTR_BOLD}${OUT_PLATFORM}${COLOR_OFF}" && if [ "$OUT_PLATFORM2" != "" ]; then printf " (${OUT_PLATFORM2})"; fi && printf "\n"
echo "  ${COLOR_CYAN}Target:${COLOR_OFF} ${ATTR_BOLD}${OUT_TARGET}${COLOR_OFF}"
echo "  ${COLOR_CYAN}Device ID:${COLOR_OFF} ${ATTR_BOLD}${OUT_DEVICEID}${COLOR_OFF}"
if [ "$PLATFORM" = "ios" ]; then
	echo "  ${COLOR_CYAN}iOS SDK:${COLOR_OFF} ${ATTR_BOLD}${OUT_IOSSDK}${COLOR_OFF}"
	echo "  ${COLOR_CYAN}Certificate:${COLOR_OFF} ${ATTR_BOLD}${OUT_CER}${COLOR_OFF}"
	echo "  ${COLOR_CYAN}Provisioning Profile:${COLOR_OFF} ${ATTR_BOLD}${OUT_PP}${COLOR_OFF}"
fi
echo "  ${COLOR_CYAN}Zip file name:${COLOR_OFF} ${ATTR_BOLD}${ZIP_FILE_NAME}${COLOR_OFF}"
echo "  ${COLOR_CYAN}Copy ZIP to:${COLOR_OFF} ${ATTR_BOLD}${OUT_COPYTO}${COLOR_OFF}"

printf "${COLOR_OFF}\n"
printf -- "${COLOR_LIGHT_GRAY}- Build module ... -----------------------------------------${COLOR_OFF}\n"

# zip ファイルのパスを設定.
ZIP_FILE_PATH="${CURRENT_DIR}/${ZIP_FILE_NAME}"
if [ "$PLATFORM" = "android" ]; then
	ZIP_FILE_PATH="${CURRENT_DIR}/dist/${ZIP_FILE_NAME}"
fi

# 古い zip 削除.
rm -rf ${ZIP_FILE_PATH}

# モジュールをビルド.
[ -d "./build" ] && rm -rf ./build
if [ "$PLATFORM" = "ios" ]; then
	./build.py
elif [ "$PLATFORM" = "android" ]; then
	ant clean && ant
else
	printf "${COLOR_RED}Platform is invalid.${COLOR_OFF} (${PLATFORM}) select from ${COLOR_CYAN}ios${COLOR_OFF} / ${COLOR_CYAN}android${COLOR_OFF}\n\n"
	exit 1
fi

# zip ができてなければ失敗とみなす.
if [ ! -e "$ZIP_FILE_PATH" ]; then
	printf "${COLOR_RED}Build failed.${COLOR_OFF}\n\n"
	exit 1
fi

# 指定した先に zip をコピー.
if [ "$OPT_COPYTO" != "" ]; then
	printf "${COLOR_OFF}\n"
	printf -- "${COLOR_LIGHT_GRAY}- Copy ZIP ... --------------------------------------------${COLOR_OFF}\n"
	if [ ! -d "$COPYTO" ]; then
		printf "${COLOR_YELLOW}No such directory. (${COPYTO})${COLOR_OFF}\n"
	else
		cp ${ZIP_FILE_PATH} ${COPYTO}
		printf "Copied.\n"
	fi
fi

# ビルドのみならここで終了.
if [ "$OPT_BUILDONLY" != "" ]; then
	printf "${COLOR_OFF}\n"
	printf "${COLOR_BLUE}== Build only. ==${COLOR_OFF}\n"
else

# プロジェクトねーじゃん.
if [ ! -e "$TIMODULE_APP_PATH/tiapp.xml" ]; then
	printf "${COLOR_OFF}\n"
	printf -- "${COLOR_LIGHT_GRAY}- Create module app ... ---------------------------${COLOR_OFF}\n"

	# ワークスペースのディレクトリ取得.
	WORKSPACE_DIR=${TIMODULE_APP_PATH%/*}/

	# ディレクトリもないね.
	if [ ! -d "$WORKSPACE_DIR" ]; then
		mkdir -p ${WORKSPACE_DIR}
	fi

	# ワークスペースにこんにちは.
	cd ${WORKSPACE_DIR}

	# Ti プロジェクト作成.
	DIR_NAME=${TIMODULE_APP_PATH##*/}
	if [ -d "$TIMODULE_APP_PATH" ]; then
		rm -r ${TIMODULE_APP_PATH}
	fi
	ti create --type=app --platforms=all --id=${MODULE_ID} --name=${DIR_NAME} --url= --workspace-dir=.
fi

printf "${COLOR_OFF}\n"
printf -- "${COLOR_LIGHT_GRAY}- Change module app ... ---------------------------${COLOR_OFF}\n"

# アプリディレクトリにこんにちは.
cd ${TIMODULE_APP_PATH}

# できた zip をアプリディレクトリにコピー.
printf "Copy ${COLOR_BLUE}ZIP${COLOR_OFF} ...\n"
cp ${ZIP_FILE_PATH} ${TIMODULE_APP_PATH}/

# example リソースをコピー.
printf "Copy ${COLOR_BLUE}Resources${COLOR_OFF} ...\n"
#rm -rf ${TIMODULE_APP_PATH}/Resources/*
#for file in `find ${CURRENT_DIR}/example -name ".DS_Store" -prune -o -type -print`; do
for file in `find ${CURRENT_DIR}/example -name "*.js"`; do
	if [ ! -d "$file" ]; then
		if [ -L "$file" ]; then
			origpath=`readlink ${file}`
			filepath="$(cd ${CURRENT_DIR}/example/$(dirname ${origpath}) && pwd)/$(basename ${origpath})"
		else
			filepath=${file}
		fi
		cp ${filepath} ${TIMODULE_APP_PATH}/Resources/
		echo " Copied: ${COLOR_CYAN}${filepath}${COLOR_OFF}"
	fi
done
#cp ${CURRENT_DIR}/example/* ${TIMODULE_APP_PATH}/Resources/

# tiapp.xml を編集.
printf "Rewrite ${COLOR_BLUE}tiapp.xml${COLOR_OFF} ...\n"
TMP_XML=`cat tiapp.xml`
## id を設定.
TMP_XML=`echo "${TMP_XML}" | perl -pe "s/(\t*)(<id>).*(<\/id>)/\\\${1}\\\${2}${MODULE_ID}\\\${3}/"`
echo " Changed: ${COLOR_CYAN}<id>${COLOR_OFF} section"
## name を設定.
TMP_XML=`echo "${TMP_XML}" | perl -pe "s/(\t*)(<name>).*(<\/name>)/\\\${1}\\\${2}${MODULE_NAME}\\\${3}/"`
echo " Changed: ${COLOR_CYAN}<name>${COLOR_OFF} section"
## version を設定.
TMP_XML=`echo "${TMP_XML}" | perl -pe "s/(\t*)(<version>).*(<\/version>)/\\\${1}\\\${2}${MODULE_VER}\\\${3}/"`
echo " Changed: ${COLOR_CYAN}<version>${COLOR_OFF} section"
## modules を設定.
#grep -v "^\t*<module .*<\/module>" tiapp.xml | \
#perl -pe "s/(\t*)(<modules>)/\$1\$2\n\$1\t<module platform=\"${PLATFORM2}\">${MODULE_ID}<\/module>/" > _tmp_tiapp.xml
#mv _tmp_tiapp.xml tiapp.xml
TMP_XML=`echo "${TMP_XML}" | grep -v "^\t*<module .*<\/module>" | perl -pe "s/(\t*)(<modules>)/\\\$1\\\$2\\\n\\\$1\t<module platform=\"${PLATFORM2}\">${MODULE_ID}<\/module>/"`
echo " Changed: ${COLOR_CYAN}<modules>${COLOR_OFF} section"
## sdk-version を設定.
TMP_XML=`echo "${TMP_XML}" | perl -pe "s/(\t*)(<sdk-version>).*(<\/sdk-version>)/\\\${1}\\\${2}${SDK}\\\${3}/"`
echo " Changed: ${COLOR_CYAN}<sdk-version>${COLOR_OFF} section"
# 書き換え
echo "${TMP_XML}" > tiapp.xml

# tiapp.xml の <ios> セクション編集.
echo " Changed: ${COLOR_CYAN}<ios>${COLOR_OFF} section ${COLOR_LIGHT_GRAY}*** 未実装 *** timodule.xml の <ios> / <android> セクションの内容を tiapp.xml に追記したい.${COLOR_OFF}"
s_ln="`grep -n '<ios>' tiapp.xml | cut -f1 -d: | tail -n 1`" ; echo "${s_ln}"
e_ln="`grep -n '</ios>' tiapp.xml | cut -f1 -d: | tail -n 1`" ; echo "${e_ln}"

# modules を一旦綺麗に.
printf "Clean ${COLOR_BLUE}modules${COLOR_OFF} ...\n"
rm -rf modules/${PLATFORM2}/*

printf "${COLOR_OFF}\n"
printf -- "${COLOR_LIGHT_GRAY}- Build module app ... -----------------------------------${COLOR_OFF}\n"

# アプリをビルド＆実行.
#ti build -p ${PLATFORM} -s ${SDK} -I 8.1 -C '8EF7CE5F-CF40-4BB9-8BA5-BA2F6B2F67E0' --tall --retina
BUILD_COMMAND="ti clean${OPT_PLATFORM}${OPT_SDK} && ti build${OPT_PLATFORM}${OPT_BUILDONLY}${OPT_SDK}${OPT_TARGET}${OPT_IOSSDK}${OPT_DEVICEID}${OPT_CER}${OPT_PP}"
echo "Command: ${BUILD_COMMAND}"
echo;
eval ${BUILD_COMMAND}

fi

printf "${COLOR_OFF}\n"
printf "Done.\n\n"

# おかえり.
cd ${CURRENT_DIR}


