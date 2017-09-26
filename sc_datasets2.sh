#!/bin/bash
# Usage: Add Smart Columbus tags to harvested datasets.
# Author: Richard Jones
# jq sudo apt-get install jq is required for this script
#Input File - Add dataset names to this file
input="/usr/lib/ckan/default/src/ckan/sc_datasets.txt"
#Actions
printf "%s\n" "datasets that will be tagged"
while IFS='' read -r line || [[ -n "$line" ]];
do
        ckanapi action package_show -r http://catalog.smartcolumbuside.com id="$line" \
	| jq '.result' \
	| jq -r '.tags |= .+[{"name":"Smart_Columbus"}]' > package_update.json
	ckanapi action package_update -I package_update.json -c /etc/ckan/default/production.ini
	#
	#works but doesnt update, only removes
	#ckanapi action package_update -r http://catalog.smartcolumbuside.com -a f722e07d-2efd-46a2-93cd-a1fba54314a9 id="$line" "tags":'[{"name":"SC_TEST"}]'
	#
	#working basic example
	#ckanapi action package_show -r http://catalog.smartcolumbuside.com id="$line" \
  	#| jq '.result' \
	#| jq '.+{"title":"New title"}' > testing_bash.txt
	#ckanapi action package_update -I testing_bash.txt -c /etc/ckan/default/production.ini 
done <"$input"
