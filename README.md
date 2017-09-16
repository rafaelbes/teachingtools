# teachingtools

Esse repositório contém alguns arquivos que tenho usado nas disciplinas:

===================
corretor.sh
===================

É um script para compilar os códigos .c, rodá-los com vários casos de teste e escrever na tela os resultados.
O professor coloca no próprio script as questões, a entrada e a saída desejada no seguinte formato:
	avaliar 'q1' 'entrada' 'saida esperada'

1. Primeiramente o script verifica se q1.c existe. 
2. Caso exista, o script tenta converter o código para UTF-8.
3. Depois verifica se foi compilado com sucesso.
4. Em seguida, o script compila q1.c e compara a saída do programa com a saída esperada usando diff e flags wB.

A compilação é feita usando a flag -fsanitize=bounds (pode não estar disponível no seu sistema).
Ao final, o script exibe um sumário do número de caso de testes com sucesso e atribui uma nota (máximo 2).

Para o aluno basta colocar o script na mesma pasta onde estão os códigos-fonte e rodar com bash corretor.sh

===================
unzipStudents.sh
===================

Para ser usado em conjunto com corretor.sh. 
Com a pasta repleta de .zip, um para cada aluno, o script indaga primeiramente se gostaria de apagar o conteúdo das pastas.
Em seguida, descompacta o .zip de cada aluno em uma pasta específica para ele e copia também o script de correção.
Além disso, como alguns alunos criam um .zip de uma pasta, os arquivos dessa pasta são movidas para a pasta pai.
O script pode já ser executado assim que o conteúdo for descompactado, entretanto isso foi comentado no script.


===================
limpa.sh
===================

Esse script limpa todos os arquivos auxiliares do latex e pergunta ao usuário se gostaria de remover cada arquivo
que não tem nenhuma referência no .tex. Tem sido muito útil para manter as pastas limpas, pois com alterações e
movimentação entre pastas, o diretório latex costuma ficar bem cheio.
Um trecho do arquivo é exibido na tela durante a pergunta. É preciso ter certa
cautela pois pode ser por exemplo que haja um arquivo imagem.png e no .tex haja somente a referência por imagem.


===================
gerarPdf.sh
===================

Justamente para não ficar gerando lixo na pasta com os fontes do latex, esse script cria uma pasta output na
qual o pdflatex joga seus arquivos temporários, além de compilar e exibir com o evince o resultado.


===================
Organização das pastas
===================

Os arquivos gerarPdf.sh e limpa.sh deixo em /usr/local/bin/ com permissão para executar (chmod +x script.sh)
Todos os arquivos baixados para correção coloco em uma pasta chamada respostas.
Tenho um outro script que faz backup usando tar (tar --exclude=output --exclude=respostas --lzma)
lzma faz melhores compactações para o meu caso.
A opção de não incluir output e respostas serve para não incluir no backup o lixo do latex (e os pdfs), nem a
pasta com as respostas dos alunos.


