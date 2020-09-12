#!/bin/bash

IFS=$'\n'

function try_group {
    local begin_line=$1
    local end_line=$2
    local group_size=$3
    local current_line=$begin_line
    local current_group=()
    local group_line_begin=$begin_line
    
    #echo "try_group begin $begin_line end $end_line group_size $group_size"

    while [ $current_line -le $end_line ]
    do
        line="$(sed -n "$current_line"p $log)"
        #echo "line = $line"
        current_group+=("$line")
        
        # when reach the last line or group reach group_size
        if [ ${#current_group[@]} -ge $group_size ] || [ $current_line -eq $end_line ]; then
            the_test=$(echo ${current_group[0]} | awk '{print $1}')
            
            # set group end line
            group_line_end=$current_line
           
            # check if duplicate
            para_array=()
            for tuple in ${current_group[@]}
            do
                para=$(echo $tuple | awk '{print $3}')
                para_array+=("$para")
            done

            uniq_paras=$(echo ${para_array[@]} | tr ' ' '\n' | sort -u | wc -l)
            if [ ${#para_array[@]} -eq $uniq_paras ]; then
                #echo "------Unique parameter group------:"
                local line_count=0
                combined_tuple=$(for per_line in ${current_group[@]}; do 
                    echo $per_line | awk '{printf "%s",$3"@@@"$4"@@@"$5"@@@"$6"@@@"$7}'
                    line_count=$(( line_count + 1 ))
                    if [ $line_count -lt ${#current_group[@]} ]; then echo -n '%%%'; fi
                done)
                echo "combined_tuple=$combined_tuple"
            else
                # try 1/2 group_size when duplicate in a group
                try_group $group_line_begin $group_line_end $(( group_size / 2 ))
            fi

            # clear group
            current_group=()
            # group start line is the next coming line
            group_line_begin=$(( current_line + 1 ))
        fi
    
        current_line=$(( current_line + 1 ))
    done
}

log=$1
MAX_GROUP_SIZE=10
try_group 1 $(cat $log | wc -l) $MAX_GROUP_SIZE
