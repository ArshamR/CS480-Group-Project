#!/bin/bash

if [ $# -ne 1 ]
	then
	echo "Usage: <Path to log file> "
	exit 1;
fi

rm results.txt
declare -a sourceIps
count=0
while read p;
do
	timeS=`echo "$p" | awk '{ print $3 }'`
	port=`echo "$p" | awk '{ print $7 }'`
	ip=`echo "$p" | awk '{ print $9 }'`
	sourceIp=`echo "$p" | awk '{ print $8 }'`

	if [ "$timeS" = "$timePrev" -a "$port" = "$portPrev" -a "$ip" = "$ipPrev" ]
		then
			sourceIps[$count]=$sourceIp
			count=`expr $count + 1`


	elif [ $count -ge 10 ]
	then 
		echo "**************DDOS ATTACK DETECTED*******"
		printf '%s\n' "${sourceIps[@]}" >> results.txt
		printf '%s\n' "$portPrev" >> results.txt
		printf '%s\n' "$timePrev" >> results.txt
		printf '%s\n' "*" >> results.txt

		let count=0
		sourceIps=()
	else
		let count=0
		sourceIps=()
	fi


	timePrev=$timeS
	portPrev=$port
	ipPrev=$ip

done < ddos.txt


