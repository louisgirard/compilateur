%{
#include "y.tab.h"
%}

%%
"ADD" return tADD;
"MUL" return tMUL;
"SOU" return tSOU;
"DIV" return tDIV;
"COP" return tCOP;
"AFC" return tAFC;
"JMP" return tJMP;
"JMF" return tJMF;
"INF" return tINF;
"SUP" return tSUP;
"EQU" return tEQU;
"PRI" return tPRI;
[0-9]+ yylval.nb = atoi(yytext); return tNBR;
[ ]+ ;
[\t]+ ;
[\n]+ ;
%%
int yywrap(void){}

