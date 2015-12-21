#!/bin/bash


# Camera image settings
WIDTH=1280
HEIGHT=720
FPS=48
BITRATE=4000000
KEYFRAMERATE=48



# Transmission and recording settings
CHANNEL2G="13"
CHANNEL5G="149"
NICS=`ls /sys/class/net | grep wlan`
SAVE_PATH="/media/usb0/video"




##################################
#change these only if you know what you are doing (and remember to change them on both sides)
BLOCK_SIZE=8
FECS=4
PACKET_LENGTH=1024
PORT=0
WBC_PATH="/home/pi/wifibroadcast"
##################################

