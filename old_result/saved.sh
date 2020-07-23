#!/bin/bash

# find white list
cf=0.99999; for hlog in *_hypothesis_*; do ~/parameter_test_controller/hypo_analysis.sh $hlog $cf 0; done | while read line; do ~/vm_images/the_final/result/extract_utility.sh $line para_and_comp; done

mkdir no_need_hypo/; cf=0.99999; for hlog in *_hypothesis_*; do ~/parameter_test_controller/hypo_analysis.sh $hlog $cf 0; done | while read line; do mv $line no_need_hypo/; done

# mkdir parameter%component
for i in *; do p_and_c="$(~/vm_images/the_final/result/extract_utility.sh $i 'para')%$(~/vm_images/the_final/result/extract_utility.sh $i 'comp')"; if [ ! -d $p_and_c ]; then mkdir $p_and_c; fi; mv $i $p_and_c; done

# generate para hypo test tuples
hypo_repeat=20; parallel=10; for i in $(seq 1 $parallel); do echo "$(./extract_utility.sh getInt/no_need_hypo/dfs.datanode.directoryscan.interval%hdfs\:DataNode/dfs.datanode.directoryscan.interval%org.apache.hadoop.hdfs.TestReplication#testReplicationWhenBlockCorruption_-1368869618_hypothesis_2020-06-20-12-54-37.txt_3 tuple) $hypo_repeat"; done
