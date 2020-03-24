%{
#include <stdio.h>
int yylex();
int yyerror(char *s);
%}

%union {
	int nb;
	char* var;
}

%token tMAIN tINT tCONST tRET 
%token tADD tSUB tDIV tMUL tMOD tAFF
%token tPO tPF tAO tAF
%token tPRINTF
%token <nb> tNBR
%token <var> tVAR
%token tV tPV

%right tAFF
%left tADD tSUB
%left tDIV tMUL tMOD

%start start

/* tableau de constantes et variables declarees:
 var/const, identifiant, adresse = ligne dans le tableau, int / float,
 fonction pour recuperer l' adresse(ligne)
 %type pour les regles qui retournent une valeur 
*/

%%

start: tINT tMAIN tPO tPF tAO body tAF
;

body: ligne tPV body 
| ligne tPV
;

ligne: expr
|tINT declaration {printf("declaration\n");}
|print {printf("print\n");}
|affectation {printf("affectation\n");}
|tRET tNBR {printf("retour\n");}
;

declaration: tVAR tV declaration
|tVAR
;

affectation: tVAR tAFF expr 
;

expr: tPO expr tPF
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
