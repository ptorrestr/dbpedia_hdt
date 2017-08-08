#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dataset="dbpedia2014"
source "${ABSOLUTE_PATH}/${dataset}"

output="./${dataset}-out"
if [ ! -d $output ]; then
  mkdir -p $output
fi

for file in $files 
do
	if [ ! -f "${output}/${file}" ]; then
		if [ ! -f "${output}/${file}.${compression}" ]; then
      echo "Getting: ${url_prefix_path}/${file}.${compression}"
			curl -o "${output}/${file}.${compression}"  -O "${url_prefix_path}/${file}.${compression}" --progress-bar
		fi
		bunzip2 "${output}/${file}.${compression}"
	fi
done

