#!/bin/bash
#Author: Rafael Beserra Gomes (rafaelufrn@gmail.com)

#Instructions
#For student: put this script at your source file folder and run as bash corretor.sh
#For professor: use avaliar function for each question avaliar $1 $2 $3
#	where 	$1: the question ID (usually q1, q2, q3)
#			$2:	the input
#			$3: the expected output (use \n as newline)

declare -A sumarioAcertos
declare -A sumarioTotal
declare -A sumarioStatus
vermelho='\033[0;31m'
verde='\033[0;32m'
normal='\033[0m'
azul='\033[0;36m'
amarelo='\033[44m'

avaliar () {
	file=$1
	if ! [ -n "${sumarioTotal[$1]}" ]; then
		echo -e "${amarelo}              problema $1            ${normal}"
	fi
	sumarioTotal[$1]=$((sumarioTotal[$1]+1))
	if ! [ -n "${sumarioAcertos[$1]}" ]; then
		sumarioAcertos[$1]=0
	fi
	if [ -f $file.c ]; then
		charset="$(file -bi "$file.c" | awk -F "=" '{print $2}')"
		if [ "$charset" != utf-8 ]; then
			iconv -f "$charset" -t utf8 "$file.c" -o tmp.c
			mv tmp.c "$file.c"
		fi
		if gcc $file.c -lm -fsanitize=bounds 2> /dev/null; then
			echo -e "$2" > input
			echo -e "$3" > gabarito
			timeout 2 ./a.out < input > output
			printf 'Teste %d: ' ${sumarioTotal[$1]}
			if ! diff -wB output gabarito > /dev/null; then
				echo -e "${vermelho} [x]${normal}"
				echo -e '\tEntrada:' "${azul} $2 ${normal}"
				echo -e '\tSaída do seu programa:' "${azul} $(cat output) ${normal}"
				echo -e '\tSaída esperada:' "${azul} $3 ${normal}"
			else
				echo -e "${verde} [ok] ${normal}"
				sumarioAcertos[$1]=$((sumarioAcertos[$1]+1))
			fi
		else
			sumarioStatus[$1]='código '$file.c' não compila'
		fi
	else
		sumarioStatus[$1]='código '$file.c' não existe'
	fi
}

avaliar 'q1' '7 \n ...........*.. \n .**.**.*.*...* \n .....*......*. \n .............. \n *.*..**....*.* \n ......*..*.... \n **..*..*.**.*. \n 1 1' 'bum!'
avaliar 'q1' '15 \n .*.*** \n **..*. \n ..*... \n ...*** \n *.*..* \n ...... \n *..**. \n .*..*. \n .*.... \n .***.* \n ...... \n ..**.. \n ...... \n *..... \n .....* \n 4 4' '4'
avaliar 'q1' ' 11 \n *.*.*..**.* \n *.*........ \n *..**.***** \n .******..*. \n ........... \n .*.*..*.**. \n .*.*.....** \n .*..**.**** \n ........... \n .***.***..* \n ......*.... \n 2 8' 'bum!'
avaliar 'q1' ' 12 \n ....*...*..........* \n ***....*.*.*..**.*.. \n *....*......*.*..... \n .**...***.*.***.*... \n *.*.**..*.*..***...* \n *.*.*.*..**..****..* \n *.**.**.*...**.***.* \n .*........*.*..*.**. \n *.**...*.**.**.**.** \n *****.*...**..***.*. \n *.*....**.*******... \n .***.**.*.*....**..* \n 3 15 ' '5'
avaliar 'q1' ' 18 \n .........**. \n ............ \n ..........** \n *****....*.. \n ****.***.*.. \n ...**.**..** \n .***.*...... \n *....**..... \n ...*....*.** \n *****.**.*.. \n .*...*****.. \n ..**........ \n *..*****...* \n .**.***.**.* \n *.*.**.*.*** \n .*.*....*.** \n ....*....... \n ...***....*. \n 15 7 ' '2'
avaliar 'q1' ' 8 \n **.***...*.*.*.* \n .*.*.*..*..**... \n ................ \n ...*...****.*..* \n .*....***.*..*** \n *...*.*...**.... \n ****....**..**.. \n ................ \n 4 7 ' 'bum!'
avaliar 'q1' ' 16 \n .... \n ...* \n .... \n .... \n *.*. \n **.* \n **** \n ...* \n ..*. \n *.*. \n *.*. \n .*.. \n ..** \n .*.. \n *..* \n ..** \n 13 2 ' '4'
avaliar 'q1' ' 15 \n .*.**.*. \n ...**... \n **..**** \n ........ \n ...*.*.* \n ....*... \n ..*...** \n **..**.. \n *.**..** \n ..*.*... \n *..*.... \n ........ \n ........ \n **...... \n .*...... \n 5 1 ' '1'
avaliar 'q1' ' 9 \n ....*..*.* \n *......*.. \n ..*..***.. \n ......**.. \n **.*....** \n .....**... \n **.**.*... \n .....*.... \n ..*....... \n 7 3 ' '3'
avaliar 'q1' ' 19 \n .*...*.**.*......* \n .*.......*.....*.. \n ....*......*...... \n .*..***..*..*.*..* \n ......*........**. \n *.*.*...**..**..** \n **...***.*.*.*...* \n *....**.*.**..*..* \n *.............*... \n .................. \n ..*....*..**...*** \n ...*.*..*.***.**.* \n ....*.*.*****...*. \n *****.***...*....* \n **.**......*.*.... \n .*****.*.*.......* \n .**.....****...**. \n *.......*.....**.. \n .*...........*.... \n 7 11 ' 'bum!'
avaliar 'q1' ' 20 \n ............. \n **....**..*.. \n ..*.......... \n *.*....***..* \n *.......*..*. \n ..**..**.**** \n ..*.*.*.*.... \n *.*..*.*....* \n *.*......*... \n .*.*.....**.. \n *.*.***.**.*. \n **.**.*.*..*. \n ....*...*.... \n *.***..*..*.. \n .*.*.***..*.. \n *...**..***.. \n *.*....*.**.* \n .**.**...***. \n .**..*.*..*.* \n ....*.....*.. \n 5 8 ' '4'

