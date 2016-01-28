#!/bin/bash

url_prefix='http://downloads.dbpedia.org/2015-04/'
url_prefix_path='http://downloads.dbpedia.org/2015-04/core-i18n/en/'
files="dbpedia_2015-04.nt instance-types_en.nt mappingbased-properties_en.nt labels_en.nt short-abstracts_en.nt article-categories_en.nt category-labels_en.nt skos-categories_en redirects_en.nt"
compression='bz2'

for file in $files 
do
	if [ ! -f "$file" ]; then
		if [ ! -f "$file.$compression" ]; then
			curl -C - -O "$url_prefix_path$file.$compression"
		fi
		bunzip2 "$file.$compression"
	fi
done

