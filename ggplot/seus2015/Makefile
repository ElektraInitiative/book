piweb.pdf lock.pdf switch.pdf lookup.pdf:calc.r
	R --no-save < calc.r
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../lookup.pdf lookup.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../switch.pdf switch.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../lock.pdf lock.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../piweb.pdf piweb.pdf
	rm -f Rplots.pdf
	#okular *.pdf
