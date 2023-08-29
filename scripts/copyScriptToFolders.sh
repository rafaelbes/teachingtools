#copy all scripts .sh to all subfolders
for dir in *; do [ -d "$dir" ] && cp *.sh "$dir" ; done
