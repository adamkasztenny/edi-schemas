#!/bin/bash

set -e

json_files=$(find -name '*.json')

for json_file in $json_files
do
	echo "Verifying $json_file"
	cat $json_file | json_pp > /dev/null
done
