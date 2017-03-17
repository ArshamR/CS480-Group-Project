#!/bin/bash

if [ $# -ne 2 ]
	then
	echo "Usage: <output file>, <log file> (Don't include path, file must be in same directory) "
	exit 1;
fi

if [ ! -e $2 ] 
	then
	echo "Log file does not exist"
	exit
fi

if [ -e $1 ]
	then
		rm $1
fi

results=$1
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
		echo "Targeted IP: $ipPrev"
		echo "Targeted Port: $portPrev"
		echo "Time: $timePrev"
		echo "Number of hits $count"
		printf '%s\n' "${sourceIps[@]}" >> $results
		printf '%s\n' "$portPrev" >> $results
		printf '%s\n' "$timePrev" >> $results
		printf '%s\n' "$ipPrev" >> $results
		printf '%s\n' "*" >> $results

		let count=0
		sourceIps=()
	else
		let count=0
		sourceIps=()
	fi

	timePrev=$timeS
	portPrev=$port
	ipPrev=$ip

done < $2