RNW_FILE = dissertation.Rnw
RSCRIPT = Rscript

TEX_FILE = $(RNW_FILE:%.Rnw=%.tex)
PDF_FILE = $(TEX_FILE:%.tex=%.pdf)

default : doc clean

doc: $(PDF_FILE)

$(TEX_FILE): $(RNW_FILE)
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@")'

$(PDF_FILE): $(TEX_FILE)
	latexmk -pdf -xelatex -interaction=nonstopmode $(TEX_FILE)

clean :
	latexmk -c

fullclean :
	latexmk -C
