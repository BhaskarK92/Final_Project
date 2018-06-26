# Music Data Analysis Project !!!
echo "Preparing to execute python scripts to generate data..."

rm -r /home/acadgild/bhaskar/project/data/web

rm -r /home/acadgild/bhaskar/project/data/mob

mkdir -p /home/acadgild/bhaskar/project/data/web

mkdir -p /home/acadgild/bhaskar/project/data/mob

python /home/acadgild/bhaskar/project/generate_web_data.py
python /home/acadgild/bhaskar/project/generate_mob_data.py

echo "Mobile and Web Data generated Successfully !"

#Call  start-daemon script to start hadoop,hive and MySQL daemons

echo "Starting the daemons...."
sh start-daemons.sh

#Run jps command to confirm all the daemons

jps
echo "All hadoop daemons started....."

echo "Upload the look up tables now in Hbase..."
sh populate-lookup.sh

echo "Done with data population in hbase lookup tables..."

echo "Creating hive tables on top of hbase tables for data enrichment and filtering..."
sh data_enrichment_filtering_schema.sh

echo "Hive table with Hbase Mapping Complete..."

echo "Start the data formatting...."
sh dataformatting.sh

echo "data formatting complete..."

echo "Start data enrichment as per the requirement..."
sh data_enrichment.sh

echo "Data Enrichment Complete..."

echo "Run Data Analysis script for some use cases..."
sh data_analysis.sh

echo "Run export command to transfer table to mysql..."
sh data_export_toMySQL.sh

echo "Table export part complete..."

echo "First Batch Complete Successfully!!"
