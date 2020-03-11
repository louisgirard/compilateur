%{
#include <stdio.h>

%}

%token tMAIN tINT tCONST tRET 
%token tADD tSUB tDIV tMUL tMOD tAFF
%token tPO tPF tAO tAF
%token tPRINTF
%token tNBR
%token tVAR
%token tV tPV

%right tAFF
%left tADD tSUB
%left tDIV tMUL tMOD

%%
expr : expr tAFF expr
| expr tADD expr
| expr tSUB expr
| expr tMUL expr
| expr tDIV expr
| expr tMOD expr
| tNBR
| tVAR
;

%%
main()
{
 return(yyparse());
}
yyerror(char *s)
{
fprintf(stderr, "%s\n", s) ;
}
