#!/bin/bash

#This script compiles the kernel...

# Init Script
KERNEL_DIR=$PWD
ZIMAGE=$KERNEL_DIR/arch/arm/boot/zImage
BOOTIMAGEDIR=$KERNEL_DIR/boot-image_espresso_lineage
OUTBOOTIMGNAME=coonzmod-oc1G3_boot_arm-eabi_4.6.img
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
#export CROSS_COMPILE="/media/co0n/7a59f274-2a0c-4233-a4bf-03233b45a7e9/android-builds/lineage-galaxytab2/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-"
export CROSS_COMPILE="/media/co0n/7a59f274-2a0c-4233-a4bf-03233b45a7e9/android-builds/lineage-galaxytab2/toolchains/arm-eabi-4.6/bin/arm-eabi-"

# Packs compiled zImage into flashable boot.img
pack_image ()
{
cd $BOOTIMAGEDIR
abootimg -x boot.img
sed -i '/bootsize =/d' bootimg.cfg
echo "Packing $ZIMAGE into $BOOTIMAGEDIR/$OUTBOOTIMGNAME"
abootimg --create $OUTBOOTIMGNAME -f bootimg.cfg -k $ZIMAGE -r initrd.img
cd $KERNEL_DIR
#exit 0
}

# Compilation Scripts Are Below
compile_kernel ()
{
echo -e "$White***********************************************"
echo "         Compiling Espresso OC-Kernel             "
echo -e "***********************************************$nocol"
make clean && make mrproper
#Which config to use

make espresso-coon-oc_defconfig #Default config
#make espresso-coon_defconfig #Default config
#make espresso-coon-nhp_defconfig #Kali Nethunter enabled config
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
pack_image
;;
esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
