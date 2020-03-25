%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TAB_SIZE 256

int yylex();
int yyerror(char *s);

typedef struct{
	int type; //0 = const, 1 = var
	char* name;
}champ;

champ tab_symboles[TAB_SIZE]; //table des symboles, en partant de la fin elle est utilisee pour les variables temporaires associe avec un pointeur de variable temporaire

int current_address = 0;

int pointeur_var_temp = TAB_SIZE - 1;

void init_tab_symboles(){
	for(int i = 0; i < (TAB_SIZE - 1); i++){
		tab_symboles[i].type = 1;
		tab_symboles[i].name = "";
	}
}

void add_var(char* name){ //ajoute une variable dans la table des symboles
	tab_symboles[current_address].type = 1;
	tab_symboles[current_address].name = strdup(name);
	current_address++;
}

void add_const(char* name){ //ajoute une constante dans la table des symboles
	tab_symboles[current_address].type = 0;
	tab_symboles[current_address].name = strdup(name);
	current_address++;
}

int get_var(char* name){ //retourne l'adresse de la variable (sa position dans le tableau)
	for(int i = 0; i < (TAB_SIZE - 1); i++){
		if(strcmp(tab_symboles[i].name, name) == 0){
			return i;		
		}
	}
	return -1;
}

int check_const(char* name){
	for(int i = 0; i < (TAB_SIZE - 1); i++){
		if(strcmp(tab_symboles[i].name, name) == 0){
			if(tab_symboles[i].type == 0){
				return 1;
			}	
		}
	}
	return 0;
}

void add_temp(){ //ajoute une variable dans la table des symboles
	tab_symboles[pointeur_var_temp].type = 1;
	tab_symboles[pointeur_var_temp].name = "temp";
	pointeur_var_temp--;
}

int get_temp(){
	return (pointeur_var_temp+1);
}

void free_temp(){
	pointeur_var_temp = TAB_SIZE - 1;
}

FILE* asmFile;

%}

%union {
	int nb;
	char* var;
}

%type <nb> expr

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
compteur pour les variables temporaires, penser a liberer la memoire !!!
*/

%%

start: tINT tMAIN tPO tPF tAO body tAF {fclose(asmFile);}
;

body: ligne tPV body 
| ligne tPV
;

ligne: expr
|tINT declaration
|declarationConstante
|print
|affectation
|tRET tNBR {printf("retour\n");}
;

declaration: tVAR tV declaration {add_var($1);}
|tVAR {add_var($1);}
;

declarationConstante: tCONST tINT tVAR tAFF expr {add_const($3);}
;

affectation: tVAR tAFF expr 
	{int a = get_var($1);
	if(a == -1)
		{printf("ERREUR : variable %s non declaree\n",$1);}
	else{	
		if(check_const($1) == 1){
			printf("ERREUR : %s est une constante, elle ne peut pas changer de valeur\n",$1);
		}else{
			fprintf(asmFile,"COP %d %d\n", a, $3);
			free_temp(); // liberation des variables temporaires apres leur utilisation
		}		
	};}
;

expr: tPO expr tPF {$$ = $2;}
| expr tADD expr 
	{add_temp();
	int a = get_temp();
	fprintf(asmFile,"ADD %d %d %d\n", a, $1, $3);
	$$ = a;
	}
| expr tSUB expr
	{add_temp();
	int a = get_temp();
	fprintf(asmFile,"SOU %d %d %d\n", a, $1, $3);
	$$ = a;
	}
| expr tMUL expr
	{add_temp();
	int a = get_temp();
	fprintf(asmFile,"MUL %d %d %d\n", a, $1, $3);
	$$ = a;
	}
| expr tDIV expr
	{add_temp();
	int a = get_temp();
	fprintf(asmFile,"DIV %d %d %d\n", a, $1, $3);
	$$ = a;
	}
| expr tMOD expr {printf("modulo\n");}
| tNBR 
	{add_temp();
	int a = get_temp();
	fprintf(asmFile,"AFC %d %d\n", a, $1);
	$$ = a;
	}
| tVAR 
	{int a = get_var($1);
	if(a == -1)
		{printf("ERREUR : variable %s non declaree\n",$1);}
	else{			
		$$ = a;
	};}
;

print: tPRINTF tPO tVAR tPF
	{int a = get_var($3);
	if(a == -1)
		{printf("ERREUR : variable %s non declaree\n",$3);}
	else{			
		fprintf(asmFile,"PRI %d \n", a);
	};}
;

%%
int main()
{
asmFile = fopen("test.asm","w");
init_tab_symboles();
 return(yyparse());
}
int yyerror(char *s)
{
fprintf(stderr, "%s\n", s) ;
return 0;
}
