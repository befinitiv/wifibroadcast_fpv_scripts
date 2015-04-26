#!/bin/bash
# rx script


#adapt these to your needs
NIC="wlan0"
CHANNEL="13"


##################################


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


echo "updating wifi ($NIC, $CHANNEL)"

ifconfig $NIC down
iw dev $NIC set monitor otherbss fcsfail
ifconfig $NIC up
iwconfig $NIC channel $CHANNEL

echo "Starting rx for $NIC"
$WBC_PATH/rx -p $PORT -b $RETRANSMISSION_BLOCK_SIZE $NIC | /opt/vc/src/hello_pi/hello_video/hello_video.bin 
