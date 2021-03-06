## Master file
RNW_FILE = dissertation.Rnw
TEX_FILE = $(RNW_FILE:%.Rnw=%.tex)
PDF_FILE = $(TEX_FILE:%.tex=%.pdf)

## Chapters
CHAP_ACW_ONSET_RNW = Financial_Markets_and_Onset_of_the_American_Civil_War.Rnw
CHAP_ACW_ONSET_TEX = $(CHAP_ACW_ONSET_RNW:%.Rnw=%.tex)
#PATH_ACW_ONSET = ./acw_onset_and_markets/doc/
PATH_ACW_ONSET = ../acw_onset_and_markets/doc/

CHAP_BONDS_BTL_RNW = Bonds_and_Battles.Rnw
CHAP_BONDS_BTL_TEX = $(CHAP_BONDS_BTL_RNW:%.Rnw=%.tex)
PATH_BONDS_BTL = ./bonds_and_battles/
#PATH_BONDS_BTL = ../bonds_and_battles/

CHAP_DLM_RNW = changepoints.Rnw
CHAP_DLM_TEX = $(CHAP_DLM_RNW:%.Rnw=%.tex)
PATH_DLM = ./dlm-shrinkage

# Need to set environment locale for knitr to work
export LC_ALL = en_US.UTF-8
export LC_CTYPE = en_US.UTF-8

## Programs

LATEXMK = latexmk
RSCRIPT = Rscript

## Rules

default : doc

doc: $(PDF_FILE) abstract

abstract: abstract.txt

abstract.txt: abstract.tex
	pandoc -f latex -t plain -o $@ $^

$(TEX_FILE): $(RNW_FILE)
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@")'

$(PDF_FILE): $(TEX_FILE) acw_onset bonds_battles dlm
	latexmk -pdf -pdflatex='xelatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S' $(TEX_FILE)

acw_onset: $(CHAP_ACW_ONSET_TEX)

$(CHAP_ACW_ONSET_TEX): $(CHAP_ACW_ONSET_RNW)
	$(RSCRIPT) -e 'PROJECT_DIR <- "$(PATH_ACW_ONSET)"; knitr::knit("$<", output = "$@")'
	sed -E -i .bak -e 's/\\(eqref|ref|label)\{(sec|fig|eq|tab):([^}]+)\}/\\\1{acw_onset:\2:\3}/g' $@

bonds_battles: $(CHAP_BONDS_BTL_TEX)

$(CHAP_BONDS_BTL_TEX): $(CHAP_BONDS_BTL_RNW)
	$(RSCRIPT) -e 'PROJECT_ROOT <- "$(PATH_BONDS_BTL)"; knitr::knit("$<", output = "$@")'
	sed -E -i .bak -e 's/\\(eqref|ref|label)\{(seq|fig|eq|tab):([^}]+)\}/\\\1{bonds:\2:\3}/g' $@

dlm: $(CHAP_DLM_TEX)

$(CHAP_DLM_TEX): $(CHAP_DLM_RNW)
	$(RSCRIPT) -e 'PROJECT_ROOT <- "$(PATH_DLM)"; knitr::knit("$<", output = "$@")'
	sed -E -i .bak -e 's/\\(eqref|ref|label)\{(sec|fig|eq|tab):([^}]+)\}/\\\1{dlm:\2:\3}/g' $@

updatebib:
	biber $(RNW_FILE:%.Rnw=%.bcf) --output_format bibtex
	mv $(RNW_FILE:%.Rnw=%_biber.bib) $(RNW_FILE:%.Rnw=%.bib)

clean:
	latexmk -c $(TEX_FILE)
	-rm -rf auto
	-rm $(CHAP_ACW_ONSET_TEX)
	-rm $(CHAP_BONDS_BTL_TEX)
	-rm $(CHAP_DLM_TEX)

fullclean :
	latexmk -C

.PRECIOUS: %.tex


dlm-shrinkage-full.pdf: dlm-shrinkage-full.tex changepoints.tex
	latexmk -pdf -pdflatex='xelatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S' $<
