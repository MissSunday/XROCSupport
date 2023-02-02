
#!/bin/sh



#cd Example/
#
#package=1 source=1 pod install
#
#cd ..
#package=1 source=1 pod package XROCSupport.podspec \
#--force \
#--no-mangle \
#--exclude-deps \
#--configuration=Release \




function errorShow(){
   if [ $1 != 0 ]
   then
   echo -e "\033[31m错误信息：$2 \n执行程序行数：`expr $3 - 2` \033[0m"
   exit 0
   fi
}

function  gitPodWork(){

 echo "当前路径是 $1"

#  #先执行git pod操作
  cd $mainfilePath
  
  git clean -xfd
  cd $mainfilePath"/Example"
  package=1 source=1 pod update --no-repo-update
  resultCode=$?
  errorShow $resultCode "package=1 source=1 pod update --no-repo-update"  $LINENO
  cd ..

  #执行.d tag push
  pushGit "${versionTag}.d"
  pushTag "${versionTag}.d"
  #打包framework .d版本
  cd $mainfilePath
  package=1 source=1 pod package XROCSupport.podspec \
  --force \
  --no-mangle \
  --exclude-deps \
  --configuration=Release \
  
  pushGit "${versionTag}"
  pushTag "${versionTag}"
}
function pushGit(){
#    sleep 5s
    #记录的头文件保存
    cd $mainfilePath
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
function pushTag(){

    git tag $1
    git push --tags

}
read -p "请输入项目的跟文件目录："  mainfilePath
read -p "请输入本次升级的tag号："  versionTag
gitPodWork mainfilePath
