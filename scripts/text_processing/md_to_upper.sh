#!/bin/bash

for file in *.md; do
	filename=$(basename -- "$file")
	name_only="${filename%.*}"
	git mv "$file" "$(echo "$name_only" | tr '[:lower:]' '[:upper:]').md"
done
