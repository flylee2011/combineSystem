#!/bin/bash
# SINA RIA PUBLISH TOOL

#svn_user=flylee2011@sina.com
#svn_pass=yifeilee09
node_path=/usr/local/node/bin/node
combinetool_path=/home/flylee/combineTool
bulid_path=/home/flylee/workspace/build
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
	pack_user=$OPTARG
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
	
}

checkout(){
	svn co $svn_path $bulid_path/1/$product_name/source
}

jscombine(){
	$node_path $combinetool_path/js/main.js $bulid_path/1 $product_name -reset -minify
}

main

