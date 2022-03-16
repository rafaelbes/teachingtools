if [[ -z $1 ]]; then
	filename=$(ls -tp *.md | grep -v /$ | head -1)
else
	filename=$1.md
fi
pandoc $filename -o tmp.pdf
evince tmp.pdf
