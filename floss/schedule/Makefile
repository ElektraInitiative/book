schedule.pdf:table.tex schedule.tex
	latexmk -pdf schedule

table.tex:../FLOSS2022W.ics generate_tex.py
	./generate_tex.py

view:schedule.pdf
	okular schedule.pdf &

clean:
	rm schedule.aux schedule.fdb_latexmk schedule.fls schedule.log schedule.out schedule.pdf table.tex
