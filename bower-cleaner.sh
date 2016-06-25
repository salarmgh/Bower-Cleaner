#!/bin/bash

### Check arguments
if [ $# -ne 2 ]; then
	echo "Bad arguments"
	echo "clean-bower TMP_DIR INSTALL_DIR"
	exit 1
fi

### Set enviroment directories
TMP_DIR=$1
INSTALL_DIR=$2
if [ ! -d $TMP_DIR ]; then
	echo "$TMP_DIR not exists"
	exit 1
fi
if [ ! -d $INSTALL_DIR ]; then
	echo "$INSTALL_DIR not exists"
	exit 1
fi
cd $TMP_DIR

### Install bower components
bower install --allow-root
if [ ! -d bower_components ]; then
	echo "bower_components not exists"
	exit 1
fi

### Delete existing bower_components
echo $INSTALL_DIR/bower_components
read -p "I want to delete these files(y,n): " answer
if [ "$answer" = "y" ]; then
	rm -rf $INSTALL_DIR/bower_components
else
	exit 1
fi
### Copy new bower_components
cp -r bower_components $INSTALL_DIR
cd $INSTALL_DIR/bower_components

### Find unnecessary files
find . -type f -regextype sed ! -regex ".*\.\(js\|css\|eot\|svg\|ttf\|woff\|woff2\)"


### Find dist folders
for component in `ls -d *`; do
	cd $component
	if find . -maxdepth 1 -type d -iname dist | egrep ".*" > /dev/null 2>&1; then
		echo $component
		find . -maxdepth 1 ! -iname dist ! -path .
	echo "---"
	else
		echo "$component has no dist directory"
		echo "---"
	fi
	cd ..
done

### Find not min files
find . -type f -iname "*min*" | sed 's/.min//g'


### Find demo directories
find . -type d -iname "demo"

read -p "I want to delete these files(y,n): " answer
if [ "$answer" = "y" ]; then
	### Delete unnecessary files
	rm `find . -type f -regextype sed ! -regex ".*\.\(js\|css\|eot\|svg\|ttf\|woff\|woff2\)"`
	### Delete not dist folders
	for component in `ls -d *`; do
	cd $component
	if find . -maxdepth 1 -type d -iname dist | egrep ".*" > /dev/null 2>&1; then
		find . -maxdepth 1 ! -iname dist ! -path . -exec rm -r {} \;
	fi
	cd ..
done

### Delete not min files
rm `find . -type f -iname "*min*" | sed 's/.min//g'` > /dev/null 2>&1

### Delete demo directories
rm -r `find . -type d -iname "demo"`
	
else
	exit 1
fi

exit 0
