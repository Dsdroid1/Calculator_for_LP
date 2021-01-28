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
    printf("Assignment 1-Language Processors,by BT18CSE046\n");
    printf("Some info about this program\n");
    printf("This is a calculator made using lex/yacc to parse an equation and print it's output\n");
    printf("The supported operations are +,-,*,/,^(power) and the use of paranthesis\n");
    printf("The precedence of operators is (),^,*==/,+==-\n");
    printf("The datatype supported is double\n");
    printf("Any numeric expression that has to be calculated should end with ';' as a delimiter\n");
    printf("By choice,the power operator will be evaluated from right to left\n");
    printf("All other operators go from left to right");
    printf("To end this program,type 'exit' or 'quit'\n");
    printf("With all this info,you are ready to use this calculator!\n");

    return yyparse();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}