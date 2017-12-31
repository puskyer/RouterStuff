#!/bin/bash

BASE="~/src/routers/ChaosCalmer/"
SCRIPT="$BASE/openwrt/scripts/ipkg-make-index.sh"
USIGN="$BASE/openwrt/staging_dir/host/bin/usign"
KEY="$BASE/keys/openWrtUsign.key"

$USIGN -G -p $BASE/keys/openWrtUsign.pub -s $BASE/keys/openWrtUsign.key

# Generates package manifest
for i in `find . -type d` ; do

	$SCRIPT . 2>&1 > Packages.manifest
	grep -vE '^(Maintainer|LicenseFiles|Source|Require)' Packages.manifest > Packages
	gzip -9nc Packages > Packages.gz
	$USIGN -S -m Packages -s $KEY
	#$USIGN -S -m Packages -s ~/src/routers/ChaosCalmer/openwrt/key-build; 
done


# on router

# Add the public key
#wget http://youserver.ext/path/to/openWrtUsign.pub
#opkg-key add openWrtUsign.pub
#opkg update

# Install package
#opkg install  newPackage


