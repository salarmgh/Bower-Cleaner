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

### cp usable formats
cp -r --parents `find bower_components -type f -regextype sed -regex ".*\.\(js\|css\|eot\|svg\|ttf\|woff\|woff2\)"` $INSTALL_DIR

### Get dist folders
cd $INSTALL_DIR/bower_components
for component in `ls -d *`; do
	cd $component
	if find . -maxdepth 1 -type d -iname dist | egrep ".*" > /dev/null 2>&1; then
		find . -maxdepth 1 ! -iname dist ! -path . -exec rm -r {} \;
	else
		echo "$component has no dist directory"
	fi
	cd ..
done

### Delete not min files
rm `find . -type f -iname "*min*" | sed 's/.min//g'` > /dev/null 2>&1

### Delete demo directories
rm -r `find . -type d -iname "demo"`
exit 0
