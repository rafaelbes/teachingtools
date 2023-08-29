#!/bin/bash
#this script removes all temporary files created by latex
#ask about removing all files that are not in a tex file
#this is useful to erase all not related file inside this folder

rm *.snm *.toc *.aux *.nav *.out *.log 2> /dev/null
total1=$(du -s . | grep "[0-9]*" -o)
for f in $(ls -I "*.tex" -I "*.sh" -I "*.cls" 2> /dev/null);
do
	if [ -f $f ] && ! grep --quiet $f *.tex -c; then
		if whiptail --yesno "Would you like to erase $f?\n$(head $f -c 400)" 25 100; then
			rm $f
		fi
	fi
done
total2=$(du -s . | grep "[0-9]*" -o)
whiptail --msgbox "Total size reduction: $total1 KB to $total2 KB" 7 100
