## Master file
RNW_FILE = defense_2015-01-14.Rnw
TEX_FILE = $(RNW_FILE:%.Rnw=%.tex)
PDF_FILE = $(TEX_FILE:%.tex=%.pdf)

# Need to set environment locale for knitr to work
export LC_ALL = en_US.UTF-8
export LC_CTYPE = en_US.UTF-8

## Programs

LATEXMK = latexmk
RSCRIPT = /Library/Frameworks/R.framework/Versions/3.2/Resources/bin/Rscript

## Rules

default : doc

doc: $(PDF_FILE)

$(TEX_FILE): $(RNW_FILE)
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@")'
$(PDF_FILE): $(TEX_FILE)
	latexmk -pdf -pdflatex='xelatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S' $(TEX_FILE)

fullclean :
	latexmk -C

.PRECIOUS: %.tex
