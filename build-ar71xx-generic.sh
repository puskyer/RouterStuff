#!/bin/bash

#target=DIR601A1
#target=WZRHPG300NH
#target=WRT400N
#target=TLWR841

#antoniy
#target=TLWDR4300

targets="WZRHPG300NH WRT400N DIR601A1 TLWR841 TLWDR4300" 


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
cat ../config.ar71xx-generic  >.config
make defconfig

# make V=s prereq  && make V=s download && make V=s tools/install  && make V=s toolchain/install && make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log

make  download && make toolchain/install

for target in  $targets ; do

	if  [ ! `grep CONFIG_TARGET_ar71xx_generic_$target=y .config` ] ; then
		cp .config config.tmp
		sed 's/^CONFIG_TARGET_ar71xx_generic_\(A-Z0-9]*\)=y/CONFIG_TARGET_ar71xx_generic_$target=y/g' config.tmp >.config
	fi

	make IGNORE_ERRORS=1  V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log
done
