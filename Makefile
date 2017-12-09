#Default Target
.PHONY:all
all:book/book.pdf

.PHONY:rebuild
rebuild:clean all

.PHONY:errors
errors:
	grep "^.*:[0-9]*:" elektra.log

texfiles=*.tex

book/book.pdf:${texfiles} elektra.bib
	latexmk -pdf elektra
	mv elektra.pdf book/book.pdf
	mv elektra.synctex.gz book/book.synctex.gz
