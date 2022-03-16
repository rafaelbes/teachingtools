vermelho='\033[0;31m'
verde='\033[0;32m'
normal='\033[0m'
azul='\033[0;36m'
amarelo='\033[46m'

output=''
for filename in *.md; do
	base="${filename%.md}"
	conteudo="$(head -c 140 "$filename" | sed 's/\\//g')"
	keywords=$(grep keyword "$filename" | cut -d: -f2 | grep "[A-Za-z0-9 ,]*" -o)
	assuntos=$(grep assunto "$filename" | cut -d: -f2 | grep "[A-Za-z0-9 ,]*" -o)

	if ! grep -q assunto $base.md; then
		output=$output"${vermelho} $filename ${normal}:"
	else
		output=$output"${verde} $filename ${normal}:"
	fi
	
	if [ -f $base.ok ]; then
		output=$output"${verde}CHECKED ${normal}"
	else
		if [ -f $base.fwd ]; then
			output=$output"${azul}CHECKED ${normal}"
		else	
			output=$output"${vermelho}CHECKED ${normal}"
		fi
	fi

	if [ ! -f $base.in ]; then
		output=$output"${vermelho}G${normal}"
	else
		output=$output"${verde}G${normal}"
	fi

	if [ ! -f $base.c ]; then
		output=$output"${vermelho}C${normal}:"
	else
		output=$output"${verde}C${normal}:"
	fi

	output=$output":${normal}$keywords${normal}"":${amarelo}$assuntos${normal}\n"
done
echo -n -e $output | column -t -s':' | sort -k5
