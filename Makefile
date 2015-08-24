## Master file
RNW_FILE = dissertation.Rnw
TEX_FILE = $(RNW_FILE:%.Rnw=%.tex)
PDF_FILE = $(TEX_FILE:%.tex=%.pdf)

## Chapters
CHAP_ACW_ONSET_RNW = Financial_Markets_and_Onset_of_the_American_Civil_War.Rnw
CHAP_ACW_ONSET_TEX = $(CHAP_ACW_ONSET_RNW:%.Rnw=%.tex)
PATH_ACW_ONSET = ../acw_onset_and_markets/doc

CHAP_BONDS_BTL_RNW = Bonds_and_Battles.Rnw
CHAP_BONDS_BTL_TEX = $(CHAP_BONDS_BTL_RNW:%.Rnw=%.tex)
PATH_BONDS_BTL = ../bonds_and_battles/

## Programs

LATEXMK = latexmk
RSCRIPT = Rscript

## Rules

default : doc clean

doc: $(PDF_FILE)

$(TEX_FILE): $(RNW_FILE)
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@")'

$(PDF_FILE): $(TEX_FILE) acw_onset bonds_battles
	latexmk -pdf -xelatex -interaction=nonstopmode $(TEX_FILE)

acw_onset: $(CHAP_ACW_ONSET_TEX)

$(CHAP_ACW_ONSET_TEX): $(CHAP_ACW_ONSET_RNW)
	$(RSCRIPT) -e 'PROJECT_DIR <- "$(PATH_ACW_ONSET)"; knitr::knit("$<", output = "$@")'

bonds_battles: $(CHAP_BONDS_BTL_TEX)

$(CHAP_BONDS_BTL_TEX): $(CHAP_BONDS_BTL_RNW)
	$(RSCRIPT) -e 'PROJECT_ROOT <- "$(PATH_BONDS_BTL)"; knitr::knit("$<", output = "$@")'

updatebib:
	biber $(RNW_FILE:%.Rnw=%.bcf) --output_format bibtex
	mv $(RNW_FILE:%.Rnw=%_biber.bib) $(RNW_FILE:%.Rnw=%.bib)

clean :
	latexmk -c
	-rm -rf auto

fullclean :
	latexmk -C
