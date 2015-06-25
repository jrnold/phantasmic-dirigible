MAIN_DOC=dissertation.tex

default : doc clean

doc :
	latexmk -pdf -xelatex -interaction=nonstopmode  ${MAIN_DOC}

clean :
	latexmk -c

fullclean :
	latexmk -C
