#!/bin/bash
# SINA RIA PUBLISH TOOL
# This is combine css shell
#svn_user=flylee2011@sina.com
#svn_pass=yifeilee09
node_path=/usr/local/node/bin/node
combinetool_path=/data0/combine_shell
bulid_path=/data0/build/css

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

	svncheckout
	csscombine
	rsyncfile
	
	print_end_time $gSTART
	echo '#END#'
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

	# rm -rf $bulid_path/$combine_user/$product_name/source
	# echo "------------------start svn checkout-------------------------"
	# svn co $svn_path $bulid_path/$combine_user/$product_name/source --username $svn_user --password $svn_pass
}

csscombine(){
	if [ $increment == 1 ]; then
		echo "===>>>>>>start csscombine increment<<<<<<==="
		$node_path $combinetool_path/css/main.js $bulid_path/$combine_user $product_name
	else
		echo "===>>>>>>start csscombine reset<<<<<<==="
		$node_path $combinetool_path/css/main.js $bulid_path/$combine_user $product_name -reset
	fi
}

rsyncfile(){
	echo "===>>>>>>start rsync<<<<<<==="
	rsync -av $bulid_path/$combine_user/$product_name/publish root@$machine_ip::qing_js_rel/$product_name
}

print_end_time() {
	#$1 $gSTART
	gEND=`date +%s%N`
	gELAPSED_TIME=`expr \( $gEND - $1 \) / 1000000`
	echo "Elapsed time ${gELAPSED_TIME}ms"
	echo "#END#"
}

main

