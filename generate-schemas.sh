#!/bin/bash

OUTPUT_ROOT="$(pwd)"
echo "Outputting to $OUTPUT_ROOT"

function convert_file() {
	input_file=$1
	output_file=$2

	mkdir -p "$(dirname $output_file)"
	echo "Writing to $output_file"

	input_file_without_comments=$(cat "$input_file" | sed '/^\s*#/d')
	input_file_without_python_none=$(echo "$input_file_without_comments" | sed 's/None/null/g')

	if [[ $output_file == *"records"* ]]; then
		json_without_proper_quotes="{$(echo "$input_file_without_python_none" | sed '1,/recorddefs/d')"
	else
		json_without_proper_quotes="[$(echo "$input_file_without_python_none" | sed '1,/structure/d')"
	fi


	json_with_trailing_commas="$(echo "$json_without_proper_quotes" | sed "s/'/\"/g")"
	echo "var raw = $json_with_trailing_commas; console.log(JSON.stringify(raw));" > script.js
	as_valid_json=$(node script.js)

	echo "$as_valid_json" > "$output_file"
}

function convert() {
	edi=$1
	cd $edi

	for version in `ls`
	do
		output_directory="$OUTPUT_ROOT/$edi"

		for file in `ls $version/*`
		do
			output_file="$output_directory/$(echo $file | rev | cut -c4- | rev).json"
			convert_file "$file" "$output_file"
		done
	done

	cd ..
}

function close_python_list_and_dictionary() {
	file=$1
	echo "]}]" >> $file
}

function fix_irregular_data() {
	rm "./x12/5011/X12.Segment"
	close_python_list_and_dictionary "./x12/3040/272003040.py"
	close_python_list_and_dictionary "./x12/3040/837003040.py"
	close_python_list_and_dictionary "./x12/3050/837003050.py"
	close_python_list_and_dictionary "./x12/3050/404003050.py"
	close_python_list_and_dictionary "./x12/3050/417003050.py"
}

git clone https://github.com/bots-edi/bots-grammars
cd bots-grammars

fix_irregular_data

convert "x12"
convert "edifact"

convert_file "edifact/envelope.py" "$OUTPUT_ROOT/edifact/envelope.json"

cd ..
rm -rf bots-grammars
