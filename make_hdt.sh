#!/bin/bash

#$1 dbpedia 
#$2 output folder

if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters"
  echo "Usage: make_hdt [dbpedia] [output-folder]"
  exit 1
fi

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${1}"

output_dir="${2}"
output_file="${dataset}"
if [ ! -d $output_dir ]; then
  echo "Creating $output_dir folder"
  mkdir -p $output_dir
fi

for file in $files 
do
  if [ ! -f "$output_dir/$file" ]; then
    if [ ! -f "$output_dir/$file.$compression" ]; then
      echo "Getting: ${url_prefix_path}/${file}.${compression}"
      curl -o "${output_dir}/${file}.${compression}"  -O "${url_prefix_path}/${file}.${compression}" --progress-bar
    fi
    bunzip2 "$output_dir/$file.$compression"
  fi
done

# Join into one file
if [ -f "$output_dir/$output_file.nt" ]; then
  echo "Removing previous output file"
  rm "$output_dir/$output_file.nt"
fi

echo "Merging files"
for file in $files
do
  echo "$file"
  cat $output_dir/$file >> $output_dir/$output_file".nt"
done

# use hdt
if [ ! -f "$output_dir/$output_file.hdt" ]; then
  echo "Removing previous hdt output file"
  rm "$output_dir/$output_file.hdt"
fi

echo "Transforming into hdt"

rdf2hdt -i -f ntriples "$output_dir/$output_file.nt" "$output_dir/$output_file.hdt"
