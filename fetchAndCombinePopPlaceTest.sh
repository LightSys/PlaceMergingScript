#!/bin/bash
# Get the osm for populated places in Taiwan
# This could be done in one wget but seperate steps are nicer
wget -O cities.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="city"][~"^is_in"~"Taiwan$"];out;'
wget -O towns.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="town"][~"^is_in"~"Taiwan$"];out;'
wget -O villages.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="village"][~"^is_in"~"Taiwan$"];out;'
wget -O hamlets.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="hamlet"][~"^is_in"~"Taiwan$"];out;'
wget -O isolated.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="isolated_dewlling"][~"^is_in"~"Taiwan$"];out;'

# Merge the resulting files into one
chmod +x osmconvert64
./osmconvert64 cities.osm towns.osm villages.osm hamlets.osm isolated.osm -o=TaiwanOsm.osm
rm cities.osm towns.osm villages.osm hamlets.osm isolated.osm

# pull latest version of NGA country data
wget -r -l1 -A 'tw.zip' -nH --cut-dirs 3 'ftp://ftp.nga.mil/pub2/gns_data/' -O 'nga.zip'
# unzip it
unzip nga.zip
rm nga.zip
cp tw_populatedplaces_p.txt Countries_populatedplaces_p.txt
# convert it to OSM format; this script is configured to look for a file called Countries_populatedplaces_p.txt and output a file called nga.osm
perl gns2osm.pl
# delete remaining NGA data
rm *.txt

echo 'Merging into one file...'
# Combine the two data sources (no deduping or merging)
./osmconvert64 nga.osm TaiwanOsm.osm -o=PopPlacesTaiwan.osm 
rm TaiwanOsm.osm nga.osm
echo 'Done'