avaliar 'q2' ' 14 4 \n 6 5 3 0  \n 9 4 3 4  \n 5 7 2 9  \n 1 7 0 3  \n 1 6 3 6  \n 9 5 0 4  \n 2 1 1 1  \n 0 4 4 0  \n 1 0 2 6  \n 6 2 2 5  \n 0 1 0 1  \n 1 3 3 9  \n 1 3 6 8  \n 6 8 4 4  \n ' ' 6 9 5 1 1 9 2 0 1 6 0 1 1 6 \n 5 4 7 7 6 5 1 4 0 2 1 3 3 8 \n 3 3 2 0 3 0 1 4 2 2 0 3 6 4 \n 0 4 9 3 6 4 1 0 6 5 1 9 8 4 \n '
avaliar 'q2' ' 12 11 \n 0 0 3 5 4 8 9 8 6 1 9  \n 9 8 9 2 2 6 4 6 3 6 6  \n 2 1 0 0 0 2 2 4 3 1 6  \n 1 2 5 0 9 7 1 3 4 4 5  \n 0 3 1 6 6 6 3 4 3 6 0  \n 5 4 8 0 8 8 3 6 4 1 4  \n 7 0 5 5 7 6 4 2 8 3 4  \n 8 9 5 5 8 5 4 7 5 9 0  \n 4 2 4 6 1 2 5 8 7 7 3  \n 3 0 8 1 6 9 1 6 9 4 7  \n 2 5 9 4 1 1 0 5 5 3 6  \n 1 2 3 8 0 5 5 1 7 3 2  \n ' ' 0 9 2 1 0 5 7 8 4 3 2 1 \n 0 8 1 2 3 4 0 9 2 0 5 2 \n 3 9 0 5 1 8 5 5 4 8 9 3 \n 5 2 0 0 6 0 5 5 6 1 4 8 \n 4 2 0 9 6 8 7 8 1 6 1 0 \n 8 6 2 7 6 8 6 5 2 9 1 5 \n 9 4 2 1 3 3 4 4 5 1 0 5 \n 8 6 4 3 4 6 2 7 8 6 5 1 \n 6 3 3 4 3 4 8 5 7 9 5 7 \n 1 6 1 4 6 1 3 9 7 4 3 3 \n 9 6 6 5 0 4 4 0 3 7 6 2 \n '
avaliar 'q2' ' 14 8 \n 5 2 6 5 5 7 8 5  \n 0 0 3 9 1 9 6 3  \n 4 4 2 3 5 3 5 2  \n 0 5 0 9 5 9 0 1  \n 9 7 9 1 3 9 3 9  \n 5 6 4 0 4 0 3 5  \n 0 9 5 2 4 0 0 0  \n 1 8 6 1 1 6 7 0  \n 2 5 3 3 6 4 0 5  \n 7 5 2 7 1 1 7 6  \n 0 3 5 3 0 6 0 3  \n 2 0 7 2 0 2 2 1  \n 3 0 0 3 9 4 1 1  \n 3 9 0 1 1 1 1 8  \n ' ' 5 0 4 0 9 5 0 1 2 7 0 2 3 3 \n 2 0 4 5 7 6 9 8 5 5 3 0 0 9 \n 6 3 2 0 9 4 5 6 3 2 5 7 0 0 \n 5 9 3 9 1 0 2 1 3 7 3 2 3 1 \n 5 1 5 5 3 4 4 1 6 1 0 0 9 1 \n 7 9 3 9 9 0 0 6 4 1 6 2 4 1 \n 8 6 5 0 3 3 0 7 0 7 0 2 1 1 \n 5 3 2 1 9 5 0 0 5 6 3 1 1 8 \n '
avaliar 'q2' ' 11 17 \n 2 2 3 9 6 8 6 6 5 2 4 3 8 0 8 6 0  \n 9 4 7 4 8 5 1 1 7 2 3 2 5 4 0 1 6  \n 8 4 2 8 8 9 3 0 2 4 1 5 8 0 8 1 3  \n 5 9 0 1 0 9 6 5 5 0 9 4 6 8 5 9 4  \n 0 5 5 8 1 2 7 2 8 0 6 1 9 9 6 8 1  \n 4 2 9 1 2 3 5 6 4 1 3 4 3 7 1 4 7  \n 8 4 9 4 6 8 1 7 2 4 6 1 8 7 2 6 7  \n 7 2 6 2 3 4 6 8 7 8 4 3 8 8 8 8 2  \n 9 0 5 8 7 3 4 7 4 0 6 2 3 0 6 3 7  \n 6 7 7 4 5 2 7 1 8 9 4 7 3 7 7 3 7  \n 8 0 2 1 5 2 0 4 1 4 4 5 6 9 4 6 8  \n ' ' 2 9 8 5 0 4 8 7 9 6 8 \n 2 4 4 9 5 2 4 2 0 7 0 \n 3 7 2 0 5 9 9 6 5 7 2 \n 9 4 8 1 8 1 4 2 8 4 1 \n 6 8 8 0 1 2 6 3 7 5 5 \n 8 5 9 9 2 3 8 4 3 2 2 \n 6 1 3 6 7 5 1 6 4 7 0 \n 6 1 0 5 2 6 7 8 7 1 4 \n 5 7 2 5 8 4 2 7 4 8 1 \n 2 2 4 0 0 1 4 8 0 9 4 \n 4 3 1 9 6 3 6 4 6 4 4 \n 3 2 5 4 1 4 1 3 2 7 5 \n 8 5 8 6 9 3 8 8 3 3 6 \n 0 4 0 8 9 7 7 8 0 7 9 \n 8 0 8 5 6 1 2 8 6 7 4 \n 6 1 1 9 8 4 6 8 3 3 6 \n 0 6 3 4 1 7 7 2 7 7 8 \n '
avaliar 'q2' ' 4 17 \n 0 6 5 4 7 4 3 9 9 4 3 7 6 3 1 4 8  \n 4 4 4 2 8 2 1 5 6 6 0 8 7 3 0 6 2  \n 5 4 4 6 7 3 0 0 0 9 0 7 6 9 3 2 7  \n 1 6 8 5 4 2 3 0 3 2 2 0 2 5 4 8 2  \n ' ' 0 4 5 1 \n 6 4 4 6 \n 5 4 4 8 \n 4 2 6 5 \n 7 8 7 4 \n 4 2 3 2 \n 3 1 0 3 \n 9 5 0 0 \n 9 6 0 3 \n 4 6 9 2 \n 3 0 0 2 \n 7 8 7 0 \n 6 7 6 2 \n 3 3 9 5 \n 1 0 3 4 \n 4 6 2 8 \n 8 2 7 2 \n '
avaliar 'q2' ' 8 14 \n 2 3 9 0 6 0 5 6 2 7 5 4 4 6  \n 4 5 8 7 1 2 7 6 5 1 6 4 4 1  \n 9 2 4 2 2 4 4 3 4 8 7 6 7 9  \n 8 0 7 0 3 1 9 4 9 2 3 3 3 5  \n 8 1 5 6 7 1 1 9 4 6 5 0 1 9  \n 1 3 2 3 0 3 4 1 2 8 7 4 6 1  \n 5 5 8 8 4 7 6 7 2 3 7 9 7 5  \n 7 0 8 4 4 1 6 2 3 4 1 3 4 2  \n ' ' 2 4 9 8 8 1 5 7 \n 3 5 2 0 1 3 5 0 \n 9 8 4 7 5 2 8 8 \n 0 7 2 0 6 3 8 4 \n 6 1 2 3 7 0 4 4 \n 0 2 4 1 1 3 7 1 \n 5 7 4 9 1 4 6 6 \n 6 6 3 4 9 1 7 2 \n 2 5 4 9 4 2 2 3 \n 7 1 8 2 6 8 3 4 \n 5 6 7 3 5 7 7 1 \n 4 4 6 3 0 4 9 3 \n 4 4 7 3 1 6 7 4 \n 6 1 9 5 9 1 5 2 \n '
avaliar 'q2' ' 12 15 \n 7 2 8 1 6 6 7 7 8 8 5 9 8 1 9  \n 3 4 4 3 0 6 1 2 2 6 0 7 7 7 2  \n 8 6 0 8 9 8 7 7 3 0 1 4 6 4 7  \n 1 4 0 9 1 4 3 3 8 6 6 1 7 8 8  \n 8 2 8 4 0 9 2 5 8 9 6 2 7 5 6  \n 3 6 0 6 3 5 6 7 6 2 8 9 4 6 9  \n 0 2 9 3 0 0 6 1 2 3 2 9 7 6 0  \n 7 6 0 4 8 0 7 8 8 6 4 6 5 0 0  \n 5 7 0 5 7 4 4 4 1 5 4 4 8 1 3  \n 2 8 7 4 3 3 8 5 5 2 7 5 1 1 1  \n 0 1 3 4 9 9 2 0 8 2 4 9 8 0 1  \n 1 8 8 9 0 6 4 3 2 2 7 3 4 8 8  \n ' ' 7 3 8 1 8 3 0 7 5 2 0 1 \n 2 4 6 4 2 6 2 6 7 8 1 8 \n 8 4 0 0 8 0 9 0 0 7 3 8 \n 1 3 8 9 4 6 3 4 5 4 4 9 \n 6 0 9 1 0 3 0 8 7 3 9 0 \n 6 6 8 4 9 5 0 0 4 3 9 6 \n 7 1 7 3 2 6 6 7 4 8 2 4 \n 7 2 7 3 5 7 1 8 4 5 0 3 \n 8 2 3 8 8 6 2 8 1 5 8 2 \n 8 6 0 6 9 2 3 6 5 2 2 2 \n 5 0 1 6 6 8 2 4 4 7 4 7 \n 9 7 4 1 2 9 9 6 4 5 9 3 \n 8 7 6 7 7 4 7 5 8 1 8 4 \n 1 7 4 8 5 6 6 0 1 1 0 8 \n 9 2 7 8 6 9 0 0 3 1 1 8 \n '
avaliar 'q2' ' 6 10 \n 0 1 0 7 8 5 4 8 1 5  \n 2 8 6 6 4 2 1 2 4 3  \n 0 0 3 9 2 7 6 0 0 2  \n 6 7 5 5 1 8 0 9 0 7  \n 0 7 3 1 1 3 5 7 0 9  \n 2 3 3 4 8 4 4 5 7 1  \n ' ' 0 2 0 6 0 2 \n 1 8 0 7 7 3 \n 0 6 3 5 3 3 \n 7 6 9 5 1 4 \n 8 4 2 1 1 8 \n 5 2 7 8 3 4 \n 4 1 6 0 5 4 \n 8 2 0 9 7 5 \n 1 4 0 0 0 7 \n 5 3 2 7 9 1 \n '

