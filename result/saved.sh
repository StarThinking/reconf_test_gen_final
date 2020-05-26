#! find white list
cf=0.9999999; for i in $(find . -name *_hypothesis_*); do ~/parameter_test_controller/hypo_analysis.sh $i $cf; done | while read line; do para=$(sed -n 1p $line | awk '{print $2}'); comp=$(sed -n 2p $line | awk '{print $2}'); echo "$para $comp"; done | sort -u
