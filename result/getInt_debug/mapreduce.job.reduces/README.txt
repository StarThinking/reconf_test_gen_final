reconf_component mapreduce:MapTask
reconf_parameter mapreduce.job.reduces
reconf_point -3
reconf_v1 8
reconf_v2 1
reconf_vvmode v1v2

mvn test -Dtest=org.apache.hadoop.fs.TestDFSIO#testRead

ISSUE LOG:
2020-07-30 02:38:05,546 WARN  [Thread-142] mapred.LocalJobRunner (LocalJobRunner.java:run(590)) - job_local535259955_0001
java.lang.Exception: org.apache.hadoop.mapreduce.task.reduce.Shuffle$ShuffleError: error in shuffle in localfetcher#2
        at org.apache.hadoop.mapred.LocalJobRunner$Job.runTasks(LocalJobRunner.java:492)
        at org.apache.hadoop.mapred.LocalJobRunner$Job.run(LocalJobRunner.java:559)
Caused by: org.apache.hadoop.mapreduce.task.reduce.Shuffle$ShuffleError: error in shuffle in localfetcher#2
        at org.apache.hadoop.mapreduce.task.reduce.Shuffle.run(Shuffle.java:136)
        at org.apache.hadoop.mapred.ReduceTask.run(ReduceTask.java:380)
        at org.apache.hadoop.mapred.LocalJobRunner$Job$ReduceTaskRunnable.run(LocalJobRunner.java:347)
        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.IndexOutOfBoundsException
        at java.nio.Buffer.checkIndex(Buffer.java:540)
        at java.nio.ByteBufferAsLongBufferB.get(ByteBufferAsLongBufferB.java:115)
        at org.apache.hadoop.mapred.SpillRecord.getIndex(SpillRecord.java:108)
        at org.apache.hadoop.mapreduce.task.reduce.LocalFetcher.copyMapOutput(LocalFetcher.java:126)
        at org.apache.hadoop.mapreduce.task.reduce.LocalFetcher.doCopy(LocalFetcher.java:103)
        at org.apache.hadoop.mapreduce.task.reduce.LocalFetcher.run(LocalFetcher.java:86)


