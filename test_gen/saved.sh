#!/bin/bash

# show component init() stats
for proj in mapreduce hadoop-tools yarn hdfs hbase; do echo "proj: $proj"; grep -rn ' init,' $proj/final/component/ | awk '{print $2}' | sort | uniq -c | sort -n -r -k1 | awk '{print $1" "$2}'; echo ''; done

# get all get-parameter table
for dir in $(find . -name parameter); do for i in $dir/*; do cat $i | awk '{print $5" "$3}'; done; done | sort -u > all_get_parameter.txt

# get 5-xml get-parameter
IFS=$'\n'; for line in $(cat all_get_parameter.txt); do para=$(echo $line | awk '{print $2}'); if [ "$(grep ^"$para"$ all_xml_parameters.txt)" != "" ]; then echo "$line"; fi; done 

# test num for each parameter
for i in *; do echo "$i $(cat $i | wc -l)"; done | sort -n -k2 -r

# test num for each component
cat * | awk '{print $4}' | sort  | uniq -c | sort -n -k1 -r

# generate testing tuples
pids=(); for p in $(cat ./paras_this_round.txt); do ./generate_ff.sh $p > testing_tuples_this_round/"$p".txt & pids+=($!); done; for id in ${pids[@]}; do wait $id; echo "$id done"; done

# num of tested parameters
find para_value_list/ -name '*.txt' | while read line; do cat $line; done | awk '{print $1}' | sort -u | wc -l

# remove parameters that already tested
IFS=$'\n'; for line in $(cat all_xml_get_parameter.txt); do para=$(echo $line | awk '{print $2}'); if [ "$(grep -rn ^"$para " para_value_list)" == "" ]; then echo "$line"; fi; done > all_xml_get_parameter_left.txt

# filter left.txt
cat all_xml_get_parameter_left.txt | awk '{print $2}' | sort -u > left.txt

grep -v -e '.address' -e '.bind-host' -e '.principal' -e '.parent-path' -e '.class' -e '.path' -e '.hostname' -e '.hosts' -e '-dir'$ -e '.port' -e '.dir' -e '.bindAddress' -e '.id' -e '.impl' -e '.file' -e '.keytab' -e '.uri' -e '.url' left.txt > left_select.txt
