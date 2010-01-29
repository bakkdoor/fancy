cc = g++
cc_flags = -g -Wall -ansi -pedantic

parser_files = parser/lex parser/bison
files = object t nil hash array identifier number string scope errors method core_methods method_call regex assignment
src_files = $(foreach file, $(files), $(file).cc) $(foreach file, $(parser_files), $(file).c) main.cc
obj_files = $(foreach file, $(files), $(file).o) $(foreach file, $(parser_files), $(file).o) main.o

sub_dirs = common parser

all: subdirs ../bin/fancy

../bin/fancy: $(obj_files)
	$(cc) $(cc_flags) $(obj_files) -o ../bin/fancy -lfl -lgc -lgccpp

main.o: $(foreach file, $(src_files), $(file)) parser/fancy.lex parser/fancy.y
	$(cc) $(cc_flags) -c main.cc -o main.o

object.o: object.cc
	$(cc) $(cc_flags) -c object.cc -o object.o

t.o: t.cc
	$(cc) $(cc_flags) -c t.cc -o t.o

nil.o: nil.cc
	$(cc) $(cc_flags) -c nil.cc -o nil.o

hash.o: hash.cc
	$(cc) $(cc_flags) -c hash.cc -o hash.o

array.o: array.cc
	$(cc) $(cc_flags) -c array.cc -o array.o

regex.o: regex.cc
	$(cc) $(cc_flags) -c regex.cc -o regex.o

identifier.o: identifier.cc
	$(cc) $(cc_flags) -c identifier.cc -o identifier.o

number.o: number.cc
	$(cc) $(cc_flags) -c number.cc -o number.o

string.o: string.cc
	$(cc) $(cc_flags) -c string.cc -o string.o

scope.o: scope.cc
	$(cc) $(cc_flags) -c scope.cc -o scope.o

errors.o: errors.cc
	$(cc) $(cc_flags) -c errors.cc -o errors.o

method.o: method.cc
	$(cc) $(cc_flags) -c method.cc -o method.o

core_methods.o: core_methods.cc
	$(cc) $(cc_flags) -c core_methods.cc -o core_methods.o

method_call.o: method_call.cc
	$(cc) $(cc_flags) -c method_call.cc -o method_call.o

assignment.o: assignment.cc
	$(cc) $(cc_flags) -c assignment.cc -o assignment.o


subdirs:
	$(foreach dir, $(sub_dirs), cd $(dir) && make && cd ..;)

clean:
	cd parser && make clean > /dev/null
	rm -f *.o > /dev/null
