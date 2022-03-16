#Este script junta vários problemas em um único arquivo markdown e um único arquivo de execução de testes.
#Passe como argumento o identificador de cada problema. Exemplo: XYZ
#O script cria um diretório output. Caso exista, o script encerra.
#O script cria um novo script.sh e problemas.md em output/. O primeiro conterá chamadas de teste e o segundo conterá a descrição de todos os problemas
#Se houver um arquivo XYZ.in, adiciona no script a chamada de teste
#Se houver um arquivo XYZ.c, copia para output/
#Se houver um arquivo XYZ.md, adiciona-o em output/problemas.md

vermelho='\033[0;31m'

if [ -d output/ ]; then
	echo "Já existe um diretório output/. Abortando."
	exit 1
else
	mkdir output/
	touch output/script.sh
	touch output/problemas.md
fi

i=1

for cod in "$@"
do
	echo $cod

	if [ -f $cod.in ]; then
		while read -r p; do
			echo -E "avaliar 'q$i' " $p >> output/script.sh
		done <$cod.in
		echo "" >> output/script.sh
	fi

	if [ -f $cod.c ]; then
		cp $cod.c output/q$i.c
	fi

	if [ -f $cod.md ]; then
		cat $cod.md >> output/problemas.md
		echo "" >> output/problemas.md
	fi

	i=$((i+1))
done

sed '/^<!/d' output/problemas.md -i
