#!/bin/bash

#This script compiles the kernel...

# Init Script
KERNEL_DIR=$PWD
ZIMAGE=$KERNEL_DIR/arch/arm/boot/zImage
BUILD_START=$(date +"%s")
THREADS=9

# Color Code Script
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
nocol='\033[0m'         # Default

# Tweakable Options Below
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="DerCo0n"
export KBUILD_BUILD_HOST="AlienCo0n"
#export CROSS_COMPILE="/media/co0n/7a59f274-2a0c-4233-a4bf-03233b45a7e9/android-builds/lineage-galaxytab2/toolchains/arm-linux-androideabi-5.3/bin/arm-linux-androideabi-"
export CROSS_COMPILE="/media/co0n/7a59f274-2a0c-4233-a4bf-03233b45a7e9/android-builds/lineage-galaxytab2/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-"

# Compilation Scripts Are Below
compile_kernel ()
{
echo -e "$White***********************************************"
echo "         Compiling Espresso Kernel             "
echo -e "***********************************************$nocol"
make clean && make mrproper
#Which config to use
make espresso_defconfig
make menuconfig
BUILD_START=$(date +"%s")

make -j$THREADS
if ! [ -a $ZIMAGE ];
then
echo -e "$Red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
}

# Finalizing Script Below
case $1 in
clean)
make ARCH=arm -j$THREADS clean mrproper
rm -rf include/linux/autoconf.h
;;
*)
compile_kernel
;;
esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
