#!/bin/bash

MAXIMUM_JPG_SIZE=250
PNG_OPTIMIZATION_LEVEL=2
hugo

if hash exiftool 2>/dev/null; then
	exiftool -all= public/images*
else
	echo "Install perl-image-exiftool to optimize images"
fi

if hash jpegoptim 2>/dev/null; then
	for image in $(find public/images -regextype posix-extended -iregex ".*\.(jpeg|jpg)"); do
		mogrify -resize '1400>' $image
		jpegoptim --strip-all --size=$MAXIMUM_JPG_SIZE $image
	done;
else
	echo "Install jpegoptim to optimize JPEG images"
fi

if hash optipng 2>/dev/null; then
	for image in $(find public/images -regextype posix-extended -iregex ".*\.(png)"); do
		mogrify -resize '1400>' $image
		optipng -clobber -strip all -o $PNG_OPTIMIZATION_LEVEL $image
	done;
else
	echo "Install optipng to optimize PNG images"
fi
