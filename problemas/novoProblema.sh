filename=$(tr -dc A-Z </dev/urandom | head -c 5 ; echo '')
if [ ! -f $filename.md ]; then
	xsel -ob > $filename.md
	echo $filename.md created
	cat $filename.md
fi
