.PHONY: acprogress.pdf

acprogress.pdf: *.tex acprogress.bbl acprogress.bib
	pdflatex acprogress.tex
	-if grep "undefined references" acprogress.log; \
		then bibtex acprogress; pdflatex acprogress.tex; fi
	-if grep "may have changed" acprogress.log; \
		then pdflatex acprogress.tex; fi

acprogress.bbl: acprogress.bib
	pdflatex acprogress.tex
	bibtex acprogress
	pdflatex acprogress.tex

spell:
	cat *.tex | aspell -a --add-filter=tex | grep -v \* | cut -d\  -f2 | sort | uniq | cat -s

clean:
	rm -f acprogress.pdf acprogress.bbl acprogress.aux acprogress.log acprogress.blg acprogress.out
