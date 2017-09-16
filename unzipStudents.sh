#!/bin/bash

#this script unzip all zip files inside current directory to a folder with same name (only letters)
#copy the script corrigir.sh (please modify if it is another one) to each folder
#and move all files inside a folder inside zip file to its parent

rm output

if whiptail --yesno "Gostaria de apagar os diretórios existentes?" 25 40; then
	for i in *; do
		if [ -d "$i" ]; then
			echo "apagando " $i
			rm "$i" -rf
		fi
	done;
fi

avaliar () {
	j=$1
	#change this file if needed
	cp corrigir.sh $j
	echo 'entrando em ' $j
	cd $j
	for f in *; do
		if [ -d "$f" ]; then
			echo "movendo conteúdo de $j para diretório superior"
			mv "$f"/* .
		fi
	done;
	#uncomment if youd like to apply the script, read for pause between each one
	#bash corrigir.sh
	#read
	cd ..
}


for i in *.zip; do
	j=$(echo $i|sed 's/[^A-Za-z]//g')
	if [ ! -d "$j" ]; then
		echo "descompactando " $i
		mkdir $j
		unzip "$i" -d $j > /dev/null
	fi
	avaliar $j
done;

