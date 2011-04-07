#!/bin/bash

tag=OTB-OC-AOSP

WORK=`pwd`
cd ..

if [ ! -d arm-2009q3 ]; then
	tarball="arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2"
	if [ ! -f "$tarball" ]; then
		wget http://www.codesourcery.com/public/gnu_toolchain/arm-none-linux-gnueabi/"$tarball"
	fi
	tar -xjf "$tarball"
fi

cd $WORK
rm -f kernel_update-"$tag".zip
make clean mrproper
make ARCH=arm OTB_defconfig
make -j `expr $(grep processor /proc/cpuinfo | wc -l) + 1` CROSS_COMPILE=../arm-2009q3/bin/arm-none-linux-gnueabi- \
	ARCH=arm HOSTCFLAGS="-g -O3"

cp -p arch/arm/boot/zImage update/kernel_update
cd update
zip -r -q kernel_update.zip . 
mv kernel_update.zip ../kernel_update-"$tag".zip
