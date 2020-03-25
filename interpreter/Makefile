all: interpreter
interpreter: y.tab.o lex.yy.o
	gcc -Wall y.tab.o lex.yy.o -o interpreter
y.tab.c: interpreter.y
	yacc -d interpreter.y
lex.yy.c: interpreter.l
	lex interpreter.l
clean: 
	rm lex.yy.* y.tab.* interpreter
