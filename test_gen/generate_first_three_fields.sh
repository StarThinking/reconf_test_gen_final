#!/bin/bash

IFS=$'\n'
if [ $# -ne 1 ]; then echo 'wrong: [parameter]'; exit -1; fi

parameter=$1

for p in hdfs hbase yarn mapreduce hadoop-tools
do
    logs=$(grep -r ^"$parameter " $p/final/ultimate | awk -F '-ultimate-meta.txt' '{print $1"-ultimate-meta.txt"}' | sort -u)

    for log in ${logs[@]}
    do
	#echo log is $log
        
    	the_proj="$(echo $log | awk -F '/' '{print $1}')"
        the_test="$(echo $log | awk -F '/' '{print $4}' | awk -F '-ultimate-meta.txt' '{print $1}')"
        component_inits=( $(cat $log | grep ^"$parameter " | awk '{print $2}' | sort -u | grep -v OtherComponent | awk -F '.' '{print $1}' | uniq -c | awk '{print $2" "$1}') )

	for component_init in ${component_inits[@]}
	do
	    the_component=$(echo $component_init | awk '{print $1}')
	    echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"
	done
    done
done
