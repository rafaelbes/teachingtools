#!/bin/bash

declare -A numTesteAtual
declare -A statusQuestao

#bg: 40 a 47, 100 a 107
#0;fg;bg
vermelho='\033[0;31m'
verde='\033[0;32m'
normal='\033[0m'
azul='\033[0;36m'
corProblema='\033[1;97;44m'

args=("$@")
ls $1
avaliar () {
	file=${args[0]}$1
	if ! [ -n "${numTesteAtual[$1]}" ]; then
		echo -e "${corProblema}              problema $1            ${normal}"
	fi
	numTesteAtual[$1]=$((numTesteAtual[$1]+1))
	if [ -f $file.c ]; then
		if [ ! -f exec$1 ]; then
			arq=$file.c
			if command -v file &> /dev/null && command -v iconv &> /dev/null; then
				charset="$(file -bi "$file.c" | awk -F "=" '{print $2}')"
				if [ "$charset" != utf-8 ]; then
					iconv -f "$charset" -t utf8 "$file.c" -o tmp.c
					arq=tmp.c
				fi
			fi
			if ! gcc "$arq" -o exec$1 -lm  2> /dev/null; then
				if ! [ -n "${statusQuestao[$1]}" ]; then
					statusQuestao[$1]='código '$file.c' não compila'
					echo -e "${vermelho} ${statusQuestao[$1]} ${normal}"
				fi
			fi
		fi
		echo -e "$2" > input
		echo -e "$3" > gabarito
		if [ -f exec$1 ]; then
			timeout 2 ./exec$1 < input > output
			printf 'Teste %d: ' ${numTesteAtual[$1]}
			if ! diff -wB output gabarito > /dev/null; then
				echo -e "${vermelho} [x]${normal}"
				echo -e '\tEntrada:' "${azul} $2 ${normal}"
				echo -e '\tSaída do seu programa:' "${azul} $(cat output) ${normal}"
				echo -e '\tSaída esperada       :' "${azul} $3 ${normal}"
			else
				echo -e "${verde} [ok] ${normal}"
			fi
		fi
	else
		if ! [ -n "${statusQuestao[$1]}" ]; then
			statusQuestao[$1]='código '$file.c' não existe'
			echo -e "${vermelho} ${statusQuestao[$1]} ${normal}"
		fi
	fi
}

if [ -e tmp.c ]; then echo "Existe um diretório/arquivo tmp.c, abortando"; exit 1; fi
if [ -e gabarito ]; then echo "Existe um diretório/arquivo gabarito, abortando"; exit 1; fi
if [ -e input ]; then echo "Existe um diretório/arquivo input, abortando"; exit 1; fi
if [ -e output ]; then echo "Existe um diretório/arquivo output, abortando"; exit 1; fi

avaliar 'q5' '68 48 74 71 39 72 57 60 62 58 100 67 16 75 39 64 73 5 5 37' '100 5 54.50'
avaliar 'q5' '45 66 78 67 74 42 62 23 24 89 20 23 72 41 67 54 31 62 8 44' '89 8 49.60'
avaliar 'q5' '54 62 71 40 52 45 28 21 53 39 82 34 23 51 14 76 22 41 48 71' '82 14 46.35'
avaliar 'q5' '67 44 37 92 26 5 36 10 63 10 16 62 11 44 36 35 43 68 54 14' '92 5 38.65'
avaliar 'q5' '76 41 46 59 61 57 22 29 44 24 74 78 77 23 46 45 32 57 22 54' '78 22 48.35'
avaliar 'q5' '62 71 100 80 45 63 66 43 60 67 16 30 26 36 72 43 53 39 60 64' '100 16 54.80'
avaliar 'q5' '50 21 33 5 82 73 67 62 41 61 47 57 64 33 57 64 59 64 60 19' '82 5 50.95'
avaliar 'q5' '70 71 67 51 49 61 69 55 5 69 63 66 100 56 41 31 58 54 74 49' '100 5 57.95'
avaliar 'q5' '34 74 65 42 62 38 34 53 36 64 52 29 43 41 52 36 6 48 60 68' '74 6 46.85'
avaliar 'q5' '20 81 48 61 5 36 58 70 62 38 77 47 54 67 33 29 78 77 26 86' '86 5 52.65'

avaliar 'q9' '30 20 8' '3'
avaliar 'q9' '60.0 40.0 11' '4'
avaliar 'q9' '100.0 95.0 7.0' '7'
avaliar 'q9' '10 10 10' '1'
avaliar 'q9' '10 10 15' '0'

avaliar 'q13' '47' '19'
avaliar 'q13' '18' 'impossível'
avaliar 'q13' '37' '12'
avaliar 'q13' '11' '4'
avaliar 'q13' '90' 'impossível'
avaliar 'q13' '1' '1'
avaliar 'q13' '2' 'impossível'
avaliar 'q13' '27' '10'
avaliar 'q13' '75' '7'
avaliar 'q13' '191' '52'
avaliar 'q13' '4409' '770'
avaliar 'q13' '4873' '1852'
avaliar 'q13' '8581' '2828'
avaliar 'q13' '9859' '4817'

rm tmp.c gabarito input output exec* 2> /dev/null
