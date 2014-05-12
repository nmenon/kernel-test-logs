#!/bin/bash
DIR=`realpath $1`
if [ ! -d "$DIR" ]; then
	echo "$DIR ($1) is not a directory?"
	exit 1
fi
SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`

TAG=`basename $DIR`

cd $SCRIPT_DIR;
set -x
REMOVE=`ls -d *|grep -v "sh$"`
echo "REMOVE $REMOVE"
git rm -r $REMOVE
set +x
LOG_FILE=$SCRIPT_DIR/README.txt
echo "Automated logs for TAG=$TAG">$LOG_FILE
date>>/$LOG_FILE
for i in `ls -d $DIR/*`
do
	build_name=`basename $i`
	dname=$SCRIPT_DIR/$build_name
	mkdir -p $dname
	cp -rvf $i/*.txt $dname
	cp -rvf $i/.config $dname/config
	cp -rvf $i/Kerr $dname/Kerr
	cd $dname
	echo "====defconfig=$build_name===" >> $LOG_FILE
	check-logs.sh >>$LOG_FILE
done

cd $SCRIPT_DIR
git add *
git commit -a -s -m "Logs from file $TAG"
git tag -m "Applying auto tag $TAG" $TAG
