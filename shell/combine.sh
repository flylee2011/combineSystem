#!/bin/bash
# SINA RIA PUBLISH TOOL

#svn_user=flylee2011@sina.com
#svn_pass=yifeilee09
node_path=/usr/local/node/bin/node
combinetool_path=/data0/combine_shell
bulid_path=/data0/build/js
combine_type=1

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

	checkout
	jscombine
	rsyncfile
	#echo $svn_path
	#echo $product_name
	#echo $increment
	#echo $machine_ip
	#echo $svn_user
	#echo $svn_pass
	#echo $combine_user
	print_end_time $gSTART
	echo '#END#'
}

checkout(){
	rm -rf $bulid_path/$combine_user/$product_name/source
	echo "------------------start svn checkout-------------------------"
	svn co $svn_path $bulid_path/$combine_user/$product_name/source --username $svn_user --password $svn_pass
}

jscombine(){
	if [ $increment == 1 ]; then
		echo "------------------start jscombine increment----------------------------"
		$node_path $combinetool_path/js/main.js $bulid_path/$combine_user $product_name -minify	
	else
		echo "------------------start jscombine reset----------------------------"
		$node_path $combinetool_path/js/main.js $bulid_path/$combine_user $product_name -reset -minify
	fi
}

rsyncfile(){
	echo "------------------start rsync--------------------------------"
	rsync -av $bulid_path/$combine_user/$product_name/publish_mini root@$machine_ip::qing_js_rel/$product_name
}

print_end_time() {
	#$1 $gSTART
	gEND=`date +%s%N`
	gELAPSED_TIME=`expr \( $gEND - $1 \) / 1000000`
	echo "Elapsed time ${gELAPSED_TIME}ms"
	echo "#END#"
}

main

