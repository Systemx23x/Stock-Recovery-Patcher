#!/bin/bash

sudo apt install lz4 tar openssl engrampa 7z -y

if [ -f recovery.img.lz4 ];then
	lz4 -f recovery.img.lz4 recovery.img
fi

if [ -f recovery.img.lz4 ];then
	mv recovery.img.lz4 recovery.img.lz4-orig
fi

off=$(grep -ab -o SEANDROIDENFORCE recovery.img |tail -n 1 |cut -d : -f 1)
dd if=recovery.img of=r.img bs=4k count=$off iflag=count_bytes

mkdir unpack
cd unpack
../magiskboot unpack ../r.img
../magiskboot cpio ramdisk.cpio extract
engrampa --extract-here ramdisk.cpio
7z x ramdisk.cpio

grep -e ro.product.cpu.abi -e ro.product.build.version.incremental -e ro.vendor.build.version.sdk prop.default > ../props.txt

# Reverse fastbootd ENG mode check
../magiskboot hexpatch system/bin/recovery e10313aaf40300aa6ecc009420010034 e10313aaf40300aa6ecc0094 # 20 01 00 35
../magiskboot hexpatch system/bin/recovery eec3009420010034 eec3009420010035
../magiskboot hexpatch system/bin/recovery 3ad3009420010034 3ad3009420010035
../magiskboot hexpatch system/bin/recovery 50c0009420010034 50c0009420010035
../magiskboot hexpatch system/bin/recovery 080109aae80000b4 080109aae80000b5
../magiskboot hexpatch system/bin/recovery 20f0a6ef38b1681c 20f0a6ef38b9681c
../magiskboot hexpatch system/bin/recovery 23f03aed38b1681c 23f03aed38b9681c
../magiskboot hexpatch system/bin/recovery 20f09eef38b1681c 20f09eef38b9681c
../magiskboot hexpatch system/bin/recovery 26f0ceec30b1681c 26f0ceec30b9681c
../magiskboot hexpatch system/bin/recovery 24f0fcee30b1681c 24f0fcee30b9681c
../magiskboot hexpatch system/bin/recovery 27f02eeb30b1681c 27f02eeb30b9681c
../magiskboot cpio ramdisk.cpio 'add 0755 system/bin/recovery system/bin/recovery'
../magiskboot cpio ramdisk.cpio 'add 0755 prop.default prop.default'
../magiskboot repack ../r.img new-boot.img
cp new-boot.img ../recovery-patched.img
cd ..

rm recovery.img
mv recovery-patched.img recovery.img

if [ -f recovery.img ];then
	lz4 -B6 --content-size recovery.img
fi

tar cvf patched-recovery.tar recovery.img.lz4 vbmeta.img.lz4
md5sum -t patched-recovery.tar >> patched-recovery.tar
mv patched-recovery.tar patched-recovery.tar.md5

rm r.img
rm -r unpack
rm recovery.img
rm recovery.img.lz4
