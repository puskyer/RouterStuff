#!/bin/bash

IFS='='
while  read -r item1 item2; do
  item3=`grep $item1 openwrt/.config | sed "s/^$item1=\(.\)$/\1/g"` 
  echo "$item1 is $item2 = $item3"
done <config.rt-n16.diff