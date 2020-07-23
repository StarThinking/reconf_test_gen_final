# generate components.txt (exclude OtherComponent) and parameters.txt for each test
for i in *; do cat $i | awk '{print $1}' | sort -u > ../statistic/$i.parameters; done; for i in *; do cat $i | awk '{print $2}' | awk -F '.' '{print $1}' | grep -v 'OtherComponent' | sort -u > ../statistic/$i.components; done
