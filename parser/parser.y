%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TAB_SYMB_SIZE 256
#define TAB_INST_SIZE 100

int yylex();
int yyerror(char *s);

typedef struct{
	int type; //0 = const, 1 = var
	char* name;
}champ;

char* tab_instructions[100]; //tableau contenant les instructions assembleurs, a mettre par la suite dans un fichier

int current_instruction = 0;

champ tab_symboles[TAB_SYMB_SIZE]; //table des symboles, en partant de la fin elle est utilisee pour les variables temporaires associe avec un pointeur de variable temporaire

int current_address = 0;

int pointeur_var_temp = TAB_SYMB_SIZE - 1;

int lignes_jmp[50];

int current_ligne;

void init_tab_instructions(){
	for(int i = 0; i < (TAB_INST_SIZE - 1); i++){
		tab_instructions[i] = "";
	}
}

void init_tab_symboles(){
	for(int i = 0; i < (TAB_SYMB_SIZE - 1); i++){
		tab_symboles[i].type = 1;
		tab_symboles[i].name = "";
	}
}

void add_instruction(char* inst){
	tab_instructions[current_instruction] = strdup(inst);
	current_instruction++;
}

void instructions_to_file(){
	FILE* asmFile =	fopen("test.asm","w");
	int num_instr = 0;
	do{
		fprintf(asmFile,tab_instructions[num_instr]);
		num_instr++;
	}while(tab_instructions[num_instr] != "");
	fclose(asmFile);
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
	for(int i = 0; i < (TAB_SYMB_SIZE - 1); i++){
		if(strcmp(tab_symboles[i].name, name) == 0){
			return i;		
		}
	}
	return -1;
}

int check_const(char* name){
	for(int i = 0; i < (TAB_SYMB_SIZE - 1); i++){
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
	pointeur_var_temp = TAB_SYMB_SIZE - 1;
}


void add_ligne_jmp(int ligne){
	lignes_jmp[current_ligne] = ligne;
	current_ligne++;
}

int get_ligne_jmp(){
	return lignes_jmp[current_ligne-1];
}

void free_ligne_jmp(){
	current_ligne--;
}

void patch_jmp(int ligne_jmp){
	char instruction[20];
	int ligne_instruction = get_ligne_jmp();
	sprintf(instruction,"%s %d\n", tab_instructions[ligne_instruction], ligne_jmp + 1); //+1 car instruction commence a l'indice 0
	tab_instructions[ligne_instruction] = strdup(instruction);
	free_ligne_jmp();
}
%}

%union {
	int nb;
	char* var;
}

%type <nb> expr
%type <nb> condition

%token tMAIN tINT tCONST tRET tIF tWHILE tELSE
%token tADD tSUB tDIV tMUL tAFF
%token tEQU tINF tSUP tDIF
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
| blocIf body 
| blocWhile body
|
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

declarationConstante: tCONST tINT tVAR tAFF expr 
	{add_const($3);
	int a = get_var($3);
	char instruction[20];
	sprintf(instruction,"COP %d %d\n", a, $5);
	add_instruction(instruction);
	free_temp(); // liberation des variables temporaires apres leur utilisation
	}
;


blocIf: tIF tPO condition tPF
	{add_ligne_jmp(current_instruction);
	char instruction[20];
	sprintf(instruction,"JMF %d", $3);
	add_instruction(instruction);
	}
tAO body tAF blocIfSuite
;

blocIfSuite: 
	{patch_jmp(current_instruction);
	}
|
	{patch_jmp(current_instruction + 1); //+1 pour sauter le prochain jmp (car bloc if else) et passer dans le bloc else
	add_ligne_jmp(current_instruction);
	char instruction[20];
	sprintf(instruction,"JMP");
	add_instruction(instruction);	
	}
tELSE tAO body tAF 
	{patch_jmp(current_instruction);
	}
;

blocWhile: tWHILE
	{add_ligne_jmp(current_instruction); //utilisation differente, on enregistre la ou on doit sauter au lieu de la ligne JMP
	}
tPO condition tPF 
	{add_ligne_jmp(current_instruction);
	char instruction[20];
	sprintf(instruction,"JMF %d", $4);
	add_instruction(instruction);
	}
tAO body tAF
	{patch_jmp(current_instruction + 1); //+1 pour sauter le prochain jmp
	char instruction[20];
	int ligne_to_jmp = get_ligne_jmp(); //on recupere la ou on doit sauter
	sprintf(instruction,"JMP %d\n", ligne_to_jmp + 1);
	add_instruction(instruction);
	free_ligne_jmp(); //on libere cette variable de saut
	}
;

condition: expr tEQU expr 
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"EQU %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| expr tINF expr
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"INF %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| expr tSUP expr
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"SUP %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| expr tDIF expr
;

affectation: tVAR tAFF expr 
	{int a = get_var($1);
	if(a == -1)
		{printf("ERREUR : variable %s non declaree\n",$1);}
	else{	
		if(check_const($1) == 1){
			printf("ERREUR : %s est une constante, elle ne peut pas changer de valeur\n",$1);
		}else{
			char instruction[20];
			sprintf(instruction,"COP %d %d\n", a, $3);
			add_instruction(instruction);
			free_temp(); // liberation des variables temporaires apres leur utilisation
		}		
	};}
;

expr: tPO expr tPF {$$ = $2;}
| expr tADD expr 
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"ADD %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| expr tSUB expr
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"SOU %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| expr tMUL expr
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"MUL %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| expr tDIV expr
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"DIV %d %d %d\n", a, $1, $3);
	add_instruction(instruction);
	$$ = a;
	}
| tNBR 
	{add_temp();
	int a = get_temp();
	char instruction[20];
	sprintf(instruction,"AFC %d %d\n", a, $1);
	add_instruction(instruction);
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
		char instruction[20];		
		sprintf(instruction,"PRI %d \n", a);
		add_instruction(instruction);
	};}
;

%%
int main()
{
init_tab_instructions();
init_tab_symboles();
int result = yyparse();
instructions_to_file();
 return result;
}
int yyerror(char *s)
{
fprintf(stderr, "%s\n", s) ;
return 0;
}
