%{
#include "y.tab.h"
%}

%%
"int" return tINT;
"const" return tCONST;
"main" return tMAIN;
"return" return tRET;
"if" return tIF;
"while" return tWHILE;
"else" return tELSE;
"+" return tADD;
"-" return tSUB;
"/" return tDIV;
"*" return tMUL;
"=" return tAFF;
"==" return tEQU;
"<" return tINF;
">" return tSUP;
"!=" return tDIF;
"{" return tAO;
"}" return tAF;
"(" return tPO;
")" return tPF;
"printf" return tPRINTF;
[0-9]+ yylval.nb = atoi(yytext); return tNBR;
[a-zA-Z][a-zA-Z0-9_]* yylval.var = strdup(yytext); return tVAR;
";" return tPV;
"," return tV;
[ ]+ ;
[\t]+ ;
[\n]+ ;
%%
int yywrap(void){}

