#!/bin/bash

#rename all subfolder to supress any number, underscore and space
for i in *; do 
	if [ -d "$i" ]; then
		 j=$(echo $i | sed 's/[0-9_ ]//g');
		 echo $i
		 echo $j
		 mv "$i" "$j" 
	fi
done

