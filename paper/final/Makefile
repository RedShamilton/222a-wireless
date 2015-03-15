.PHONY: acreport.pdf

acreport.pdf: *.tex acreport.bbl acreport.bib
	pdflatex acreport.tex
	-if grep "undefined references" acreport.log; \
		then bibtex acreport; pdflatex acreport.tex; fi
	-if grep "may have changed" acreport.log; \
		then pdflatex acreport.tex; fi

acreport.bbl: acreport.bib
	pdflatex acreport.tex
	bibtex acreport
	pdflatex acreport.tex

spell:
	cat *.tex | aspell -a --add-filter=tex | grep -v \* | cut -d\  -f2 | sort | uniq | cat -s

clean:
	rm -f acreport.pdf acreport.bbl acreport.aux acreport.log acreport.blg acreport.out
