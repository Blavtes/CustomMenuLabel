########################################################
# #请配置如下信息
########################################################
AUTH_KEY="AUTH_KEY"
APP_KEY="APPKEY"
########################################################
# #注:请配置主账号下AUTH_KEY
########################################################
#------------------
exitWithMessage()
{
    echo "${1}"
    exit 1
}
if [ "$AUTH_KEY" == "xxxx" ]; then
exitWithMessage "请在脚本中（第1行）设置AUTH_KEY"
fi
if [ "$APP_KEY" == "xxxx" ]; then
exitWithMessage "请在脚本中（第2行）设置APP_KEY"
fi
dSYM_dir=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}

#------------------
origFile="${dSYM_dir}/Contents/Resources/DWARF/${EXECUTABLE_NAME}"
echo $origFile
if [ ! -f "$origFile" ];then
exitWithMessage "没有找到dSYM文件。请设置Build Options—>DebugInformation Format->release的值为DWARF with dSYM File"
fi
#zipFile="${DWARF_DSYM_FOLDER_PATH}/${EXECUTABLE_NAME}.zip"
upLoad_clean()
{
    CMD='curl -k -F upload=@"'${1}'"'" https://mobile-symbol-upload.tingyun.com/symbol/authkey/${AUTH_KEY}/appkey/${APP_KEY}"
    echo "${CMD}"
    $CMD
    
}
upLoad_clean $origFile >~/tingyun.log 2>&1 &
echo "后台上传中。结果信息在~/tingyun.log"
