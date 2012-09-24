#!/bin/bash
# SINA RIA PUBLISH TOOL

#svn_user=flylee2011@sina.com
#svn_pass=yifeilee09
node_path=/usr/local/node/bin/node
combinetool_path=/data0/combine_shell
bulid_path=/data0/build
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
	checkout
	jscombine
	#echo $svn_path
	#echo $product_name
	#echo $increment
	#echo $machine_ip
	#echo $svn_user
	#echo $svn_pass
	#echo $combine_user
	echo '#END#'
}

checkout(){
	rm -rf $bulid_path/$combine_user/$product_name/source
	svn co $svn_path $bulid_path/$combine_user/$product_name/source --username $svn_user --password $svn_pass
}

jscombine(){
	$node_path $combinetool_path/js/main.js $bulid_path/$combine_user $product_name -reset -minify
}

main

