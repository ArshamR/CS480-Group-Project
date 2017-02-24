#!/bin/bash

if [ $# -ne 1 ]
	then
	echo "Usage: <Path to log file> "
	exit 1;
fi


count=0
while read p;
do
	timeS=`echo "$p" | awk '{ print $3 }'`
	port=`echo "$p" | awk '{ print $7 }'`
	ip=`echo "$p" | awk '{ print $9 }'`

	if [ "$timeS" = "$timePrev" -a "$port" = "$portPrev" -a "$ip = $ipPrev" ]
		then
			count=`expr $count + 1`
	
else
	let count=0
fi

if [ $count -ge 10 ]
	then 
	echo "**************DDOS ATTACK DETECTED*******"
fi

	echo "Count: $count"
	echo "Timestamp: $timeS"
	echo "Port: $port"
	echo "Ip: $ip"
	timePrev=$timeS
	portPrev=$port
	ipPrev=$ip


done < ddos.txt


