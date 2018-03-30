#!/bin/bash
# pull latest version of NGA country data
wget -r -l1 -A 'geonames_fc_*.zip' -nH --cut-dirs 3 'ftp://ftp.nga.mil/pub2/gns_data/' -O 'nga.zip'
# unzip it
unzip nga.zip
rm nga.zip
# convert it to OSM format; this script is configured to look for a file called Countries_populatedplaces_p.txt and output a file called nga.osm
perl gns2osm.pl
# delete remaining NGA data
rm *.txt
