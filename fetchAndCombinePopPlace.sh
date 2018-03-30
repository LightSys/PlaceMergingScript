#!/bin/bash

## OPENSTREETMAP

# Get the osm for populated places in the world
# This could be done in one wget but seperate steps are nicer
wget -O cities.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="city"];out;'
wget -O towns.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="town"];out;'
wget -O villages.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="village"];out;'
wget -O hamlets.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="hamlet"];out;'
wget -O isolated.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="isolated_dewlling"];out;'

# Merge the resulting files into one
chmod +x osmconvert64
./osmconvert64 cities.osm towns.osm villages.osm hamlets.osm isolated.osm -o=PopPlacesOsm.osm
rm cities.osm towns.osm villages.osm hamlets.osm isolated.osm

## NGA
# pull latest version of NGA country data
wget -r -l1 -A 'geonames_fc_*.zip' -nH --cut-dirs 3 'ftp://ftp.nga.mil/pub2/gns_data/' -O 'nga.zip'
# unzip it
unzip nga.zip
rm nga.zip
# convert it to OSM format; this script is configured to look for a file called Countries_populatedplaces_p.txt and output a file called nga.osm
perl gns2osm.pl
# delete remaining NGA data
rm *.txt

## Add other data sources here...

# Combine the two data sources (no deduping or merging)
echo 'Merging into one file...'
./osmconvert64 nga.osm PopPlacesOsm.osm -o=PopPlaces.osm 
rm PopPlacesOsm.osm nga.osm
echo 'Done'
