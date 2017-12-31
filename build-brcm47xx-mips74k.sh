#!/bin/bash

cd ~/src/routers/ChaosCalmer/openwrt

#make distclean
#ln -sf ../dl
if [ -e .config ] ; then rm .config fi

git pull

if [ ! -e feeds.conf ] ; then
	sed 's/^\(src-git telephony.*\)/#\1/g' feeds.conf.default >feeds.conf
elif [ `grep telephony feeds.conf` ] 
	sed 's/^\(src-git telephony.*\)/#\1/g' feeds.conf >/tmp/feeds.conf
	cp /tmp/feeds.conf .
fi


./scripts/feeds update  -a

./scripts/feeds install -d m -a

# make config-clean
cat ../config.brcm47xx-mips74k  >>.config
make defconfig


#make menuconfig

make download && make toolchain/install && make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log

