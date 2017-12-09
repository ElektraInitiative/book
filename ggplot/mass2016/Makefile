benchmark.pdf:calc.r
	R --no-save < calc.r
	rm -f Rplots.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../benchmark.pdf benchmark.pdf
	#okular *.pdf
