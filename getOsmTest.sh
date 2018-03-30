#!/bin/bash
# Get the osm for populated places in Israel
# This could be done in one wget but seperate steps are nicer
wget -O cities.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="city"][~"^is_in"~"Israel$"];out;'
wget -O towns.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="town"][~"^is_in"~"Israel$"];out;'
wget -O villages.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="village"][~"^is_in"~"Israel$"];out;'
wget -O hamlets.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="hamlet"][~"^is_in"~"Israel$"];out;'
wget -O isolated.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="isolated_dewlling"][~"^is_in"~"Israel$"];out;'

# Merge the resulting files into one
chmod +x osmconvert64
echo 'Merging into one file...'
./osmconvert64 cities.osm towns.osm villages.osm hamlets.osm isolated.osm -o=Israel.osm
rm cities.osm towns.osm villages.osm hamlets.osm isolated.osm
echo 'Done'
