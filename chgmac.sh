#!/bin/bash
# Script for quickly changing the mac address on your Mac with OSX
if [ `printf "$1"|wc -c|awk '{print $1}'` -gt 0 ];then
	CURETH="`ifconfig $1 | grep ether |awk '{ print $2 }'`"
	if [ `printf "$2"|wc -c|awk '{print $1}'` -gt 0 ]; then
		NEWETH=${CURETH:0:12}${1:0:2}:${1:2:2}
		TESTLEN=`printf $NEWETH| wc -c| awk '{ print $1 }'`

		if [ $TESTLEN -eq 17 ]; then
			if [[ "$NEWETH" =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]]; then
				echo Success: Mac address valid! \:\)
				sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
				sudo ifconfig en0 ether $NEWETH
				sudo networksetup -detectnewhardware
			else
				echo Failure: Mac address invalid \:\(
			fi
		else
			echo Failure: Length is invalid \($NEWETH\)
		fi
	else
		echo Failure: Missing Mac input!
		echo Current mac address: $CURETH
	fi
else
	echo usage: chgmac.sh [interface] [a-fA-F0-9]x4
fi
