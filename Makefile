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

CHAP_DLM_RNW = Structural_Breaks.Rnw
CHAP_DLM_TEX = $(CHAP_DLM_RNW:%.Rnw=%.tex)
PATH_DLM = ../dlm-shrinkage


## Programs

LATEXMK = latexmk
RSCRIPT = Rscript

## Rules

default : doc

doc: $(PDF_FILE)

$(TEX_FILE): $(RNW_FILE)
	$(RSCRIPT) -e 'knitr::knit("$<", output = "$@")'

$(PDF_FILE): $(TEX_FILE) acw_onset bonds_battles dlm
	latexmk -pdf -xelatex -interaction=nonstopmode $(TEX_FILE)

acw_onset: $(CHAP_ACW_ONSET_TEX)

$(CHAP_ACW_ONSET_TEX): $(CHAP_ACW_ONSET_RNW)
	$(RSCRIPT) -e 'PROJECT_DIR <- "$(PATH_ACW_ONSET)"; knitr::knit("$<", output = "$@")'
	sed -E -i .bak -e 's/\{(sec|eq|fig|tab):([^}]+)/{acw_onset:\1:\2/g' $@

bonds_battles: $(CHAP_BONDS_BTL_TEX)

$(CHAP_BONDS_BTL_TEX): $(CHAP_BONDS_BTL_RNW)
	$(RSCRIPT) -e 'PROJECT_ROOT <- "$(PATH_BONDS_BTL)"; knitr::knit("$<", output = "$@")'
	sed -E -i .bak -e 's/\{(sec|eq|fig|tab):([^}]+)/{bonds_battles:\1:\2/g' $@

dlm: $(CHAP_DLM_TEX)

$(CHAP_DLM_TEX): $(CHAP_DLM_RNW)
	$(RSCRIPT) -e 'PROJECT_ROOT <- "$(PATH_DLM)"; knitr::knit("$<", output = "$@")'
	sed -E -i .bak -e 's/\{(sec|eq|fig|tab):([^}]+)/{dlm:\1:\2/g' $@


updatebib:
	biber $(RNW_FILE:%.Rnw=%.bcf) --output_format bibtex
	mv $(RNW_FILE:%.Rnw=%_biber.bib) $(RNW_FILE:%.Rnw=%.bib)

clean:
	latexmk -c $(TEX_FILE)
	-rm -rf auto
	-rm $(CHAP_ACW_ONSET_TEX)
	-rm $(CHAP_BONDS_BTL_TEX)
	-rm $(CHAP_DLM_TEX)

fullclen :
	latexmk -C

.PRECIOUS: %.tex
