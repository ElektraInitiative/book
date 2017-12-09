benchmarkif.pdf benchmarkcmp.pdf benchmarkwith.pdf:calc.r
	R --no-save < calc.r
	rm -f Rplots.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../benchmarkif.pdf benchmarkif.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../benchmarkcmp.pdf benchmarkcmp.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../benchmarkwith.pdf benchmarkwith.pdf
	#okular benchmark*.pdf
