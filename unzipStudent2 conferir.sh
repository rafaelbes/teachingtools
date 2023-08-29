
rm output sumario.csv

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
	echo 'entrando em ' $j
	cd $j
	for f in *; do
		if [ -d "$f" ]; then
			echo "movendo conteúdo de $j para diretório superior"
			mv "$f"/* .
		fi
	done;
	cp ../lista3.sh .
	#echo -e "\n\n\n\n-----------------------------\n" $j >> sumario
	bash lista3.sh
	cd ..
}

for i in *.tar.gz; do
	j=$(echo $i|sed 's/[^A-Za-z]//g')
	if [ ! -d "$j" ]; then
		echo "descompactando " $i
		mkdir $j
		tar -xzvf "$i" -C $j > /dev/null
	fi
	avaliar $j
done;

for i in *.zip; do
	j=$(echo $i|sed 's/[^A-Za-z]//g')
	if [ ! -d "$j" ]; then
		echo "descompactando " $i
		mkdir $j
		unzip "$i" -d $j > /dev/null
	fi
	avaliar $j
done;

for i in *.rar; do
	j=$(echo $i|sed 's/[^A-Za-z]//g')
	if [ ! -d "$j" ]; then
		echo "descompactando " $i
		mkdir $j
		unrar-free "$i" "$j" > /dev/null
	fi
	avaliar $j
done;
