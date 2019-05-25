FILE=07

$(FILE).pdf:$(FILE).tex setup.tex
	latexmk $(FILE)

.PHONY:publish
publish:$(FILE).pdf
	cp $(FILE).pdf /home/markus/Projekte/Elektra/repos/ftp/slides/cm
	cd /home/markus/Projekte/Elektra/repos/ftp/slides/cm && git add $(FILE).pdf && git commit $(FILE).pdf && git push

.PHONY:errors
errors:
	grep "^.*:[0-9]*:" $(FILE).log

.PHONY:view
view:
	okular $(FILE).pdf

.PHONY:clean
clean:
	latexmk -c $(FILE)
	rm -f $(FILE).pdf
