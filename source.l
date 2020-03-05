%%
"int" printf("type_int");
"const" printf("constante");
"main" printf("un_main");
"+" printf("add");
"-" printf("sub");
"/" printf("div");
"*" printf("mul");
"=" printf("aff");
"{" printf("acc_ouv");
"}" printf("acc_ferm");
"(" printf("par_ouv");
")" printf("par_ferm");
"printf" printf("printception");
[0-9]+     printf("entier");
[a-zA-Z][a-zA-Z0-9_]+ printf("var");
";" printf("pv");
[ ]+ printf(" espace ");
[\t]+ printf("tab");
"," printf("vir");
[\n]+ printf("rchar\n");
"return" printf("retour");

%%
int yywrap(void){}

int main(void){
	yylex();
	return 0;
}
