%%
"int" return tINT;
"const" return tCONST;
"main" return tMAIN;
"return" return tRET;
"+" return tADD;
"-" return tSUB;
"/" return tDIV;
"*" return tMUL;
"%" return tMOD;
"=" return tAFF;
"{" return tPO;
"}" return tPF;
"(" return tAO;
")" return tAF;
"printf" return tPRINTF
[0-9]+ return tNBR;
[a-zA-Z][a-zA-Z0-9_]+ printf("var");
";" printf("pv");
"," printf("vir");
[ ]+ ;
[\t]+ ;
[\n]+ ;

%%
int yywrap(void){}

/*int main(void){
	yylex();
	return 0;
}*/
