#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dataset="dbpedia2015-04"
compression='bz2'
source "${ABSOLUTE_PATH}/${dataset}"

output="./${dataset}-out"
if [ ! -d $output ]; then
  mkdir -p $output
fi

for file in $files 
do
	if [ ! -f "${output}/${file}" ]; then
		if [ ! -f "${output}/${file}.${compression}" ]; then
			curl -o "${output}/${file}.${compression}"  -O "${url_prefix_path}/${file}.${compression}"
		fi
		bunzip2 "${output}/${file}.${compression}"
	fi
done

