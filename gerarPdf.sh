#!/bin/bash

#create a output folder, compile a .tex file using pdflatex and output as folder for temporary files
#and then open the pdf using evince

if [ -z "$1" ]; then
	echo "Missing argument. Dont use .tex extension. If the file is baseName.tex, use gerarPdf baseName"
else
	if [ ! -d output ]; then
		mkdir output
	fi
	filename=$1
	pdflatex -output-directory=./output/ $filename.tex
	evince ./output/$filename.pdf &
fi
