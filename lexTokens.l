%{
#include <stdio.h>//Headers for the generated C code
#include <stdlib.h>
#define YYSTYPE double
#include "y.tab.h"
extern YYSTYPE yylval;
void yyerror (char *s);
int yylex();
/*[0-9]+(.[0-9]+)?        yylval=strtof(yytext,NULL); return FLOAT;*/
%}

%% 

[0-9]+([.][0-9]+)?        yylval=strtof(yytext,NULL); return FLOAT;
"+"         return PLUSTOKEN;
"-"         return MINUSTOKEN;
"*"         return MULTIPLY;
"/"         return DIVIDE;
"("         return LEFT_PAR;
")"         return RIGHT_PAR;
"^"         return POW;
[ \t\n]     ;
";"         return END_EXP;
"quit"|"Quit"|"exit"|"Exit"      return QUIT;
.          yyerror("Error!Unrecognised Token\n");

%%
int yywrap (void) {return 1;}