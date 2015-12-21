#!/bin/bash
# tx script

#if we detect no camera, we fall asleep
if vcgencmd get_camera | grep -q detected=0; then
	sleep 365d
fi

#wait a bit. this helps automatic starting
sleep 2

source settings.sh


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

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


prepare_nic $NICS

echo "Starting tx for $NICS"
raspivid -ih -t 0 -w $WIDTH -h $HEIGHT -fps $FPS -b $BITRATE -n -g $KEYFRAMERATE -pf high -o - | $WBC_PATH/tx -p $PORT -b $BLOCK_SIZE -r $FECS -f $PACKET_LENGTH $NICS

killall raspivid
killall tx
