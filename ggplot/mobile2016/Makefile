lock.pdf switch.pdf:calc.r
	R --no-save < calc.r
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../lockmobile.pdf lock.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=../switchmobile.pdf switch.pdf
	#mv lock.pdf ../lockmobile.pdf
	#mv switch.pdf ../switchmobile.pdf
