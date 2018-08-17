shopt -s nullglob

if whiptail --yesno "Gostaria de apagar os diretórios existentes?" 25 40; then
	for i in *; do
		if [ -d "$i" ]; then
			rm "$i" -rf
		fi
	done;
fi

if whiptail --yesno "Criar um diretorio para cada questao?" 25 40; then
	qtd=$(whiptail --inputbox "Quantas questoes? (ex.: 10, 11)" 8 78 4 3>&1 1>&2 2>&3)
	for i in $(seq 1 $qtd); do
		mkdir q$i 2> /dev/null
	done;
fi

copiarQuestoes=$(whiptail --yesno "Copiar codigos para diretorios de questoes?" 25 40 3>&1 1>&2 2>&3; echo $?)
nomeScript=$(whiptail --inputbox "Nome do script" 8 78 corrigir.sh 3>&1 1>&2 2>&3)
executarScript=$(whiptail --yesno "Executar script?" 25 40 3>&1 1>&2 2>&3; echo $?)

echo $copiarQuestoes
echo $nomeScript
echo $qtd

avaliar () {
	j=$1
	cd $j
	for f in *; do
		if [ -d "$f" ]; then
			mv "$f"/* .
		fi
	done;
	cp $nomeScript $j 2> /dev/null
	if [ "$executarScript" -eq "0" ]; then
		bash $nomeScript
	fi
	if [ "$copiarQuestoes" -eq "0" ]; then
		for k in $(seq 1 $qtd); do
			cp q$k.c ../q$k/$j.c 2> /dev/null
		done
	fi
	cd ..
}

for i in *.tar.gz; do
	j=a$(echo $i|sed 's/[^A-Za-z]//g' | perl -ne 'print lc')
	if [ ! -d "$j" ]; then
		mkdir $j
		tar -xzvf "$i" -C $j > /dev/null
	fi
	avaliar $j
done;

for i in *.zip; do
	j=a$(echo $i|sed 's/[^A-Za-z]//g' | perl -ne 'print lc')
	if [ ! -d "$j" ]; then
		mkdir $j
		unzip "$i" -d $j > /dev/null
	fi
	avaliar $j
done;

for i in *.rar; do
	j=a$(echo $i|sed 's/[^A-Za-z]//g' | perl -ne 'print lc')
	if [ ! -d "$j" ]; then
		mkdir $j
		unrar-free "$i" "$j" > /dev/null
	fi
	avaliar $j
done;
