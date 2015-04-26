#!/bin/bash
# rx script


#adapt these to your needs
NIC="wlan0"
CHANNEL="6"


##################################


#change these only if you know what you are doing
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
iwconfig wlan0 channel 13

echo "Starting rx for $NIC"
/home/pi/wifibroadcast/rx -p $PORT -b $RETRANSMISSION_BLOCK_SIZE $NIC | /opt/vc/src/hello_pi/hello_video/hello_video.bin 
