#!/bin/bash


#target=DIR601A1
#target=WZRHPG300NH

#antoniy
target=TLWDR4300

cd ~/src/routers/ChaosCalmer/openwrt

make distclean
ln -sf ../dl

git pull

make config-clean
cat ../config.ar71xx-generic  >>.config
make defconfig

if  [ ! `grep CONFIG_TARGET_ar71xx_generic_$target=y .config` ] ; then

cp .config config.tmp
sed 's/^CONFIG_TARGET_ar71xx_generic_\(A-Z0-9]*\)=y/CONFIG_TARGET_ar71xx_generic_$target=y/g' config.tmp >.config
fi


./scripts/feeds update -a
./scripts/feeds install -d m -a

make prereq
make download
make tools/install
make toolchain/install

#make menuconfig

make IGNORE_ERRORS=1 kernel_menuconfig
make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log
