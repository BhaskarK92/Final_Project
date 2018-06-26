#!/bin/bash

batchid=`cat /home/acadgild/bhaskar/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/bhaskar/project/logs/log_batch_$batchid

echo "Creating hive tables on top of hbase tables for data enrichment and filtering..." >> $LOGFILE

hive -f /home/acadgild/bhaskar/project/create_hive_hbase_lookup.hql

