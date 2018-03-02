#!/bin/bash

# git clone https://www.github.com/openwrt/openwrt -b chaos_calmer

cd ~/src/routers/ChaosCalmer/openwrt/

make distclean

ln -sf ../dl ./dl

#if [ -e .config ] ; then rm .config fi

git pull

if [ ! -e feeds.conf ] ; then
	sed 's/^\(src-git telephony.*\)/#\1/g' feeds.conf.default >feeds.conf
else
	if [ `grep telephony feeds.conf` ] ; 	then
		sed 's/^\(src-git telephony.*\)/#\1/g' feeds.conf >/tmp/feeds.conf
		cp /tmp/feeds.conf .
	fi
fi


./scripts/feeds update  -a
./scripts/feeds install -d m -a

# make config-clean
cat ../config.brcm47xx-mips74k  >>.config
make defconfig

#make menuconfig

make download && make toolchain/install && make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log

