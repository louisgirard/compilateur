all: comp
comp: y.tab.o lex.yy.o
	gcc -Wall y.tab.o lex.yy.o -o comp
y.tab.c: source.y
	yacc -d source.y
lex.yy.c: source.l
	lex source.l
clean: 
	rm lex.yy.* y.tab.* comp test.asm