avaliar 'q3' ' 5 15 \n 7 6 0 7 4 4 9 7 5 4 8 8 4 2 7  \n 9 5 3 9 3 9 5 5 7 9 9 5 3 7 1  \n 5 0 9 2 6 5 5 5 0 4 3 6 8 5 6  \n 0 9 2 2 5 8 9 0 7 5 7 9 3 5 9  \n 2 8 4 1 9 6 1 2 4 1 4 2 0 7 3  \n ' ' (1,3)\n (1,5)\n (1,13)\n (2,2)\n (2,4)\n (2,12)\n (3,1)\n (3,6)\n (3,8)\n (3,11)\n '
avaliar 'q3' ' 13 9 \n 4 9 9 5 1 6 6 7 4  \n 7 9 7 6 9 1 3 9 6  \n 7 5 9 5 5 9 9 4 1  \n 6 9 2 1 4 2 7 7 3  \n 0 5 5 0 3 7 3 5 8  \n 5 1 8 9 2 2 9 3 4  \n 3 3 7 6 7 1 0 5 4  \n 0 2 6 0 9 8 8 6 6  \n 5 5 7 7 5 0 7 4 9  \n 2 9 5 4 4 7 5 3 5  \n 5 7 7 5 6 2 1 2 0  \n 4 7 6 4 2 5 3 8 0  \n 6 1 1 8 3 8 9 6 3  \n ' ' (1,4)\n (1,7)\n (2,2)\n (3,1)\n (4,5)\n (5,3)\n (5,6)\n (7,4)\n (9,1)\n (9,5)\n (10,4)\n (11,7)\n '
avaliar 'q3' ' 10 9 \n 4 7 4 7 3 6 2 4 0  \n 7 0 0 2 8 8 5 0 3  \n 9 8 2 6 6 3 6 8 7  \n 3 8 9 0 3 1 6 7 7  \n 6 5 1 8 9 0 7 7 0  \n 1 2 2 0 7 6 9 5 7  \n 2 4 9 2 4 4 2 2 0  \n 4 7 5 1 1 2 4 8 5  \n 7 6 2 1 5 8 1 9 5  \n 9 5 6 9 7 9 3 1 8  \n ' ' (2,7)\n (3,2)\n (4,4)\n (5,6)\n (6,2)\n (7,1)\n (8,7)\n '
avaliar 'q3' ' 14 17 \n 9 5 1 9 1 7 3 4 5 6 8 9 2 2 2 9 8  \n 3 8 0 7 3 0 9 9 4 6 1 8 6 8 2 9 6  \n 9 6 9 1 9 0 5 6 6 2 3 1 8 2 8 8 1  \n 9 6 9 1 7 0 7 3 6 3 4 8 6 0 7 1 1  \n 6 6 1 5 4 2 9 3 6 9 5 6 7 8 0 1 4  \n 1 2 5 8 7 8 1 4 5 1 3 9 0 7 7 9 5  \n 8 4 8 0 1 7 5 6 4 2 6 5 8 3 0 6 8  \n 3 1 1 7 5 7 2 4 0 2 4 1 8 2 8 5 2  \n 4 4 5 6 9 4 4 8 4 5 9 3 6 0 1 0 6  \n 0 7 2 5 3 9 3 0 8 5 7 7 7 8 5 5 1  \n 4 8 0 4 9 5 3 9 6 8 4 1 0 9 0 0 6  \n 5 8 4 1 7 9 9 2 2 5 7 9 0 9 5 4 5  \n 7 5 1 2 7 7 7 4 6 0 9 0 2 8 8 0 3  \n 1 4 1 1 0 4 0 2 5 1 8 6 6 8 3 7 2  \n ' ' (1,1)\n (1,13)\n (2,4)\n (2,12)\n (3,11)\n (4,6)\n (4,9)\n (4,13)\n (5,3)\n (5,5)\n (5,11)\n (5,15)\n (6,2)\n (6,7)\n (6,10)\n (7,3)\n (7,14)\n (8,4)\n (8,7)\n (8,10)\n (9,5)\n (9,8)\n (10,4)\n (10,7)\n (10,9)\n (11,11)\n (12,8)\n (12,10)\n '
avaliar 'q3' ' 9 5 \n 8 0 6 2 9  \n 4 2 9 1 2  \n 2 3 9 0 5  \n 0 2 0 1 7  \n 4 5 0 9 6  \n 9 5 6 7 9  \n 3 8 4 7 0  \n 7 0 0 0 5  \n 6 7 4 9 0  \n ' ' (4,3)\n (6,1)\n '
avaliar 'q3' ' 17 18 \n 7 7 5 6 8 2 8 3 2 3 7 9 7 4 4 7 4 2  \n 8 2 0 9 6 3 7 3 7 1 0 8 6 6 5 4 4 8  \n 2 7 0 7 5 6 7 8 4 1 5 3 5 3 7 5 5 9  \n 8 7 9 5 1 9 1 8 8 7 1 4 6 8 6 3 7 7  \n 9 8 1 0 7 3 3 2 6 8 3 5 9 8 7 6 3 9  \n 8 4 3 3 0 4 2 1 0 8 9 4 6 6 3 4 8 3  \n 0 8 8 6 4 9 0 0 0 1 2 2 4 9 3 4 8 8  \n 6 1 0 2 3 0 7 2 8 2 1 4 8 2 1 7 5 1  \n 1 7 8 1 0 3 7 2 2 0 7 7 2 7 5 9 1 4  \n 3 8 1 7 0 8 7 4 3 1 6 8 2 1 5 1 7 4  \n 5 0 0 9 5 0 2 5 6 7 9 8 9 3 0 9 5 6  \n 3 7 4 3 0 0 7 7 0 6 3 1 1 6 4 0 8 4  \n 3 8 5 5 8 0 9 7 5 4 5 9 6 4 2 8 6 3  \n 5 9 3 5 8 7 7 6 3 0 1 4 8 1 6 9 5 9  \n 3 0 8 2 8 9 0 9 9 9 5 5 9 5 4 2 5 0  \n 9 8 1 9 9 9 5 9 7 8 8 8 5 4 3 1 0 9  \n 4 1 2 3 7 8 5 8 7 0 9 9 8 0 8 3 1 7  \n ' ' (1,3)\n (1,8)\n (2,10)\n (2,14)\n (3,2)\n (3,5)\n (4,4)\n (4,12)\n (5,10)\n (6,5)\n (6,13)\n (7,8)\n (7,12)\n (8,2)\n (8,13)\n (8,15)\n (9,1)\n (9,5)\n (9,16)\n (10,3)\n (10,10)\n (10,12)\n (10,15)\n (11,13)\n (11,16)\n (12,6)\n (12,11)\n (13,1)\n (13,15)\n (14,2)\n (14,12)\n '
avaliar 'q3' ' 14 16 \n 9 9 4 3 8 9 0 7 9 4 2 5 4 0 2 6  \n 0 3 3 8 2 1 4 9 1 7 0 1 0 9 2 5  \n 1 2 0 5 1 5 3 5 2 1 5 4 6 8 5 2  \n 5 8 0 8 2 1 1 8 3 4 6 1 6 1 8 1  \n 1 7 1 1 3 3 3 1 1 1 3 5 6 5 1 7  \n 8 1 6 0 8 2 7 9 6 2 4 1 5 8 4 9  \n 4 9 1 9 9 6 1 7 9 3 9 9 4 9 8 2  \n 5 0 2 3 9 7 0 0 3 4 0 9 1 1 6 2  \n 2 0 7 6 4 2 5 2 6 3 1 1 7 4 1 9  \n 5 4 1 6 5 3 2 1 0 7 1 6 7 9 2 7  \n 1 5 7 5 5 7 0 0 0 9 8 3 1 1 1 4  \n 9 4 5 3 4 4 6 1 1 1 8 0 4 9 1 3  \n 4 4 9 7 5 9 0 9 8 4 7 7 7 5 8 2  \n 0 6 9 3 2 8 5 2 8 9 5 4 5 9 0 3  \n ' ' (1,3)\n (1,7)\n (1,9)\n (1,13)\n (2,5)\n (3,1)\n (3,3)\n (3,7)\n (3,10)\n (3,14)\n (5,2)\n (5,7)\n (6,1)\n (6,8)\n (6,13)\n (7,9)\n (8,2)\n (8,6)\n (8,8)\n (9,13)\n (10,2)\n (10,5)\n (10,9)\n (11,6)\n (11,13)\n (12,5)\n (12,7)\n (12,14)\n '
avaliar 'q3' ' 19 20 \n 8 3 1 0 7 6 2 5 5 9 1 0 3 0 7 1 8 9 2 3  \n 0 9 9 8 0 8 4 3 4 7 1 8 6 9 2 3 9 7 3 1  \n 3 6 1 4 5 9 2 7 0 1 5 7 5 2 9 9 1 5 8 7  \n 6 5 7 6 5 9 8 6 8 5 1 2 9 4 1 0 1 2 7 7  \n 6 4 6 8 1 8 0 3 1 0 5 7 9 7 8 6 8 6 7 2  \n 8 1 2 3 2 5 2 0 0 6 6 1 6 1 3 1 6 0 2 1  \n 2 9 2 3 3 8 4 9 4 4 0 9 6 0 9 6 7 0 7 4  \n 9 0 9 2 7 7 7 2 2 7 7 0 4 1 8 2 3 0 7 3  \n 2 7 0 7 2 0 3 4 0 8 9 2 5 8 5 7 5 2 9 7  \n 6 9 6 5 0 0 9 7 7 1 4 9 3 9 3 0 8 5 5 6  \n 8 3 4 7 8 6 3 3 4 3 2 2 5 1 3 4 1 8 7 8  \n 4 2 4 6 7 7 5 3 8 0 7 4 1 9 3 0 3 9 7 3  \n 9 2 8 8 0 3 8 3 8 0 3 5 5 3 8 6 5 9 7 0  \n 0 6 7 2 6 6 4 5 9 5 8 4 0 8 8 8 4 1 4 7  \n 9 5 6 8 0 3 7 5 5 2 9 6 2 3 0 9 1 7 6 3  \n 0 8 9 3 0 7 7 7 8 9 5 1 0 9 2 4 5 2 8 4  \n 7 3 1 7 3 3 8 6 9 8 2 0 4 2 3 6 7 1 7 2  \n 8 1 8 7 1 0 4 7 1 1 0 6 5 7 6 1 3 4 9 9  \n 9 9 4 5 2 5 2 8 4 4 0 5 7 4 4 0 6 6 3 9  \n ' ' (1,11)\n (1,13)\n (1,16)\n (2,7)\n (2,18)\n (3,2)\n (3,8)\n (4,3)\n (4,14)\n (4,16)\n (6,1)\n (6,5)\n (6,7)\n (6,11)\n (6,14)\n (6,16)\n (7,2)\n (8,3)\n (8,10)\n (8,15)\n (8,18)\n (9,1)\n (9,6)\n (9,11)\n (9,13)\n (9,16)\n (10,4)\n (10,12)\n (10,15)\n (11,10)\n (11,13)\n (12,6)\n (13,8)\n (14,3)\n (14,10)\n (14,15)\n (14,17)\n (15,2)\n (15,9)\n (15,13)\n (15,18)\n (16,6)\n (16,8)\n (16,16)\n (17,2)\n (17,11)\n (17,13)\n '
avaliar 'q3' ' 7 18 \n 6 7 5 1 0 9 7 7 0 1 2 0 0 1 6 0 0 9  \n 7 6 8 6 3 4 0 8 4 3 5 5 6 6 0 5 9 7  \n 2 6 8 9 4 2 0 6 9 2 7 5 1 0 4 8 6 7  \n 2 5 8 7 2 3 8 9 1 1 9 2 3 6 4 8 7 6  \n 6 1 3 6 7 2 3 4 2 0 5 6 2 3 9 6 3 1  \n 1 8 3 9 6 4 3 2 7 6 3 8 2 6 3 4 0 9  \n 2 2 4 7 4 7 8 3 4 4 3 3 6 0 5 0 0 1  \n ' ' (1,7)\n (1,16)\n (2,3)\n (2,8)\n (3,7)\n (3,10)\n (3,13)\n (4,4)\n (4,14)\n (5,1)\n (5,3)\n (5,8)\n (5,11)\n (5,13)\n '
avaliar 'q3' ' 17 6 \n 8 9 6 2 0 9  \n 6 3 6 2 0 5  \n 5 7 0 1 3 2  \n 7 7 0 6 6 8  \n 0 5 8 6 3 3  \n 6 3 3 9 3 9  \n 3 6 6 2 1 8  \n 1 2 0 8 6 5  \n 6 5 8 1 5 3  \n 7 8 5 9 8 4  \n 0 6 2 6 9 9  \n 4 0 8 7 3 5  \n 8 1 9 5 9 6  \n 0 7 6 4 6 8  \n 3 7 4 1 4 1  \n 6 1 3 7 5 1  \n 2 8 7 7 3 7  \n ' ' (4,2)\n (5,3)\n (7,3)\n (8,2)\n (9,1)\n (9,3)\n (12,2)\n (12,4)\n '
avaliar 'q3' ' 7 11 \n 1 5 6 5 7 1 1 4 1 5 9  \n 3 0 3 9 2 3 3 3 5 8 5  \n 6 3 5 3 6 6 6 3 5 9 0  \n 7 4 8 5 8 2 8 7 9 6 8  \n 5 2 0 4 0 1 5 5 3 8 7  \n 2 4 7 7 0 9 0 6 6 6 6  \n 2 2 6 2 1 7 1 8 2 1 9  \n ' ' (1,3)\n (2,9)\n (3,2)\n (3,4)\n (3,6)\n (3,8)\n (4,9)\n (5,5)\n '
avaliar 'q3' ' 16 15 \n 6 5 6 9 6 2 7 1 6 5 6 4 0 1 2  \n 6 5 9 9 4 9 9 5 3 5 1 8 3 9 4  \n 8 1 6 7 1 0 0 9 3 3 4 0 9 8 7  \n 3 0 7 1 4 1 0 1 2 1 7 4 9 1 4  \n 0 9 3 6 0 7 6 0 3 5 9 5 7 9 7  \n 3 9 1 1 2 5 5 3 6 3 9 9 9 8 3  \n 8 9 6 4 1 5 2 7 6 9 2 0 4 7 5  \n 8 0 6 3 1 5 0 2 9 6 1 1 2 9 7  \n 8 0 4 6 2 0 4 3 5 2 1 4 2 8 0  \n 7 6 1 3 1 1 9 7 3 0 9 2 7 4 8  \n 5 5 6 0 2 5 5 4 7 2 4 5 6 8 6  \n 1 8 5 0 3 2 1 1 0 4 1 1 6 9 6  \n 6 4 7 9 7 1 9 3 2 8 7 3 1 6 8  \n 7 5 4 0 2 9 5 5 7 9 0 7 4 0 2  \n 8 0 1 7 5 4 9 0 6 8 8 1 3 8 5  \n 3 3 5 1 2 1 8 7 4 9 5 1 9 8 3  \n ' ' (1,11)\n (1,13)\n (2,7)\n (3,2)\n (3,4)\n (4,3)\n (4,5)\n (4,13)\n (6,7)\n (6,9)\n (7,8)\n (7,13)\n (8,3)\n (8,11)\n (9,6)\n (9,10)\n (9,12)\n (10,2)\n (10,8)\n (11,1)\n (11,13)\n (12,3)\n (12,6)\n (13,5)\n (13,9)\n (13,11)\n (14,3)\n (14,6)\n '
avaliar 'q3' ' 13 7 \n 7 9 6 3 2 9 7  \n 4 5 8 8 1 9 9  \n 3 2 7 7 1 2 6  \n 4 0 7 8 6 6 9  \n 7 8 3 5 8 7 1  \n 7 0 7 6 8 6 4  \n 4 3 4 7 0 7 4  \n 6 5 6 7 2 0 6  \n 9 7 5 3 6 8 5  \n 5 0 1 8 2 3 6  \n 8 3 1 0 3 2 1  \n 7 8 4 7 9 9 2  \n 2 7 6 3 9 7 2  \n ' ' (3,3)\n (4,1)\n (5,2)\n (6,5)\n (8,5)\n (9,3)\n (11,1)\n '
avaliar 'q3' ' 9 12 \n 4 8 7 5 6 8 9 5 9 4 8 2  \n 3 6 0 4 8 5 4 3 6 7 0 2  \n 6 8 2 5 6 6 1 4 3 7 4 0  \n 6 2 4 8 3 3 8 3 2 6 3 1  \n 7 4 4 7 4 3 9 9 6 0 1 7  \n 9 3 1 9 5 1 6 1 3 0 7 4  \n 6 4 5 6 9 8 8 5 6 1 3 7  \n 7 1 3 7 1 9 8 1 0 6 3 8  \n 5 0 3 6 5 5 5 3 0 5 3 6  \n ' ' (1,4)\n (2,1)\n (2,7)\n (3,3)\n (5,3)\n (5,10)\n (6,4)\n (6,8)\n (7,3)\n (7,5)\n (7,9)\n '

