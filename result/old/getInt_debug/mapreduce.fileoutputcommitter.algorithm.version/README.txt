reconf_component mapreduce:ReduceTask
reconf_parameter mapreduce.fileoutputcommitter.algorithm.version
reconf_point -1
reconf_v1 2
reconf_v2 1
reconf_vvmode v1v2

mvn test -Dtest=org.apache.hadoop.mapred.lib.TestMultipleOutputs#testWithCounters

v1v1: 
msx-debug status.getPath().getName() = sequence_B-m-00001
msx-debug status.getPath().getName() = part-00000
msx-debug status.getPath().getName() = text-r-00000
msx-debug status.getPath().getName() = text-m-00001
msx-debug status.getPath().getName() = sequence_B-r-00000
msx-debug status.getPath().getName() = sequence_A-m-00001
msx-debug status.getPath().getName() = sequence_B-m-00000
msx-debug status.getPath().getName() = _SUCCESS
msx-debug status.getPath().getName() = text-m-00000
msx-debug status.getPath().getName() = sequence_A-m-00000
msx-debug status.getPath().getName() = sequence_C-r-00000

v2v2:
msx-debug status.getPath().getName() = sequence_B-m-00001
msx-debug status.getPath().getName() = part-00000
msx-debug status.getPath().getName() = text-r-00000
msx-debug status.getPath().getName() = text-m-00001
msx-debug status.getPath().getName() = sequence_B-r-00000
msx-debug status.getPath().getName() = sequence_A-m-00001
msx-debug status.getPath().getName() = sequence_B-m-00000
msx-debug status.getPath().getName() = _SUCCESS
msx-debug status.getPath().getName() = text-m-00000
msx-debug status.getPath().getName() = sequence_A-m-00000
msx-debug status.getPath().getName() = sequence_C-r-00000

v1v2:
msx-debug status.getPath().getName() = sequence_B-m-00001
msx-debug status.getPath().getName() = text-m-00001
msx-debug status.getPath().getName() = sequence_A-m-00001
msx-debug status.getPath().getName() = sequence_B-m-00000
msx-debug status.getPath().getName() = _SUCCESS
msx-debug status.getPath().getName() = text-m-00000
msx-debug status.getPath().getName() = sequence_A-m-00000
