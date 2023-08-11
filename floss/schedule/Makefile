schedule.pdf:table.tex schedule.tex
	latexmk -pdf schedule

table.tex:../FLOSS2023W.ics generate_tex.py
	./generate_tex.py --year 2023 schedule.tex

view:schedule.pdf
	okular schedule.pdf &

clean:
	rm schedule.aux schedule.fdb_latexmk schedule.fls schedule.log schedule.out schedule.pdf table.tex
