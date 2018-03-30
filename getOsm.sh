#!/bin/bash
# Get the osm for populated places in the world
# This could be done in one wget but seperate steps are nicer
wget -O cities.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="city"];out;'
wget -O towns.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="town"];out;'
wget -O villages.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="village"];out;'
wget -O hamlets.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="hamlet"];out;'
wget -O isolated.osm 'http://overpass-api.de/api/interpreter?data=[timeout:3600];node[place="isolated_dewlling"];out;'

# Merge the resulting files into one
osmconvert cities.osm towns.osm villages.osm hamlets.osm isolated.osm -o=Israel.osm
rm cities.osm towns.osm villages.osm hamlets.osm isolated.osm
