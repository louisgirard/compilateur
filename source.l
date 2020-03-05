%%
[0-9]+     printf("entier ");
[a-zA-Z]+  printf("mot ");

%%
int yywrap(void){}

int main(void){
	printf("Début\n");
	yylex();
	return 0;
}