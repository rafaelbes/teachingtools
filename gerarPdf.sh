#!/bin/bash

#if it is a .tex file:
#	creates an output folder, compiles the .tex file using pdflatex and output as folder for temporary files
#	and then opens the pdf using evince
#if it is a .md file:
#	compiles it to pdf using pandoc using a small margin

if [ -z "$1" ]; then
	echo "Missing argument."
else
	ext="${1#*.}"
	if [[ "$ext" == "md" ]]; then
		read -p "Slides? (Y/y/any)" -n 1 -r </dev/tty
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			pandoc $1 -o ${1%.md}.pdf -t beamer --pdf-engine=xelatex
			evince ${1%.md}.pdf &
		else
			pandoc $1 -o ${1%.md}.pdf -V geometry:margin=1in
			evince ${1%.md}.pdf &
		fi
	else
		if [ ! -d output ]; then
			mkdir output
		fi
		filename=$1
		if [ -f $filename.tex ] ; then
			pdflatex -output-directory=./output/ $filename.tex
			evince ./output/$filename.pdf &
		else
			pdflatex -output-directory=./output/ $filename
			evince ./output/${filename%.tex}.pdf &
		fi
	fi
fi
