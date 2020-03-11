%{
#include <stdio.h>
int yylex();
int yyerror(char *s);
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

%start start

%%

start: tINT tMAIN tPO tPF tAO body tAF
;

body: ligne tPV body 
| ligne tPV
;

ligne: expr
|tINT declaration {printf("declaration\n");}
|print {printf("print\n");}
| tRET tNBR {printf("retour\n");}
;

declaration: tVAR tV declaration
|tVAR
;

expr: tPO expr tPF
| expr tAFF expr {printf("affectation\n");}
| expr tADD expr {printf("addition\n");}
| expr tSUB expr {printf("soustraction\n");}
| expr tMUL expr {printf("multiplication\n");}
| expr tDIV expr {printf("division\n");}
| expr tMOD expr {printf("modulo\n");}
| tNBR
| tVAR 
;

print: tPRINTF tPO tVAR tPF
;

%%
int main()
{
 return(yyparse());
}
int yyerror(char *s)
{
fprintf(stderr, "%s\n", s) ;
return 0;
}
