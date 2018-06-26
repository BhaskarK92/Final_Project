#!/bin/bash

batchid=`cat /home/acadgild/bhaskar/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/bhaskar/project/logs/log_batch_$batchid

echo "Creating mysql tables if not present..." >> $LOGFILE

mysql -u root -p  < /home/acadgild/bhaskar/project/create_schema.sql

echo "Running sqoop job for data export...." >> $LOGFILE

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--password-file file:///home/acadgild/bhaskar/project/mysql_password \
--table top_10_stations \
--export-dir /user/hive/warehouse/project.db/top_10_stations/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--password-file file:///home/acadgild/bhaskar/project/mysql_password \
--table users_behaviour \
--export-dir /user/hive/warehouse/project.db/users_behaviour/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--password-file file:///home/acadgild/bhaskar/project/mysql_password \
--table connected_artists \
--export-dir /user/hive/warehouse/project.db/connected_artists/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--password-file file:///home/acadgild/bhaskar/project/mysql_password \
--table top_10_royalty_songs \
--export-dir /user/hive/warehouse/project.db/top_10_royalty_songs/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--password-file file:///home/acadgild/bhaskar/project/mysql_password \
--table top_10_unsubscribed_users \
--export-dir /user/hive/warehouse/project.db/top_10_unsubscribed_users/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1

echo "Incrementing batchid..." >> $LOGFILE
batchid=`expr $batchid + 1`
echo -n $batchid > /home/acadgild/bhaskar/project/logs/current-batch.txt
