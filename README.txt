--Regarding the grammer productions
The grammer is based on a simple concept.
addexpr -> multexpr is the first rule,yacc will always try to fit in the first rule,
if it fails then it tries the next rule.

Thus,just by the above production,we have assigned a higher prioirity to multexpr.
Then adding addexpr -> addexpr+multexpr,this makes the rule left associative i.e,l to r evaluation
as 1+2+3 will be considered as (1+2)+3,where the lone 3 will be the FLOAT token reached via the path,
addexpr->addexpr + multexpr.......................(1)
the multexpr-> powexpr, powexpr->paranthesis, paranthesis->FLOAT.
And the addexpr part of the RHS of eq (1) is evaluated as,
addexpr->addexpr+multexpr,where the multexpr is evaluated in similar way for number '2',
and the rhs addexpr -> multexpr ,which is evaluated similarly for '1'.
Therefore,1+2+3->(1+2)+3
Similarly,1+2+3+4->(1+2+3)+4->((1+2)+3)+4
Thus,we can see how the rule order specifies the expansion criteria.

This is because the split addexpr as 1 and multexpr as 2+3 cannot be evaluated by any rule of multexpr,
that is multexpr cant be used to add!.Thus the only possible split remains separating it out from the right end,
essentially creating left to right associativity.
Diagramatically,
1+2+3->1+(2+3) will lead to addexpr=1,multexpr=2+3
But there is no production involving '+' for multexpr.
However,multexpr can lead to addition,but only when paranthesis are present,as paranthesis has a production linkg back to addexpr.
This allows us to effectively implement expression paranthesiation,as,
1+(2+3)->1{addexpr}+(2+3){multexpr}
(2+3)->powexpr->paranthesis-> ({LEFT_PAR}, 2+3{addexpr}, ){RIGHT_PAR}.


Also,we can notice the order is inverted for powexpr,this is by choice.
i.e, 2^3^4->2^(3^4) and not (2^3)^4 .....[Note that this is a design choice],
thus powexpr->paranthesis^powexpr,which will lead to similar expansion as above,but from r to l.
The addexpr->multexpr precedence is nested at every level to form a hierarchy,that is,
addexpr->multexpr->powexpr->paranthesis and finally -> floats.
This helps in evaluating precedence with minial effort.

--Regarding FLOAT
Normally,yylval is of type INT,but it can be used as char via union.
However ,since we required FLOAT to be the datatype for calculator,we have to 
redefine YYSTYPE as the type of yylval(This can be used to define yylval as a struct,essentially passing
more data)
In our case,since we just require FLOAT as the type,we simply write
#define YYSTYPE double
in both .l and .y files(essentially via aseparate header if using structs)
This defination should be before the y.tab.h header,as it checks for 'if define YYSTYPE' and if not ,sets it to 'int'

--Most other part is self explanatory