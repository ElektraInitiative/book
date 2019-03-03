FILE=00

$(FILE).pdf:$(FILE).tex setup.tex
	latexmk $(FILE)

.PHONY:errors
errors:
	grep "^.*:[0-9]*:" $(FILE).log

.PHONY:clean
clean:
	latexmk -c $(FILE)
	rm -f $(FILE).pdf
