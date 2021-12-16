
all::

.PHONY: all pdf FORCE_MAKE
all pdf:: isi_facilities.pdf

%.pdf: %.tex FORCE_MAKE
	latexmk -pdf $<

clean::
	latexmk -c



