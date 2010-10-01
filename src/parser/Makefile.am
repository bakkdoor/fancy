SUBDIRS = nodes

CC             = @CC@
CXX             = @CXX@
CFLAGS         = @CFLAGS@
CPPFLAGS       = @CPPFLAGS@

obj_files	= bison.o lex.o parser.o

all:		$(obj_files)

lex.o:		lex.c
		$(CXX) $(CFLAGS) -c lex.c -o lex.o

lex.c:		fancy.lex
		flex fancy.lex
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CXX) $(CFLAGS) -c bison.c -o bison.o

bison.c:	fancy.y
		bison -d -v fancy.y
		cp fancy.tab.c bison.c
		cmp -s fancy.tab.h tok.h || cp fancy.tab.h tok.h

lex.o yac.o	: includes.h
lex.o		: tok.h

parser.o 	: parser.cc
		$(CXX) $(CFLAGS) -c parser.cc -o parser.o

clean:
	cd nodes && make clean > /dev/null
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h fancy.tab.c fancy.tab.h fancy.output

