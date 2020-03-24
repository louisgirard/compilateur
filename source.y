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

void add_var(char* name){ //ajoute une variable dans la table des symboles
	tab_symboles[current_address].type = 1;
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

declaration: tVAR tV declaration {add_var($1);}
|tVAR {add_var($1);}
;

affectation: tVAR tAFF expr 
	{int a = get_var($1);
	printf("COP %d %d\n", a, $3);
	free_temp(); // liberation des variables temporaires apres leur utilisation
	}
;

expr: tPO expr tPF {$$ = $2;}
| expr tADD expr 
	{add_temp();
	int a = get_temp();
	printf("ADD %d %d %d\n", a, $1, $3);
	$$ = a;
	}
| expr tSUB expr {printf("soustraction\n");}
| expr tMUL expr {printf("multiplication\n");}
| expr tDIV expr {printf("division\n");}
| expr tMOD expr {printf("modulo\n");}
| tNBR 
	{add_temp();
	int a = get_temp();
	printf("AFC %d %d\n", a, $1);
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
