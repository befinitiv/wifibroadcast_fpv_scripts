#!/bin/bash
# rx script


#adapt these to your needs
NIC="wlan7"
CHANNEL="13"


##################################


#change these only if you know what you are doing (and remember to change them on both sides)
RETRANSMISSION_BLOCK_SIZE=8
PORT=0

##################################




# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


echo "updating wifi ($NIC, $CHANNEL)"

ifconfig wlan0 down
iw dev wlan0 set monitor otherbss fcsfail
ifconfig wlan0 up
iwconfig wlan0 channel $CHANNEL

echo "Starting rx for $NIC"
/home/pi/wifibroadcast/rx -p $PORT -b $RETRANSMISSION_BLOCK_SIZE $NIC | /opt/vc/src/hello_pi/hello_video/hello_video.bin 
