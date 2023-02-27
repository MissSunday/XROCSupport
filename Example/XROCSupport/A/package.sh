#! /bin/bash

# 遍历文件夹下面的所有子文件方法


#imp
#$?一定是上个命名执行的结果 0为执行成功 非0失败。上面加一行输出语句 上上句错误  那么也输出正确  因为这时候他的上句是输出

function errorShow(){
   if [ $1 != 0 ]
   then
   echo -e "\033[31m错误信息：$2 \n执行程序行数：`expr $3 - 2` \033[0m"
   exit 0
   fi
}

function copYFile(){
     #获取所有对外头文件 写入文件夹
     copyHeadersFile $1
     #获取所有文件件下的.h 写到risk.h  头文件
     copyHeadersFileNamePublick $mainfile"/"${mainfile##*/}"/Classes" "reWrite"
     #提交仓库
     pushGit "copy所有的库对外头文件 保存并推送仓库 并发布开发tag${tagVersion}.d"
     #核心处理 两次tag d过度
     centerFunction $1

}

function pushGit(){
#    sleep 5s
    #记录的头文件保存
    cd $mainfile
    git add .
    git commit -m "$1"
    #提交  如果是开辟的新的分支
    branch=`git branch | grep "*"`
    # 截取分支名
    currBranch=${branch:2}
    echo "当前分支currBranch== $currBranch"
    
    originBranc=`git branch -r | grep "${currBranch}"`
    echo "originBranc===$originBranc"
    if [[ $originBranc == "origin/"$currBranch ]]
    then
    #已经存在该分支并关联
    echo "已经存在该分支并关联 直接提交"
    git push -f
    resultCode=$?
    errorShow $resultCode "提交仓库失败 提交信息$1"  $LINENO
    else
    #不存在分支 需要关联
    echo "不存在分支 需要关联 在提交"
    git push -f --set-upstream origin $currBranch
    resultCode=$?
    errorShow $resultCode "提交仓库失败 提交信息$1"  $LINENO
    fi
    

}
 #核心处理 两次tag d过度
function centerFunction(){
 #pod更新 打framework
     cd $mainfile
     git clean -xfd
     cd $mainfile"/Example"
     noNeedVendor=1 speclint=1 source=1 sdkflage=$sdkflageENV  pod update --no-repo-update
     resultCode=$?
     errorShow $resultCode "noNeedVendor=1 speclint=1 source=1 sdkflage=$sdkflageENV  pod update --no-repo-update 失败"  $LINENO
     #开发版本tag 以及推送tag操作
     cd $mainfile
     pushGit "开发版本push 对标tag:develop"
     tagVersion=$versionTag".d"
     tagdevelopBaoHan=`git tag | grep "${tagVersion}"`
     if [ $tagVersion == $tagdevelopBaoHan ]
     then
     #如果已经包含这个tag
      echo "包含==$tagVersion  and  $tagdevelopBaoHan "
     DevelopSay="本组件已经包含tag:${tagVersion}是否继续?输入（y/n）如果继续将删除本地以及远程的该tag并重新打标签:"
     tagDevelopHadContainAsk $DevelopSay $tagVersion
     else
     echo "不包含==$tagVersion  and  $tagdevelopBaoHan "
     tagDevelopPush $mainfile
     fi

    #第二步 复制所有依赖的静态库
     #存放静态库的地方  先删除了 在copy
     libFileName=$mainfile"/"${mainfile##*/}"/vendoredlibs"
     rm  -rf   $libFileName
    # searchLibPath=$mainfile"/Example/Pods"
     #搜集静态库lib
     copylibfile $mainfile"/Example/Pods"
     #收集库framework
     #收集库framework
     copyFrameworkfile $mainfile"/Example/Pods"
     copyFrameworkfile  $mainfile"/"${mainfile##*/}"-"$tagVersion
     #删除rframework
     rm  -rf   $mainfile"/"${mainfile##*/}"-"$tagVersion
     
     #原有打包完成后，移除dummy文件防止同样pod package打包出来的有文件冲突
     removeDummy mainfile
        #发布版本tag 以及推送tag操作
        pushGit "复制了所有的静态库 到指定问文件夹 并推送打破远程仓库"
        #第三部 重新执行pod
        #再次执行pod 吧class文件夹头文件加载出来
        git clean -xfd
        cd $mainfile"/Example"
        noNeedVendor=1  pod update --no-repo-update
        resultCode=$?
        errorShow $resultCode "noNeedVendor=1  pod update --no-repo-update 失败"  $LINENO
        #发布版本提交
        cd $mainfile
        pushGit "发布版本push 对应开发版本tag为"$tagVersion
        #如过存在这个tag 和不存在这个tag  做逻辑
        tagDistributionBaoHanAll=`git tag | grep "${versionTag}"`
    
        if [ $tagDistributionBaoHanAll == $tagVersion ]
        then
        #如果匹配的发布版本tag 和开发的相同  说明发布版的不存在 z直接发布
        tagDistributionPush $mainfile
        else
        #如果用发布版匹配到的tag很多 那么 就需要一下处理
        #匹配到的包含开发和发布两个tag  需要删除 开发版本的
        #        ${变量/查找/替换值} 一个'/'表示替换第一个'//'表示替换所有，当查找出中出现了一些需要转义的需要加上\："/"需要转移成"\/","#"需要转移成"\#"
        #        tagDistributionBaoHan=${tagDistributionBaoHan/$tagVersion/}
        echo "当前tag正则匹配列表== $tagDistributionBaoHanAll versionTag=$versionTag  versionTag长度 ${#versionTag}"
        echo "tagDistributionBaoHanAll = $tagDistributionBaoHanAll"
        tagDistributionBaoHan=${tagDistributionBaoHanAll:0:${#versionTag}}
        echo "发布tagDistributionBaoHan-tag==$tagDistributionBaoHan   发布versionTag-tag $versionTag"
        if [ $versionTag == $tagDistributionBaoHan ]
        then
        #如果已经包含这个tag
        DistributionSay="本组件已经包含tag:${versionTag}是否继续?输入（y/n）如果继续将删除本地以及远程的该tag并重新打标签:"
        tagDistributionHadContainAsk $DistributionSay  $versionTag
        else
        tagDistributionPush $mainfile
        fi
        
        fi
        
       
        
}

function tagDevelopHadContainAsk(){

    read -p "$1"  isJixu
    if [ $isJixu == "y" ]
    then
    #继续执行
    git tag -d $2
    resultCode=$?
    errorShow $resultCode "git tag -d $2"  $LINENO
    git push origin --delete $2
    resultCode=$?
    errorShow $resultCode "git push origin --delete $2"  $LINENO
    tagDevelopPush $mainfile
    else
    if [ $isJixu == "n" ]
    then
    exit 0
    else
    tagDevelopHadContainAsk $1 $2
    fi
    fi
}
function tagDevelopPush(){
 #新建tag
    git tag -a $tagVersion  -m "更新${mainfile##*/}的 开发版本tag为$tagVersion"
    resultCode=$?
    errorShow $resultCode "git tag -a $tagVersion"  $LINENO
    
    git push --tags
    resultCode=$?
    errorShow $resultCode "git push --tags"  $LINENO
    
    speclint=1  pod spec lint   --sources='https://coding.jd.com/JRRisk/JRRisk_Specs.git,https://github.com/CocoaPods/Specs.git' --allow-warnings --verbose
    resultCode=$?
    errorShow $resultCode "speclint=1  pod spec lint"  $LINENO
    
    speclint=1  pod repo push jrrisk-git-specs ${mainfile##*/}.podspec --sources='https://coding.jd.com/JRRisk/JRRisk_Specs.git,https://github.com/CocoaPods/Specs.git' --allow-warnings --verbose
    resultCode=$?
    errorShow $resultCode "speclint=1  pod repo push"  $LINENO
    
    speclint=1 noNeedVendor=1 source=1 sdkflage=$sdkflageENV   pod package ${mainfile##*/}.podspec --spec-sources='https://coding.jd.com/JRRisk/JRRisk_Specs.git,https://github.com/CocoaPods/Specs.git' --force --no-mangle
    resultCode=$?
    errorShow $resultCode "speclint=1 noNeedVendor=1 source=1 sdkflage=$sdkflageENV  pod package"  $LINENO
}

function tagDistributionHadContainAsk(){

   read -p "$1"  isJixu
   if [ $isJixu == "y" ]
   then
   #继续执行
   git tag -d $2
   git push origin --delete $2
   tagDistributionPush $mainfile
   else
   if [ $isJixu == "n" ]
   then
   exit 0
   else
   tagDistributionHadContainAsk $1 $2
   fi
   fi
    
}

function tagDistributionPush(){
 #新建tag
     git tag -a $versionTag  -m "更新${mainfile##*/}的 开发版本tag为$versionTag"
     resultCode=$?
     errorShow $resultCode " git tag -a"  $LINENO
     
     git push --tags
     resultCode=$?
     errorShow $resultCode "git push --tags"  $LINENO
     
     #speclintlib 为适配金融分支
     speclintlib=1 pod spec lint   --sources='https://coding.jd.com/JRRisk/JRRisk_Specs.git,https://github.com/CocoaPods/Specs.git' --allow-warnings --verbose
     resultCode=$?
     errorShow $resultCode "speclintlib=1 pod spec lint"  $LINENO
     
     speclintlib=1 pod repo push jrrisk-git-specs ${mainfile##*/}.podspec --sources='https://coding.jd.com/JRRisk/JRRisk_Specs.git,https://github.com/CocoaPods/Specs.git' --allow-warnings --verbose
     resultCode=$?
     errorShow $resultCode "speclintlib=1 pod repo push"  $LINENO
}

function copylibfile(){

         for childfillDir in `ls $1`
         do
         dir_or_file=$1"/"$childfillDir
         if [ -d $dir_or_file ]
         #如果是文件夹  继续遍历找.a

         then
         #Products 文件存放的是pod其他的静态库  不能copy
          Products="Products"
          if [ $childfillDir != $Products ]
          then
          samllProducts="products"
          if [ $childfillDir != $samllProducts ]
          then
          copylibfile $dir_or_file
          fi
          fi
          else
          #如果不是文件夹 确定文件的类型后缀
          shipei="a"
          if [ $shipei == ${childfillDir##*.} ]
          then
#          echo "该文件是一个文件名字 ==$childfillDir"
          #明天做复制处理
          libFileName=$mainfile"/"${mainfile##*/}"/vendoredlibs"
#          echo "libFileName ==$libFileName"
          run_mkcurrent_dir  $libFileName
          cp -a $dir_or_file $libFileName
         fi
         fi
         done
}

function copyHeadersFile(){

#第一步 复制所有头文件
 #先清理删除class文件夹下的文件
 rmFileHeaders $mainfile"/"${mainfile##*/}"/Classes"
 #在写入所有的组件的y头文件到calss文件夹
   for childfillDir in `ls $1`
   do
   dir_or_file=$1"/"$childfillDir
   if [ -d $dir_or_file ]
   then
   echo "该文件是一个文件夹 他的地址是：===$childfillDir"
#   JDCN_VideoSignature="JDCN_VideoSignature"
   jdcnLAPolicyAuth="jdcnLAPolicyAuth"
   JDJR_Sam="JDJR_Sam"
#   jdcnProtocolBridge="jdcnProtocolBridge"
   JDJR_LocalFinger="JDJR_LocalFinger"
   JDJR_Legolas="JDJR_Legolas"
   # echo "执行拷贝操作 显示进度 ${mainfile##*/}"
   if [ $childfillDir == $jdcnLAPolicyAuth ]
   then
   cp -rvf $dir_or_file $mainfile"/"${mainfile##*/}"/Classes"
   fi
   if [ $childfillDir == $JDJR_Sam ]
   then
   cp -rvf $dir_or_file $mainfile"/"${mainfile##*/}"/Classes"
   fi
#   if [ $childfillDir == $jdcnProtocolBridge ]
#   then
#   cp -rvf $dir_or_file $mainfile"/"${mainfile##*/}"/Classes"
#   fi
   if [ $childfillDir == $JDJR_Legolas ]
   then
   cp -rvf $dir_or_file $mainfile"/"${mainfile##*/}"/Classes"
   fi
   
   if [ $childfillDir == $JDJR_LocalFinger ]
   then
   cp -rvf $dir_or_file $mainfile"/"${mainfile##*/}"/Classes"
   fi
 
   fi
   done

}

function copyHeadersFileNamePublick(){
     if [ $2 == "reWrite" ]
     then
     #只有$2=="reWrite" 时 $1 才是对外JRRisk_Package所在的跟目录  后面进入循环$1代表的各个sdk的头文件夹地址
     echo "卧槽 卧槽 卧槽 $2"
     publickHeaderRisk=$1;
     echo "//"  > $publickHeaderRisk"/JRRisk_Package.h"
     echo "//  JRRisk_Package.h"  >> $publickHeaderRisk"/JRRisk_Package.h"
     echo "//  JRRisk_Package"  >> $publickHeaderRisk"/JRRisk_Package.h"
     echo "//"  >> $publickHeaderRisk"/JRRisk_Package.h"
     echo "//  Created by 成勇 on 2018/10/15."  >> $publickHeaderRisk"/JRRisk_Package.h"
     echo "//"  >> $publickHeaderRisk"/JRRisk_Package.h"
     echo "//  Version: "$versionTag >> $publickHeaderRisk"/JRRisk_Package.h"
     echo " " >>  $publickHeaderRisk"/JRRisk_Package.h"
     echo "#ifndef JRRisk_Package_h" >>  $publickHeaderRisk"/JRRisk_Package.h"
     echo "#define JRRisk_Package_h"  >> $publickHeaderRisk"/JRRisk_Package.h"
     
     echo " " >> $publickHeaderRisk"/JRRisk_Package.h"
     fi
     
     for childfillDir in `ls $1`
            do
            dir_or_file=$1"/"$childfillDir
            if [ -d $dir_or_file ]
            #如果是文件夹  遍历内容写入JRRisk_Package.h
            then
            sdkCatagory="#pragma --mark 组件"$childfillDir
            echo $sdkCatagory >> $publickHeaderRisk"/JRRisk_Package.h"
            copyHeadersFileNamePublick $dir_or_file $childfillDir
            else
            writerFileName="JRRisk_Package.h"
            if  [ $childfillDir != $writerFileName ]
            then
            fileNameWillWrite="#import"" \"$childfillDir\" "
            echo $fileNameWillWrite >> $publickHeaderRisk"/JRRisk_Package.h"
            fi
            fi
            done
            echo " " >> $publickHeaderRisk"/JRRisk_Package.h"
            if [ $2 == "reWrite" ]
            then
            echo "#endif /* JRRisk_Package_h */" >> $publickHeaderRisk"/JRRisk_Package.h"
            fi
}
function copyFrameworkfile(){
#echo "该文件是一个文件名字 ==$1"
         for childfillDir in `ls $1`
         do
         dir_or_file=$1"/"$childfillDir
         if [ -d $dir_or_file ]
         #如果是文件夹  继续遍历找.a
         
         then
          shipei="framework"
          if [ $shipei == ${childfillDir##*.} ]
          then
          echo "相等为framework 是个文件夹 ==$childfillDir"
          libFileName=$mainfile"/"${mainfile##*/}"/vendoredlibs"
          echo "libFileName ==$libFileName"
          run_mkcurrent_dir  $libFileName
          cp -a $dir_or_file $libFileName
          
           else
            copyFrameworkfile $dir_or_file
          fi
         fi
         done
}


#创建文件夹
function run_mkcurrent_dir(){

if [ ! -d "$1" ]; then
        echo "创建文件夹 $1"
        mkdir $1
else
        echo "$1 文件夹已存在"
fi
}

#run_mkcurrent_dir;

function  rmFileHeaders(){
     for childfillDir in `ls $1`
         do
         dir_or_file=$1"/"$childfillDir
         if [ -d $dir_or_file ]
         then
        # echo "删除：===$dir_or_file"
         rm  -rf   $dir_or_file
         fi
         done
}
function  gitPodWork(){
  #先执行git pod操作
  cd $mainfile
  git clean -xfd
  cd $mainfile"/Example"
  noNeedVendor=1 speclint=1 source=1 sdkflage=$sdkflageENV  pod update --no-repo-update
  resultCode=$?
  errorShow $resultCode "noNeedVendor=1 speclint=1 source=1 sdkflage=$sdkflageENV   pod update --no-repo-update"  $LINENO
  cd ..
  
  
  #buildbinary.sh
  #执行copy头文件操作
  copYFile $mainfile"/Example/Pods/Headers/Public"
}

function removeDummy(){
    #设置库名称以及所需架构
    architectures_array=("x86_64" "i386" "armv7" "arm64" "armv7s")
    framework_name="JRRisk_Package"

    # -r：复制目录
    # -p：保持文件或目录属性
    # -a：相当于同时使用参数-d，-p，-r
    # -i：提示是否覆盖的确认
    # -d：如果复制的源文件为链接文件，仅复制符号链接本身，且保留符号链接所指向的目标文件或目录
    cd $mainfile/${framework_name}"/vendoredlibs/"
#    mkdir ${framework_name}"/vendoredlibs/tmp"
#    cp -a ${framework_name}"/vendoredlibs/"${framework_name}.framework ${framework_name}"/vendoredlibs/tmp"
#    echo 复制framework

    #创建临时目录，存储字符串
    $(> temp)

    # 按架构删除dummy
    for archite in ${architectures_array[@]}
    do
        #架构字符串拼接
        echo -n "${framework_name}_${archite}.a " >> temp
        # echo $archite 开始
        architecturesName=${archite}
        #在当前目录下先创建架构目录
        mkdir ${architecturesName}
        #打开CCBRisk.framework
        cd ${framework_name}.framework
        #瘦身相应架构
        lipo ${framework_name} -thin ${architecturesName} -output ${framework_name}_${architecturesName}.a
        #将.a移到创建目录
        mv ${framework_name}_${architecturesName}.a ../${architecturesName}
        #进到目录下执行拆分文件,之后找到dummy文件删除，再合并
        cd ../${architecturesName}
        ar -x ${framework_name}_${architecturesName}.a
        rm Pods-packager-dummy.o
        libtool -static -o ../${framework_name}_${architecturesName}.a *.o
        cd ..
        #删除多余文件
        rm -rf ${architecturesName}
        # echo $archite 结束
    done

    #取temp内容并拼接
    archs=$(cat temp)
    echo ${archs}
    #删除
    rm temp
    #合并
    lipo -create -output ${framework_name} ${archs}
    rm ${archs}

    #复制修改后文件过去
    cp ${framework_name} ${framework_name}.framework/Versions/A/${framework_name}
    rm ${framework_name}
    echo "移除Pods-packager-Dummy.o完成"
#    #把.bundle剪切出来
#    mv ${framework_name}.framework/Versions/A/Resources/JDJR_Legolas.bundle .

}

read -p "适配baseinfo 商城输入sc 金融输入jr 默认输入def："  sdkflageENV
read -p "请输入项目的跟文件目录："  mainfile
read -p "请输入本次升级的tag号："  versionTag
gitPodWork mainfile


    

