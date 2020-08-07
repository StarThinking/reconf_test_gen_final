
# check return code
for i in *-component-meta.txt; do cat $i | tail -n 1; done | sort | uniq -c

hdfs:
6141/6441

hbase:
4900/4953

yarn:
4601/4760

mapreduce:
1409/1423

hadoop-tools:
1080/1263

# check test component register ratio
for i in $(find . -name ultimate); do echo $i; for j in $i/*; do if [ $(cat $j | wc -l) -ne 0 ]; then echo $j; fi; done | wc -l; ls $i | wc -l; done

hdfs:
5267/6441

hbase:
2039/4953

yarn:
1717/4760

mapreduce:
471/1423

hadoop-tools:
335/1263
