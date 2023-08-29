#!/bin/bash

output=""
packages=""
fontsize=$(whiptail --inputbox "Insira o tamanho da fonte (ex.: 10, 11)" 8 78 11 3>&1 1>&2 2>&3)
if [ -z $fontsize ]; then
	fontsize=11
fi
packages+="\\\\usepackage[portuges,brazil]{babel}\n"
packages+="\\\\usepackage{ae}\n"
packages+="\\\\usepackage[OT1]{fontenc}\n"
packages+="\\\\usepackage[utf8]{inputenc}\n"
packages+="\\\\usepackage[protrusion=true,expansion=true]{microtype}\n"
packages+="\\\\usepackage{amssymb,amsmath}\n"

title=$(whiptail --inputbox "Insira o titulo da lista:" 8 78 "Lista de Exercício" 3>&1 1>&2 2>&3)
output+="\\\\title{$title}\n"
name=$(whiptail --inputbox "Insira o nome do autor:" 8 78 "Rafael Beserra Gomes" 3>&1 1>&2 2>&3)
universidade=$(whiptail --inputbox "Nome da universidade" 8 78 "UNIVERSIDADE FEDERAL DO RIO GRANDE DO NORTE" 3>&1 1>&2 2>&3)
dept=$(whiptail --inputbox "Nome do departamento" 8 78 "Departamento de Informática e Matemática Aplicada" 3>&1 1>&2 2>&3)
output+="\\\\author{$name}\n"
conteudo=""

function menu_packages {
	whiptail --title "Use Package" --checklist --separate-output \
		"Escolha os packages que deseja incluir" 20 80 10 \
		"listings" "listing: para exibir códigos-fonte" OFF \
		"enumerate" "enumerate: para incluir enumerações" OFF \
		"varwidth" "varwidth: para criar caixas de comprimento variável" OFF \
		"xcolor" "xcolor: para incluir definição de cores" OFF 2> results
	while read pkchoice
	do
		packages+="\\\\usepackage{$pkchoice}\n"
		if [ $pkchoice = "listings" ]; then
			output+="\\\\lstset{\nlanguage=C,\nbasicstyle=\\\\footnotesize\\\\ttfamily,\nkeywordstyle=\\\\footnotesize\\\\bfseries\\\\sffamily,\nshowstringspaces=false,\nnumbers=left,\nnumberstyle=\\\\footnotesize,\nstepnumber=1,\nnumbersep=5pt,\ntabsize=4,\nbackgroundcolor=\\\\color{gray!15},showspaces=false,showtabs=false,stringstyle=\\\\ttfamily\\\\color{red!80!brown},\ncommentstyle=\\\\ttfamily\\\\color{blue!80},\nkeywordstyle=\\\\bfseries\\\\color{deepgreen},escapeinside={\%*}{*)}}"
		fi
	done < results
}

function menu_comandos {
	while [ 1 ]
	do
		CHOICE=$(
		whiptail --title "Tex Generator" --menu "Make" 16 100 9 \
			"haha" "haha" \
			"encerrar" "voltar" 3>&2 2>&1 1>&3
		)
		case $CHOICE in
			"encerrar") break
			;;
		esac
	done

}

while [ 1 ]
do
	CHOICE=$(
	whiptail --title "Tex Generator" --menu "Make" 16 100 9 \
		"packages" "Definir pacotes para incluir" \
		"cabecalho" "Definir cabeçalho e rodapé" \
		"textoaleatorio" "Incluir palavras aleatórias no texto" \
		"imagemaleatoria" "Incluir uma imagem aleatória no texto" \
		"criar" "Criar .tex e encerrar" \
		"encerrar" "Encerrar" 3>&2 2>&1 1>&3
	)
	case $CHOICE in
		"packages")
			menu_packages
		;;
		"cabecalho")
			output+="\\\\usepackage{fancyhdr}\n"
			output+="\\\\pagestyle{fancy}\n"
			hrwidth=$(whiptail --inputbox "Insira a espessura da linha do cabeçalho (ex.: 0.4, 0.5)" 8 78 0.4 3>&1 1>&2 2>&3)
			output+="\\\\renewcommand{\\\\headrulewidth}{"$hrwidth"pt}\n"
			ftwidth=$(whiptail --inputbox "Insira a espessura da linha do rodapé (ex.: 0.4, 0.5)" 8 78 0.4 3>&1 1>&2 2>&3)
			output+="\\\\renewcommand{\\\\footrulewidth}{"$ftwidth"pt}\n"
			lhead=$(whiptail --inputbox "Digite o que aparece à esquerda do cabeçalho" 8 78 Exercícios 3>&1 1>&2 2>&3)
			output+="\\\\lhead{\\\\scriptsize{"$lhead"}}\n"
			rhead=$(whiptail --inputbox "Digite o que aparece à direita do cabeçalho" 8 78 UFRN 3>&1 1>&2 2>&3)
			output+="\\\\rhead{\\\\scriptsize{"$rhead"}}\n"
			output+="\\\\cfoot{\\\\scriptsize{Página \\\\thepage}}\n"
			header+="\\\\thispagestyle{empty}\n"
			header+="\\\\begin{center}\n"
			header+="\t\\\\Large $universidade\\\\\\\\\n"
			header+="\t\\\\large\\\\sc $dept \\\\\\\\*[0.1cm]\n"
			header+="\\\\end{center}\n"

		;;
		"criar")
			filecontent=""
			filecontent+="\\\\documentclass[$fontsize"pt",twoside,a4paper]{article}\n"
			filecontent+="$packages"
			filecontent+="$output"
			filecontent+="\n\\\\begin{document}\n"
			filecontent+="$header"
			filecontent+="$conteudo"
			filecontent+="\n\\\\end{document}\n"

			filename=$(whiptail --inputbox "Insira o nome do arquivo (sem .tex):" 8 78 3>&1 1>&2 2>&3)
			if [ -n "$filename" ]; then
				echo -e $filecontent > $filename".tex"
			fi
			exit
		;;
		"textoaleatorio")
			qtd=$(whiptail --inputbox "Quantos parágrafos?" 8 78 "20" 3>&1 1>&2 2>&3)
			for i in `seq 1 $qtd`; do
				conteudo+=$(tr -dc a-z1-4 </dev/urandom | tr 1-4 ' ' | fmt -u | head -c 300)"\n\n"
			done
		;;
		"imagemaleatoria")
			mx=320;my=256;head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- random.png
			packages+="\\\\usepackage[pdftex]{graphicx}\n"
			conteudo+="\\\\begin{figure}[h]\n\t\\\\centering\n\t\\\\includegraphics[width=0.25\\\\textwidth]{random.png}\n\t\\\\caption{a nice plot}\n\t\\\\label{fig:mesh1}\n\\\\end{figure}"
		;;
		"encerrar") exit
		;;
	esac
done


echo -e $output
