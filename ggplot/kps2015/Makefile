mean2.pdf wc.pdf:calc.r
	R --no-save < calc.r
	rm -f Rplots.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../mean2.pdf mean2.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../wc.pdf wc.pdf
	#okular mean2.pdf
	#okular *.pdf