avaliar 'q4' '11\nLSOOLLSSOOONNSSOONN\nLSOSNOXNNNOONOSLNNO\nOLSLNNSLLOSLNNNNNLN\nNSLNSNLOSLLLNLLLSNO\nOSONLSOOLOOLNSNSSNO\nNNNOLSOLLOLOLSNSOLN\nNLLNSSOSOLOLLOONLOL\nOSNSOLNNNLONSSLNSNL\nNLOOLSSNSOOOLONOSNL\nOSSNLOSSNLNOSOSNOLN\nLONONLOLLOOOSSNNSLN\n' 'sim'
avaliar 'q4' '19\nSLLLLSNLOOLSL\nSNNLSOOSLLLLN\nLNLSOXOSSNSLO\nSOSLLLNNOONSS\nNNSNLOLNLNLON\nOLSLOOLLOLSNS\nLNNNNLNLLNOOO\nOSLLSLNSSOLNL\nOLSOLSONOSOLN\nNSSLLNONLNOOO\nLLSLOLONNNLNO\nSLONNOOOSOOSO\nNSSLLONOSONLN\nONLNOSLSOOLLL\nNONNNLLOLOOLN\nNLOOLNNSLOLOL\nOOSSLNLLSLLLS\nSLNSNONLLONLN\nNNLNNLLOSNOLN\n' 'sim'
avaliar 'q4' '12\nSNNSOSOONLLSOLO\nSSLSSNSONSNOOSO\nSSNOSLSLSSSOOSO\nSLSOONLOOLLOOLN\nSSLSOSSLNLSLOLN\nLLLLSOONONOOSSN\nNNSOSONONLLLLON\nSOONOLNNNNNOONL\nSNSNNONNONSONSS\nLLSNSSSNLSONOSS\nLXSOSONOSOOSNNL\nNOOSLNLSLSOSOSS\n' 'sim'
avaliar 'q4' '20\nSNONOLSONSSONONN\nSNNNNLSSNONNLOSS\nSLLSNOLNOSNOOSLS\nLNNSLSSNOSLLLSLO\nSOOOSOLONLSOLNLO\nSXOSLONSLLSSOONL\nLSNNNNONNNNNOSLN\nLLNNNLOOLNOOLSNO\nSNSNSLNNSNNLNLNO\nOSNNNSNLLNNSNLSN\nNSNLOLNLSNOSSNSS\nNOLNOSLNNOOSONNS\nLNOSSSOONLLNLNNL\nLLNOLSOONLOLOLOL\nOSSSOLNOSSNOSOOO\nSSLNLSSNSLLNLLSL\nLOLSNOSSLNNLSLSS\nONLOOSOOSSNNONLN\nLNNSNSSNNOLOOSOS\nONSSSNOOSNOLNLON\n' 'sim'
avaliar 'q4' '12\nLSLSONOLOSSNNSOOS\nNLLSLLSOONLNLNLOO\nLLSLSSONNONNSLSON\nLOLLSXLNONLLLSSOS\nSLSNLLNLSOOLNNLOS\nNONOLNSNSLOSLOLLL\nLSNOLOONNLNLLSOOS\nLLNLLNSSNOLLOOLOO\nONSLSSLSLNLOLLONS\nSOONSSOLLLNLOSOLO\nNOONSSONNNLNSNLSN\nNOLNLSNSOOSSSOOSS\n' 'sim'
avaliar 'q4' '16\nLLLLSSOSOSLOSLNNNL\nLONLSLNLOSNSOSOLNN\nSLOLLSOOLLSSNOLOON\nOOLLSLSSLNLLONNLON\nLLNOOOSSLONLLSOSNO\nNNNNLNSOSOONSNNNSL\nSSNSNOOOSXSONSLSSO\nSOOLNLLNNNLSONLNNN\nLSSNSOSOOOLNONNOLN\nSLOLSSLSSSONOOOLSS\nOOOOOOLOLLLSSSLSSO\nNOONLNNSSOLSLOSNNO\nOLNNNNNSSOLOSSONNS\nNSSNLLSOLLNSNSNSSS\nOLLOSSONSLSLSOLONL\nSNSNOOLSLONSLNOLSS\n' 'não'
avaliar 'q4' '20\nSLNNOSNLLOSLONOLOS\nLSOSNSLSLNONSSSNON\nNLSOOSNOLLNOOLNNNL\nNSOOSLSSLOOLNLLNLL\nNLLLSLNOSNOLSOSOON\nOOOLSONOSSSSSLNOOL\nOLLOLSLSSLONNOONLO\nSNONOLLSLSLLNSLONL\nNLSLSOSOLSLOLOLSSO\nNSNNSNOLLNOOONOLLN\nLSLNLSOOOOSSSSNLNO\nOOLNNLLLLLSSNLLSON\nNSSLSLSOOLSONNOSLN\nNLNNSNLONOOSSSOLSS\nNONLOLNSOLLOOSNNLO\nSSONLLLLONSOOONOSO\nSLLOONOLOOSSNNONSS\nONNNNONNNSOSOOOLLN\nSOLNSLNNSSNSOOLXSS\nSONNSLLNSOSSSNOONN\n' 'não'
avaliar 'q4' '12\nLLLSLSNOLSN\nOSOLSSSNNOO\nNONOOLLLOOS\nSSNSOOSSLOO\nOSNSSSLNSSO\nNNSOONSSNNL\nNOSNNNNNLLN\nOSLNSONONOS\nNSNNXONOONO\nSLLSSNSNOOS\nNNLSLNSSSSN\nSLNLOLSSSSS\n' 'não'
avaliar 'q4' '10\nSSSSNLSLLNNSLNSLLNN\nLLSSLNLNONLLLLNNOLL\nOOSSLSSOONSLNLLLNNL\nNLSOONNLONNOSOSNNNL\nOLSNSOLSLLNNLOLLLLO\nSLLLLLSLLSSONNNLLLO\nOOLLLSOONOLOSOLLSOO\nLOONSLSOLSNOSOLLNOO\nNLNNNNSOSNSOXLOSNOS\nONOOOOOSSNNLNLOOONO\n' 'não'
avaliar 'q4' '16\nSLLLLSLLLSOSNLONOSN\nSSLLNSNLSOLSNLLLLNS\nLLNLSOSSLNLOOSLNOSN\nSNONOLLSLLSLNSNLOXN\nLLONSLSNOONNONONLSL\nNNOSSSOOOONONLOLLSS\nSSSSLOSOSSSOSLLSLSO\nNLOOOSNOSLONSNNNSSN\nSOSOSLSSNSSSONNLLLS\nSSOLNLSLNLNSOLSNOOL\nSSSOOOOSNNOSNOLLONO\nOSNOSLOLSSLOLNSOLLS\nLLSONSSOLOLOSLLLLLL\nOLNNOSNLNSSNONSNLNN\nNNNOSSLOOLNNOSNNSNL\nSOSNONOONLOSONSONLN\n' 'não'
avaliar 'q4' '12\nLLSOLSLONSSLNONNN\nOLSNLONNSOOSLSOSS\nNLSLSLLSLOOLOOLNN\nSLLLSNNOSSLNOLSLO\nNLSLLLSONLOONLLSN\nXOONOSOSLSOLSNLOL\nLONOLLSLLNSOSLSON\nSNLNOOOLSLOSLNOLN\nNLLLOONLSLLNOSOOL\nONNNONONSLNLNOSNO\nONNONSONOOSOLNOLS\nOONNSNLNONLNSLSNN\n' 'sim'
avaliar 'q4' '14\nSNNSSSSSLSSSNLNSLLN\nSLLSLNSNNLSSLSOLSOO\nLSLNLLSNLNLSLSNSONN\nSOLLXOSLOONSNOOSOLN\nLLNNLSLLSLOLOOSLOLL\nNNLSLLONNOSSOLLLLOO\nNOLSLNLONLNLOLSNSNN\nSLONLOSSSLSLNSSOLLO\nLLNOLNSNOOOSSNSNOON\nOOOOSOLOSLLSSNSNLSN\nSLNLOSSLNNSLLLLOSOO\nNSLSOLSNNONSOSOLONL\nSLNSSNLLNNNNSOLSNOO\nNSNSLLSLONLLSSLNSNL\n' 'sim'
avaliar 'q4' '14\nLSLLONOLLOSOL\nSOLSONNLSSSNO\nLLSOOLLNOLNOS\nNSOLSLLLNLNSO\nNSSLOSSSSSLOL\nSOSONSSSOOLLL\nLSSOOOLLOSLSO\nSOOSLOSSLOSLO\nLSNSSONOLNOOL\nSOLSSNSNSNSON\nLLNSXNLNOOOSS\nOSLLLNLLSOSLO\nNNOLONLLLONNL\nSLOOLLONLSSLS\n' 'sim'
avaliar 'q4' '19\nLSNNSSNOSSSOOOONOSO\nSOLOLLOSSLSSOLLSNLO\nSSLOOLSLNOLNNLLLONO\nLSLSSSNSNLNSSSNLOSN\nNSLOOLSSOSOSNSNSOLO\nSSLSNLLONSNOOOONLOS\nSONLLSSLNNNOOSOLOLO\nSONNSXONNSSNNSOOONS\nLLNLNSLLSOOLLOSSSLS\nNLLLNLOONLLLSNOSOON\nNLNLOOSLSLONOLSSSSS\nSSOLLLLSNLNOLOSSNSS\nOLLSSOSONLSNSSNSSSL\nLSONLOSNNSNSOONSSOL\nSONONSLOONNONOSONNO\nOSSNOLSLSLSNLONOOSS\nNLOSSLLOLLNLLONNNLO\nNOLNLLLNOLLSSLNOONS\nNOSSSNLLSLOONOLLONL\n' 'sim'
avaliar 'q4' '15\nLSLOSNONSNLOS\nXSSLOSLSSLSON\nNSOOLOLSOLSLS\nNOOSNOSNNLSNN\nOLLSLSOOSONLL\nNSNOONLSOLOLO\nLOONSNOSLLLLS\nSLNLLSSONSSNN\nLLNONNSSSONLS\nSNOSSNSSOSLOO\nSSSLNSOSSONNN\nLSLLOSSSLNLLS\nSSSNSLSNLLSLN\nLLLLLSONNLOLL\nOONSNSSNSSNON\n' 'sim'
avaliar 'q4' '20\nSLLSLSLNNSO\nLNSLNLSNONL\nSOSOOOOOSON\nSNOONLNOOON\nSSLSLLOSNSO\nSSOLNSOSLSO\nSLLNNNSNOON\nLNLOSSOSNNN\nSOSOLSSOOLL\nLNLSONNLNNS\nSLLLSOOOSON\nLNLOLLLSOXO\nSNSLLSOOOSN\nSOLNLLOLSLL\nOSSNLNNOOSL\nNSONNNOSNNO\nLOOLSOSSLSL\nNOLLNONLLSO\nLONLOLLNSNN\nLLSNNNLNNSS\n' 'não'
avaliar 'q4' '14\nLSLLLLLSLSOL\nNLLNOSSONNOL\nLSNOLNLSNNSS\nOSSLLSNSOLON\nOLNOSSSSSNLN\nLOLLNSLLSLNO\nNLOOOONOSNLN\nNSNLNNNSLLSN\nOOSNOSNOLSON\nSNSOLLLOSLSN\nLOSLLLNOSOSN\nNOLNNLLNOOLN\nSLLSSOSSSNNS\nSNNLNLNLOXSS\n' 'não'
avaliar 'q4' '11\nLLLLSONNSNNSLOLOS\nLSOLSLNSOLONOSSOL\nLLLOLSSLSONOLLSLN\nNOSLLLSNNLNSLLOSX\nOLOOOOSLNSNLLONLL\nOSLNNNOSOSSOSNSLN\nSNLNNLSOSONLSOSLO\nLNSLLSLSOSNLSSSOO\nLSSOSSNNONLLSONSN\nNOSLLOONOOSNONOLO\nONLSSNLSNNLSSSSSN\n' 'não'
avaliar 'q4' '20\nSSONSLLSLOLNLN\nSNNOSLNNSNSOLL\nSLNSNOSLOSLOLL\nLNSSNNSNNLNNNL\nSONOLLNSLLONLS\nONSLSSLOOSOOLS\nONNNSOLOSSSLOO\nLLNOONSSNLSOLO\nSLSOSONLNOSSON\nOSOSSONLOONSON\nLNSSONSLNSSSLO\nSNSNOLLNSSSOSN\nLNNSSNLLLSOOLL\nLOOSLNNLOSNLNL\nLONOLSOSSSSLLO\nONLLNNNNLLSONS\nOOSLOLLLOLNNLS\nLNOSNNLSONNSNL\nNONXLNSLLLNLLL\nSLSSNLNSSLLSSL\n' 'não'
avaliar 'q4' '13\nSLSOOOOOSSNONOSOO\nSNLLLNLOSOSLNNLLS\nLNNOSSOOLNNOOLOON\nNSNNSNNSONLOSSSNL\nNNNLNOLLLSNONNOLO\nSONNNSOLOSNLLOLNS\nSSSSSSNLLSSSSSONO\nOSONOLONLOSLLOLSS\nSONOLSOLLNSNNNNOL\nLNSLNNNSLSLLOOOON\nNLLNOSSNONSNSNNSS\nLNOOLSNONOONSNLLO\nSOOOSLNNXLNLNSONS\n' 'não'


totalQuestoes=0
notaTotal=0
echo ''
echo -e "${amarelo}              sumário $1            ${normal}"
echo '----------------------'
echo -e 'problema\tacertos / número de testes'
for i in ${!sumarioTotal[@]}; do
	if ! [ -n "${sumarioStatus[$i]}" ]; then
		echo -e $i '\t' ${sumarioAcertos[$i]} / ${sumarioTotal[$i]}
		acertos=${sumarioAcertos[$i]}
		total=${sumarioTotal[$i]}
		notaQuestao=$(echo "$acertos/$total" | bc -l)
		notaTotal=$(echo "$notaTotal+$notaQuestao" | bc -l)
	else
		echo -e $i '\t' 'Erro:' ${sumarioStatus[$i]}
	fi
	totalQuestoes=$((totalQuestoes+1))
done
echo '----------------------'
echo 'Nota: ' $(echo "2*$notaTotal/$totalQuestoes" | bc -l)
