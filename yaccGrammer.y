%{
// Global and header definitions required 
void yyerror (char *s);
int yylex();
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<math.h>
#define YYSTYPE double
%}

%token FLOAT
%token NUMBER
%token LEFT_PAR RIGHT_PAR
%token POW
%token MULTIPLY DIVIDE
%token PLUSTOKEN MINUSTOKEN
%token END_EXP
%token QUIT
%start line

%%

line:   QUIT
        {
            exit(0);
        }
        |
        addexpr END_EXP
        { 
            printf("%lf\n",$1);
            //printf("Non recursive\n");
        }
        |
        line addexpr END_EXP
        {  
            printf("%lf\n",$2);
            //printf("Recursive Expansion\n");
        }
        |
        line QUIT
        {
            exit(0);
        }
        ;

addexpr:    multexpr
            {
                $$ = $1;
            }
            |
            addexpr PLUSTOKEN multexpr
            {
                $$ = $1 + $3;
                //printf("%d\n",($1 + $3));
            }
            |
            addexpr MINUSTOKEN multexpr
            {
                $$ = $1 - $3;
                //printf("%d\n",($1 + $3));
            }
            ;

multexpr:   powexpr
            {
                $$ = $1;
            }
            |
            multexpr MULTIPLY powexpr
            {
                $$ = $1 * $3;
            }
            |
            multexpr DIVIDE powexpr
            {
                $$ = $1 / $3;
            }
            
            ;

powexpr:    paranthesis
            {
                $$ = $1;
            }
            |
            paranthesis POW powexpr
            {
                $$ = pow( $1, $3 );
            }
            ;

paranthesis:    LEFT_PAR addexpr RIGHT_PAR
                {
                    $$ = $2;
                }
                |
                floats
                {
                    $$ = $1;
                }
                ;

floats:     FLOAT
            {
                $$ = $1;
            }
            |
            MINUSTOKEN FLOAT
            {
                $$ = -$2;
            }
            ;

%%

int main(void)
{
    return yyparse();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}