#!/bin/bash

function get_combo {
    array=( $(echo "$@" | awk -F ' ' '{for(i=1; i<=NF; i++) print $i}') )
    array_num=${#array[@]}
    for i in $(seq 1 $(( array_num - 1 )))
    do
        if [ "${array[0]}" != "${array[$i]}" ]; then
            echo "${array[0]} ${array[$i]}"
            echo "${array[$i]} ${array[0]}"
        fi
    done
}

IFS=$'\n'
if [ $# -ne 1 ]; then echo 'wrong: [parameter]'; exit -1; fi

parameter=$1

# create v_list
#para_value_list_dir='/root/reconf_test_gen/the_final/para_value_list'
para_value_list_dir='./para_value_list'
pv_line_num=$(grep -r ^"$parameter " $para_value_list_dir | wc -l)
current_line=0
max_line=1 # default, the first line
max_v_num=0
if [ $pv_line_num -ne 1 ]; then
    # resolve duplicates by using line with more values
    if [ $pv_line_num -ge 2 ]; then 
	for line in $(grep -r ^"$parameter " $para_value_list_dir)
	do
	    #1>&2 echo "line $line"
            current_line=$(( current_line + 1 ))
	    v_num=$(echo $line | awk '{print NF}')
	    if [ $v_num -gt $max_v_num ]; then max_v_num=$v_num; max_line=$current_line; fi
	done
	1>&2 echo "WARN: multiple pv lines for $parameter, let's use line $max_line with #value $max_v_num"
	#echo "WARN: multiple pv lines for $parameter, let's use line $max_line with #value $max_v_num"
    else
	echo "ERROR: check $parameter value list!"
    	exit -1
    fi
fi

prior_v_list=( $(grep -r ^"$parameter " $para_value_list_dir | head -n $max_line | tail -n 1 | awk -F ':' '{print $2}' | awk '{for(i=2;i<=NF;i++) print $i}') )
v_index=1
for v in ${prior_v_list[@]}
do
    v_list[$v_index]="$v"
    v_index=$(( v_index + 1 ))
done

for p in hdfs hbase yarn mapreduce hadoop-tools
do
    logs=$(grep -r ^"$parameter " $p/final/ultimate | awk -F '-ultimate-meta.txt' '{print $1"-ultimate-meta.txt"}' | sort -u)

    for log in ${logs[@]}
    do
	#echo log is $log
 	cannot_identify=$(echo $log | awk -F '/ultimate/' '{print $2}' | awk -F '-ultimate-meta.txt' '{print $1"-identify-cannot.txt"}')
	cannot_identify_log=$(echo "$p/final/identify/""$cannot_identify")
	if [ "$(grep ^"$parameter"$ $cannot_identify_log)" != "" ]; then 
	    #echo "$parameter is not identifiable in test $log"
	    continue; 
	fi
        
    	the_proj="$(echo $log | awk -F '/' '{print $1}')"
        the_test="$(echo $log | awk -F '/' '{print $4}' | awk -F '-ultimate-meta.txt' '{print $1}')"
        component_inits=( $(cat $log | grep ^"$parameter " | awk '{print $2}' | sort -u | awk -F '.' '{print $1}' | uniq -c | awk '{print $2" "$1}') )
	#echo ${component_inits[@]}	
    	# add the default value used for this component at this point and create value pairs	
	# WARN!!! It might be a problem that we didn't filter out null value in configuration get printing.
        value_used=( $(cat $log | grep ^"$parameter " | awk '{print $3}' | sort -u | head -n 1) )       
    	v_list[0]="$value_used"
    	v_pairs=( $(get_combo ${v_list[@]}) )
	
	for component_init in ${component_inits[@]}
	do
	    the_component=$(echo $component_init | awk '{print $1}')
	    the_inits=$(echo $component_init | awk '{print $2}')
    	    for v_p in ${v_pairs[@]}
	    do
	 	if [ $the_inits -eq 1 ]; then
		    echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_inits"" ""$v_p"
	 	else
	            echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" -1 ""$v_p"
	            echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" -2 ""$v_p"
	            echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" -3 ""$v_p"
		fi
	        #for the_init in $(seq 1 $the_inits)
	  	#do
		#    if [ $the_init -eq 1 ]; then
	        #        echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_init"" ""$v_p"
		#    else
	        #        echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_init"" ""$v_p"
	        #        echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_init"" ""$v_p"
		#    fi
    	        #done
	    done
	done
    done
done
