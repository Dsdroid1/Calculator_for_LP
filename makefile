all: Calculator_int

Calculator_int: y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -o Calculator_int -lm	

y.tab.c: yaccGrammer.y
	yacc -d yaccGrammer.y

lex.yy.c: y.tab.c lexTokens.l
	flex lexTokens.l

clean:
	rm -rf lex.yy.c y.tab.c y.tab.h Calculator_int