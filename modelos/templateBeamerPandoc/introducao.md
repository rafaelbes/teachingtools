---
title: "Introdução à disciplina"
author: "Rafael Beserra"
institute: "UFRN"
topic: "Introdução à disciplina"
fonttheme: "professionalfonts"
fontsize: 9pt
urlcolor: blue
linkstyle: bold
md_extensions: +fenced_divs
aspectratio: 169
output:
	beamer_presentation:
		keep_tex: true
header-includes:
	- \usepackage{amsfonts,amsmath,oldgerm}
	- \usetheme{ufrn}
---

# Seção número 1

## Subseção número 1

- Tal coisa
	- Subitem 1
	- Subitem 2

# Seção seguinte, a de número 2

## Mais outro slide

Conteúdo para este slide

- O template é um recurso da linguagem C++ para parametrizar tipo
```c++
//comentário
template <class T>
T maior(T a, T b) {
	return a > b ? a : b;
}

int main() {
	int ai = 3, bi = 4;
	string as = "primeiro", bs = "segundo";
	cout << maior<int>(ai, bi) << endl;
	cout << maior<string>(as, bs) << endl;
	return 0;
}
```


## Múltiplas colunas

::: columns
:::: column
Coluna 1
::::
:::: column
Coluna 2
::::
:::

## Tabela

Ano		Final Brasileira	Times							Colocação
----	----------------	------------------				---------
2004	São Paulo			HDD-1							10
							Future Team 3					16
2005	Ribeirão Preto		HDD1							4
							Jumenteam						12
2006	Rio de Janeiro		HDD-1 O desafio final			5
							Jumenteam						13
2007	Belo Horizonte		Jumenteam						23
2010	Joinville			Pigmeu xereta					14
2012	Londrina			Absurdo Clássico - Agora vai!	14

