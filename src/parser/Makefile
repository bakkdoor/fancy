# Makefile

OBJS	= bison.o lex.o parser.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic

sub_dirs = nodes

all:		subdirs $(OBJS)

lex.o:		lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:		fancy.lex
		flex fancy.lex
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	fancy.y
		bison -d -v fancy.y
		cp fancy.tab.c bison.c
		cmp -s fancy.tab.h tok.h || cp fancy.tab.h tok.h

lex.o yac.o	: includes.h ../includes.h
lex.o		: tok.h

parser.o 	: parser.cc
		$(CC) $(CFLAGS) -c parser.cc -o parser.o

subdirs:
	$(foreach dir, $(sub_dirs), cd $(dir) && make && cd ..;)

clean:
	cd nodes && make clean > /dev/null
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h fancy.tab.c fancy.tab.h fancy.output

