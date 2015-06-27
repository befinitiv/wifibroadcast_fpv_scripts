#!/bin/bash
# rx script


#adapt these to your needs
NIC0="wlan0"
NIC1="wlan1"
CHANNEL="13"



#################################


#change these only if you know what you are doing (and remember to change them on both sides)
RETRANSMISSION_BLOCK_SIZE=8
PORT=0

##################################

WBC_PATH="/home/pi/wifibroadcast"


# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


echo "updating wifi ($NIC0, $CHANNEL)"

ifconfig $NIC0 down
iw dev $NIC0 set monitor otherbss fcsfail
ifconfig $NIC0 up
iwconfig $NIC0 channel $CHANNEL

echo "updating wifi ($NIC1, $CHANNEL)"

ifconfig $NIC1 down
iw dev $NIC1 set monitor otherbss fcsfail
ifconfig $NIC1 up
iwconfig $NIC1 channel $CHANNEL

echo "Starting rx for $NIC"
$WBC_PATH/rx -p $PORT -b $RETRANSMISSION_BLOCK_SIZE $NIC0 $NIC1 | /opt/vc/src/hello_pi/hello_video/hello_video.bin 
