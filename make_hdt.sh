#!/bin/bash

source $HOME/root/env/c++/hdt

url_prefix='http://downloads.dbpedia.org/2015-04/'
url_prefix_path='http://downloads.dbpedia.org/2015-04/core-i18n/en/'
base_files="dbpedia_2015-04.nt"
extra_files="instance-types_en.nt mappingbased-properties_en.nt labels_en.nt short-abstracts_en.nt article-categories_en.nt category-labels_en.nt skos-categories_en.nt redirects_en.nt"
compression='bz2'
output_dir='output'
output_file='dbpedia'

if [ ! -d $output_dir ]; then
	echo "Creating $output_dir folder"
	mkdir -p $output_dir
fi

for file in $extra_files 
do
	if [ ! -f "$output_dir/$file" ]; then
		if [ ! -f "$output_dir/$file.$compression" ]; then
			echo "Downloading $file"
			curl --silent --progress-bar -o "$output_dir/$file.$compression" -C - "$url_prefix_path$file.$compression"
		fi
		echo "Unzipping"
		bunzip2 "$output_dir/$file.$compression"
	fi
done

# Join into one file
if [ -f "$output_dir/$output_file.nt" ]; then
  echo "Removing previous output file"
  rm "$output_dir/$output_file.nt"
fi

echo "Merging files"
for file in $extra_files
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
