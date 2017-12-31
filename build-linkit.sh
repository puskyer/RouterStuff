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


if [ `grep -q 7688 feeds.conf` ] ; then
	echo src-git linkit https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git >> feeds.conf 
fi

./scripts/feeds update  -a

./scripts/feeds install -d m -a

# make config-clean
cat ../config.linkit  >>.config
make defconfig


#make menuconfig

make V=s prereq  && make V=s download && make V=s tools/install  && make V=s toolchain/install && make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log

#make IGNORE_ERRORS=1  kernel_oldconfig
#make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log
