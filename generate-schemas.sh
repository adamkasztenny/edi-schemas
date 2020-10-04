#!/bin/bash

OUTPUT_ROOT="$(pwd)"
echo "Outputting to $OUTPUT_ROOT"

function convert() {
	edi=$1
	cd $edi
	for version in `ls`
	do
		output_directory="$OUTPUT_ROOT/$edi"

		for file in `ls $version/*`
		do
			output_file="$output_directory/$(echo $file | rev | cut -c4- | rev).json"
			mkdir -p "$(dirname $output_file)"
			echo "Writing to $output_file"

			if [[ $output_file == *"records"* ]]; then
				json_without_proper_quotes="{$(cat "$file" | sed '1,/recorddefs/d')"
			else
				json_without_proper_quotes="[$(cat "$file" | sed '1,/structure/d')"
			fi


			json_with_trailing_commas="$(echo "$json_without_proper_quotes" | sed "s/'/\"/g")"
			echo "var raw = $json_with_trailing_commas; console.log(JSON.stringify(raw));" > script.js
			as_valid_json=$(node script.js)

			echo "$as_valid_json" > "$output_file"
		done
	done
}

git clone https://github.com/bots-edi/bots-grammars
cd bots-grammars

convert "x12"
convert "edifact"

cd ..
rm -rf bots-grammars
