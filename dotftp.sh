#!/bin/bash

comm=enp0s25

ethtool  -s $comm autoneg off
ifconfig $comm 192.168.1.2
arp -i $comm -s 192.168.1.1   10:BF:48:E6:97:BF

# ping -c2 192.168.1.1

echo -e "binary\nrexmt 1\ntimeout 60\ntrace\nput $1\n" | tftp -v -4 192.168.1.1
