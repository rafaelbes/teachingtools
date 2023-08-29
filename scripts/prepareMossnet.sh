#!/bin/bash

#use prepareMossnet.sh 3 for 3 questions
#this script copy each NAME/qx.c to qx/NAME.c

for i in $(seq 1 $1); do
	find -iname q$i.c -print0 | while read -d $'\0' file
	do
		name=$(echo $file | awk -F "/" '{print $2}')
		echo "Copying" $file to q$i/$name.c
		cp "$file" q$i/$name.c
	done
done
