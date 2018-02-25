#Default Target
.PHONY:all
all:elektra.pdf

.PHONY:rebuild
rebuild:clean all

.PHONY:errors
errors:
	grep "^.*:[0-9]*:" elektra.log

.PHONY:clean
clean:
	latexmk -c elektra

texfiles=*.tex

elektra.pdf:${texfiles} ../shared/elektra.bib
	latexmk -pdf elektra
