.PHONY: acproposal.pdf

acproposal.pdf: *.tex acproposal.bbl acproposal.bib
	pdflatex acproposal.tex
	-if grep "undefined references" acproposal.log; \
		then bibtex acproposal; pdflatex acproposal.tex; fi
	-if grep "may have changed" acproposal.log; \
		then pdflatex acproposal.tex; fi

acproposal.bbl: acproposal.bib
	pdflatex acproposal.tex
	bibtex acproposal
	pdflatex acproposal.tex

spell:
	cat *.tex | aspell -a --add-filter=tex | grep -v \* | cut -d\  -f2 | sort | uniq | cat -s

clean:
	rm -f acproposal.pdf acproposal.bbl acproposal.aux acproposal.log acproposal.blg acproposal.out
