#!/bin/bash
# SINA RIA PUBLISH TOOL

#svn_user=flylee2011@sina.com
#svn_pass=yifeilee09
node_path=/usr/local/node/bin/node
combinetool_path=/data0/combine_shell
bulid_path=/data0/build/js
combine_type=1
online_path=/data1/nginx/htdocs/online

while getopts p:t:i:o:u:m:a:b: option
do
 case "$option" in
 "p") 
	product_name=$OPTARG 
  ;;
 "t") 
	svn_path=$OPTARG
  ;;
 "i") 
 	increment=$OPTARG
 ;;
 "o") 
	cmt=1
  ;;
 "u")
	combine_user=$OPTARG
 ;;
 "m")
 	machine_ip=$OPTARG
 ;;
 "a") 
	svn_user=$OPTARG
  ;;
 "b") 
	svn_pass=$OPTARG
  ;;
 ?) 
 	echo "error"
	exit 1
  ;;
 esac
done


main(){
	gSTART=`date +%s%N`

	#svncheck
	svncheckout
	jscombine
	rsyncfile
	echo '#END#'
	
	print_end_time $gSTART
}


svncheckout(){
	workspace=$bulid_path/$combine_user/$product_name/source

	#check source code from svn exist or not
	if [ -d "$workspace" ]; then
		BRANCH_INFO=`svn info $workspace | grep "URL: http" | awk '{if(match($0,/https:/)) print substr($0,RSTART,length($0))}'`
		echo "===>>>>>>pack svn path: ${svn_path}"
		echo "===>>>>>>local directory branch: `svn info $workspace | grep URL`"
		#same svn path, so update the branch
		if [ $svn_path == $BRANCH_INFO ]; then
			echo "===>>>>>>svn update begin<<<<<<===" 
			svn update $workspace --username $svn_user --password $svn_pass --trust-server-cert --non-interactive
			echo "===>>>>>>svn update end<<<<<<<<==="
		#diff svn path, go switch or checkout	
		else
			rm -rf $workspace
			echo "===>>>>>>svn checkout begin<<<<<<==="
			svn co $svn_path $bulid_path/$combine_user/$product_name/source --username $svn_user --password $svn_pass --trust-server-cert --non-interactive
			echo "===>>>>>>svn checkout end<<<<<<==="
		fi
	#source code from svn is not exist, do svn checkout
	else
		echo "===>>>>>>svn checkout begin<<<<<<==="
		svn co $svn_path $bulid_path/$combine_user/$product_name/source --username $svn_user --password $svn_pass --trust-server-cert --non-interactive
		echo "===>>>>>>svn checkout end<<<<<<==="
	fi
}


checkout(){
	rm -rf $bulid_path/$combine_user/$product_name/source
	echo "===>>>>>>start svn checkout<<<<<<==="
	svn co $svn_path $bulid_path/$combine_user/$product_name/source --username $svn_user --password $svn_pass
}

jscombine(){
	if [ $increment == 1 ]; then
		echo "===>>>>>>start jscombine increment<<<<<<==="
		$node_path $combinetool_path/js/main.js $bulid_path/$combine_user $product_name -minify	
	else
		echo "===>>>>>>start jscombine reset<<<<<<==="
		$node_path $combinetool_path/js/main.js $bulid_path/$combine_user $product_name -reset -minify
	fi
	#return $?
	if [ $? == 1 ]; then
		echo "node combine error!!!"
		echo "#ERROR#"
		exit 1
	fi
}

rsyncfile(){
	echo "===>>>>>>start rsync<<<<<<==="
	rsync -av $bulid_path/$combine_user/$product_name/publish_mini root@$machine_ip::qing_js_rel/$product_name
	rsync -av $bulid_path/$combine_user/$product_name/publish root@$machine_ip::qing_js_rel/$product_name
	if [ $? == 1 ]; then
		echo "rsyncfile error!!!"
		echo "#ERROR#"
		exit 1
	fi
}

# svncommit() {
# 	echo "Commit tag"
# 	#svn_root=https://svn.intra.sina.com.cn/icplatform/tech/ria_online
# 	svn_root=https://svn.sinaapp.com/flycode/1/ria_online

# 	path=`echo $svn_path | sed 's/.*\///g'`
	
# 	echo "Tag Name :"$path
	
# 	trunk_path=$svn_root/$product_name/trunk
# 	echo "trunk_path :"$trunk_path
	
# 	tag_path=$svn_root/$product_name/tags/${path}_v3
# 	echo "tag_path :"$tag_path
# 	local localTrunkTmpPath=$online_path/_tmp/$product_name
	
# 	rm -rf $localTrunkTmpPath
	
# 	mkdir -p $localTrunkTmpPath

# 	svn --username $svn_user --password $svn_pass --trust-server-cert --non-interactive co $trunk_path $localTrunkTmpPath
# 	cp -rf $online_path/$product_name/* $localTrunkTmpPath/
# 	svn --username $svn_user --password $svn_pass --trust-server-cert --non-interactive add $localTrunkTmpPath/* --force
# 	svn --username $svn_user --password $svn_pass --trust-server-cert --non-interactive commit $localTrunkTmpPath -m "test message"
	
# 	# check tag isn't exist
# 	exist=`svn --username $svn_user --password $svn_pass --trust-server-cert --non-interactive info $tag_path | grep URL: | wc -l`
# 	if [ $exist = 1 ] ;then
# 		echo ========================================== 
# 		echo ERROR : $tag_path has already exist!!
# 		echo ========================================== 
# 	else
# 		echo "*********************"
# 		echo $tag_path
# 		echo $trunk_path
# 		echo "*********************"
# 		svn --username $svn_user --password $svn_pass --trust-server-cert --non-interactive cp $trunk_path $tag_path -m "trunk to tags"
# 		echo ========================================== 
# 		echo OK : check $tag_path
# 		echo ========================================== 
# 	fi
# }


print_end_time() {
	#$1 $gSTART
	gEND=`date +%s%N`
	gELAPSED_TIME=`expr \( $gEND - $1 \) / 1000000`
	echo "Elapsed time ${gELAPSED_TIME}ms"
	echo "#END#"
}

main

