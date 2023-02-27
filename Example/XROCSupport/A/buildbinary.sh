#获得当前目录的名字，一般是YTXChartSocket这种
PROJECT_NAME=${PWD##*/}

# 编译工程
BINARY_NAME="${PROJECT_NAME}Binary"

cd Example

INSTALL_DIR=$PWD/../${PROJECT_NAME}/Products
rm -fr "${INSTALL_DIR}"
mkdir $INSTALL_DIR
WRK_DIR=$PWD/../build


BUILD_PATH=${WRK_DIR}

DEVICE_INCLUDE_DIR=${BUILD_PATH}/Release-iphoneos/usr/local/include
DEVICE_DIR=${BUILD_PATH}/Release-iphoneos/lib${BINARY_NAME}.a
SIMULATOR_DIR=${BUILD_PATH}/Release-iphonesimulator/lib${BINARY_NAME}.a
RE_OS="Release-iphoneos"
RE_SIMULATOR="Release-iphonesimulator"

xcodebuild -configuration "Release" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${BINARY_NAME}" -sdk iphoneos clean build BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" CONFIGURATION_BUILD_DIR="${WRK_DIR}/${RE_OS}" LIBRARY_SEARCH_PATHS="./Pods/build/${RE_OS}"
xcodebuild -configuration "Release" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${BINARY_NAME}" -sdk iphonesimulator clean build BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" CONFIGURATION_BUILD_DIR="${WRK_DIR}/${RE_SIMULATOR}" LIBRARY_SEARCH_PATHS="./Pods/build/${RE_SIMULATOR}"

# xcodebuildsettinf配置key BITCODE_GENERATION_MODE=bitcode 和  OTHER_CFLAGS="-fembed-bitcode" 为打出来的包实际bitcode  bitcode分 1.实际 BITCODE_GENERATION_MODE=bitcode 和 2.假占位 只标记而已 BITCODE_GENERATION_MODE=mark
#CONFIGURATION_BUILD_DIR  xcodebuild的指令 指输出路径
#LIBRARY_SEARCH_PATHS  xcodebuildsettinf配置key  指引入libary路径  在实际运用中 为空  如果指定是b能办引入的lib打进主lib  待验证
#-sdk iphoneos 后面跟需要的架构 就能编译出特性的架构  在合并  不跟x是系统默认的全架构。eg：1. -sdk iphoneos -arch arm64 指出arm64架构  2.-sdk iphoneos -arch armv7s -arch arm64 指出armv7s和arm64架构
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"

cp -rp "${DEVICE_INCLUDE_DIR}" "${INSTALL_DIR}/"

INSTALL_LIB_DIR=${INSTALL_DIR}/lib
mkdir -p "${INSTALL_LIB_DIR}"

INSTALL_DIR_Mid_Sim=$PWD"/Mid_Sim_Arm64"

if [ -d "${INSTALL_DIR_Mid_Sim}" ]
then
rm -rf ${INSTALL_DIR_Mid_Sim}
fi
mkdir -p ${INSTALL_DIR_Mid_Sim}

#把模拟器的移动到INSTALL_DIR_Mid_Sim目录下  进行检查删除arm64框架操作。ios14 模拟器也会有这个架构
cp -rp "${SIMULATOR_DIR}" "${INSTALL_DIR_Mid_Sim}/"
#echo "INSTALL_DIR_Mid_Sim=="$INSTALL_DIR_Mid_Sim
#echo "SIMULATOR_DIR===${SIMULATOR_DIR}"
#echo "last==="${INSTALL_DIR_Mid_Sim}"/"${PROJECT_NAME}
Path_removeArm64=${INSTALL_DIR_Mid_Sim}"/lib"${BINARY_NAME}".a"
podLipoInfo_sim=`lipo -info "${Path_removeArm64}"`

#echo "podLipoInfo_sim==="$podLipoInfo_sim
check_sim_contain_Arm64=$(echo $podLipoInfo_sim | grep "arm64")
if [[ "$check_sim_contain_Arm64" != "" ]]
then
#如果模拟器架构包含arm64 那么删除模拟器arm64架构
echo "模拟器包含arm64架构 删除 "
lipo $Path_removeArm64 -remove arm64 -output $Path_removeArm64
fi
lipo -create "${DEVICE_DIR}" "${Path_removeArm64}" -output "${INSTALL_LIB_DIR}/lib${PROJECT_NAME}.a"
rm -r "${WRK_DIR}"
rm -r "${INSTALL_DIR_Mid_Sim}"
