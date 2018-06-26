#!/bin/bash

batchid=`cat /home/acadgild/bhaskar/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/bhaskar/project/logs/log_batch_$batchid


echo "Running script for data formatting..." >> $LOGFILE

spark-submit --packages com.databricks:spark-xml_2.10:0.4.1 \
--class DataFormatting \
--master local[2] \
/home/acadgild/bhaskar/project/MusicDataAnalysis/target/scala-2.11/musicdataanalysis_2.11-1.0.jar $batchid
