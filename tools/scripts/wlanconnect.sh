#!/bin/sh
ifconfig wlan0 up
iw dev wlan0 connect 802.11AC
ifconfig wlan0 192.168.1.42 netmask 255.255.255.0
route add default gw 192.168.1.1
