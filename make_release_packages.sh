#!/bin/sh
PROGRAM="hase"
VERSION="1.4.4.0"
DEST=./build/*
echo "<html>" > index.htm
echo "<head>" >> index.htm
echo "</head>" >> index.htm
echo "<body>" >> index.htm
TIME=`date -u +"%d.%m.%Y %R"`
echo "Updated at the $TIME." >> index.htm
echo "<h1>$PROGRAM download links:</h1>" >> index.htm
for f in $DEST
do
	if [ -e "$f/$PROGRAM/hase" ] || [ -e "$f/$PROGRAM/hase.exe" ]; then
		NAME=`echo "$f" | cut -d/ -f3 | cut -d. -f1`
		echo "$NAME:"
		echo "--> Copy temporary folders"
		cp -r data "$f/$PROGRAM"
		cp -r textures "$f/$PROGRAM"
		cp -r sounds "$f/$PROGRAM"
		cp hase_readme.txt "$f/$PROGRAM"
		cd $f
		echo "--> Create archive"
		if [ $NAME = "pandora" ]; then
			cd $PROGRAM
			../make_package.sh
			cd ..
			echo "<a href=$PROGRAM.pnd>$NAME</a></br>" >> ../../index.htm
		else
			if [ $NAME = "i386" ]; then
				tar cfvz "$PROGRAM-$NAME-$VERSION.tar.gz" * > /dev/null
				mv "$PROGRAM-$NAME-$VERSION.tar.gz" ../..
				echo "<a href=$PROGRAM-$NAME-$VERSION.tar.gz>$NAME</a></br>" >> ../../index.htm
			else
				#no Pandora, no PC. So we have a low resolution device!
				if [ $NAME != "win32" ]; then
					cp ../../small_resolution_data/* "$PROGRAM/data"
				fi
				if [ $NAME = "gcw" ]; then
					mksquashfs * "$PROGRAM.opk" -all-root -noappend -no-exports -no-xattrs
					mv "$PROGRAM.opk" ../..
					echo "<a href=$PROGRAM.opk type=\"application/x-opk+squashfs\">$NAME</a></br>" >> ../../index.htm
				else
					zip -r "$PROGRAM-$NAME-$VERSION.zip" * > /dev/null
					mv "$PROGRAM-$NAME-$VERSION.zip" ../..
					echo "<a href=$PROGRAM-$NAME-$VERSION.zip>$NAME</a></br>" >> ../../index.htm
				fi
			fi
		fi
		echo "--> Remove temporary folders"
		rm -r $PROGRAM/data
		rm -r $PROGRAM/textures
		rm -r $PROGRAM/sounds
		rm $PROGRAM/hase_readme.txt
		cd ..
		cd ..
	fi
done
echo "</body>" >> index.htm
echo "</html>" >> index.htm
