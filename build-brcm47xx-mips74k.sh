#!/bin/bash


cd ~/src/routers/ChaosCalmer/openwrt

make distclean
ln -sf ../dl

git pull

make config-clean
cat ../config.brcm47xx-mips74k  >>.config
make defconfig

./scripts/feeds update -a
./scripts/feeds install -d m -a

make prereq
make download
make tools/install
make toolchain/install

#make menuconfig

make IGNORE_ERRORS=1 kernel_menuconfig
make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log
