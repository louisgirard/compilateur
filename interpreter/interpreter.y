%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex();
int yyerror(char *s);



%}

%union {
	int nb;
}


%token tADD tMUL tSOU tDIV tCOP tAFC tJMP tJMF tINF tSUP tEQU tPRI 

%start start

%%

start:
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
