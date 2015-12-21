#!/bin/bash
# rx script

#wait a bit until the wifi cards are ready
sleep 2



source settings.sh

DISPLAY_PROGRAM="/opt/vc/src/hello_pi/hello_video/hello_video.bin" 




function prepare_nic {
	DRIVER=`cat /sys/class/net/$1/device/uevent | grep DRIVER | sed 's/DRIVER=//'`

	case $DRIVER in
		ath9k_htc)
			echo "Setting $1 to channel $CHANNEL2G"
			ifconfig $1 down
			iw dev $1 set monitor otherbss fcsfail
			ifconfig $1 up
			iwconfig $1 channel $CHANNEL2G
		;;
		rt2800usb) echo "$DRIVER new shit"
			echo "Setting $1 to channel $CHANNEL5G"
			ifconfig $1 down
			iw dev $1 set monitor otherbss fcsfail
			ifconfig $1 up
			iw reg set BO
			iwconfig $1 rate 24M
			iwconfig $1 channel $CHANNEL5G
		;;
		*) echo "ERROR: Unknown wifi driver on $1: $DRIVER" && exit
		;;
	esac
}




################################# SCRIPT START #######################


# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


#prepare NICS
for NIC in $NICS
do
	prepare_nic $NIC
done

if [ -d "$SAVE_PATH" ]; then
	echo "Starting with recording"
	FILE_NAME=$SAVE_PATH/`ls $SAVE_PATH | wc -l`.rawvid
	$WBC_PATH/rx -p $PORT -b $BLOCK_SIZE -r $FECS -f $PACKET_LENGTH $NICS | tee $FILE_NAME | $DISPLAY_PROGRAM
else
	echo "Starting without recording"
	$WBC_PATH/rx -p $PORT -b $BLOCK_SIZE -r $FECS -f $PACKET_LENGTH $NICS | $DISPLAY_PROGRAM
fi

