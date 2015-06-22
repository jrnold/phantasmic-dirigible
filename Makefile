MAIN_DOC=dissertation.tex

default : doc clean

doc :
	latexmk -xelatex -quiet ${MAIN_DOC}

clean :
	latexmk -c

fullclean :
	latexmk -C
