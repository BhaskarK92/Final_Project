#!/bin/bash

batchid=`cat /home/acadgild/bhaskar/project/logs/current-batch.txt`

LOGFILE=/home/acadgild/bhaskar/project/logs/log_batch_$batchid

echo "Creating LookUp Tables in Hbase..." >> $LOGFILE

echo "disable 'station-geo-map'" | hbase shell
echo "drop 'station-geo-map'" | hbase shell
echo "disable 'subscribed-users'" | hbase shell
echo "drop 'subscribed-users'" | hbase shell
echo "disable 'song-artist-map'" | hbase shell
echo "drop 'song-artist-map'" | hbase shell
echo "disable 'user-artist-map'" | hbase shell
echo "drop 'user-artist-map'" | hbase shell


echo "create 'station-geo-map', 'geo'" | hbase shell
echo "create 'subscribed-users', 'subscn'" | hbase shell
echo "create 'song-artist-map', 'artist'" | hbase shell
echo "create 'user-artist-map', 'artists'" | hbase shell


echo "Populating LookUp Tables..." >> $LOGFILE

file="/home/acadgild/bhaskar/project/lookupfiles/stn-geocd.txt"
while IFS= read -r line
do
 stnid=`echo $line | cut -d',' -f1`
 geocd=`echo $line | cut -d',' -f2`
 echo "put 'station-geo-map', '$stnid', 'geo:geo_cd', '$geocd'" | hbase shell
done <"$file"


file="/home/acadgild/bhaskar/project/lookupfiles/song-artist.txt"
while IFS= read -r line
do
 songid=`echo $line | cut -d',' -f1`
 artistid=`echo $line | cut -d',' -f2`
 echo "put 'song-artist-map', '$songid', 'artist:artistid', '$artistid'" | hbase shell
done <"$file"


file="/home/acadgild/bhaskar/project/lookupfiles/user-subscn.txt"
while IFS= read -r line
do
 userid=`echo $line | cut -d',' -f1`
 startdt=`echo $line | cut -d',' -f2`
 enddt=`echo $line | cut -d',' -f3`
 echo "put 'subscribed-users', '$userid', 'subscn:startdt', '$startdt'" | hbase shell
 echo "put 'subscribed-users', '$userid', 'subscn:enddt', '$enddt'" | hbase shell
done <"$file"


cp /home/acadgild/bhaskar/project/lookupfiles/user-artist.txt /home/acadgild/bhaskar/project/lookupfiles/user-artist1.txt

awk '$1=$1' FS="&" OFS=" " /home/acadgild/bhaskar/project/lookupfiles/user-artist1.txt > /home/acadgild/bhaskar/project/lookupfiles/user-artist.txt

file="/home/acadgild/bhaskar/project/lookupfiles/user-artist.txt"

num=1
while IFS= read -r line
do
 userid=`echo $line | cut -d',' -f1`
 artists=`echo $line | cut -d',' -f2`
for row in $artists
 do
echo "put 'user-artist-map', '$userid', 'artists:artist$num', '$row'" | hbase shell
let "num=num+1"
done
num=1
done <"$file" 
