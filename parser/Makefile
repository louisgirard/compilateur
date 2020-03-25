all: parser
parser: y.tab.o lex.yy.o
	gcc -Wall y.tab.o lex.yy.o -o parser
y.tab.c: parser.y
	yacc -d parser.y
lex.yy.c: parser.l
	lex parser.l
clean: 
	rm lex.yy.* y.tab.* parser test.asm
