#!/bin/bash

# find white list
cf=0.9999; for hlog in getBoolean/*_hypothesis_*; do ~/parameter_test_controller/hypo_analysis.sh $hlog $cf 0; done | while read line; do ~/vm_images/the_final/result/extract_utility.sh $line para_and_comp; done

# mkdir parameter%component
for i in *; do p_and_c="$(../../extract_utility.sh $i 'para')%$(../../extract_utility.sh $i 'comp')"; if [ ! -d $p_and_c ]; then mkdir $p_and_c; fi; mv $i $p_and_c; done
