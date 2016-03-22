## Master file
RNW_FILE = changepoints.Rnw
TEX_FILE = $(RNW_FILE:%.Rnw=%.tex)
PDF_FILE = $(TEX_FILE:%.tex=%.pdf)
PATH_DLM = ./dlm-shrinkage

# Need to set environment locale for knitr to work
export LC_ALL = en_US.UTF-8
export LC_CTYPE = en_US.UTF-8

## Programs
LATEXMK = latexmk
RSCRIPT = Rscript

## Rules

default : doc 

doc: $(PDF_FILE)

$(TEX_FILE): $(RNW_FILE)
	$(RSCRIPT) -e 'PROJECT_ROOT <- "$(PATH_DLM)"; knitr::knit("$<", output = "$@")'

$(PDF_FILE): $(TEX_FILE)
	latexmk -pdf -pdflatex='xelatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S' $(TEX_FILE)

dlm: $(CHAP_DLM_TEX)


clean:
	latexmk -c $(TEX_FILE)
	-rm -rf auto

fullclean :
	latexmk -C

.PRECIOUS: %.tex
