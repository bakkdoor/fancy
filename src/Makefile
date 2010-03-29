cc = g++
cc_flags = -g -Wall -ansi -pedantic

parser_files = parser/lex parser/bison
bootstrap_files = core_classes object block string number console nil array

files = native_object true nil hash hash_literal array array_literal	\
identifier symbol number string native_method scope module class	\
class_definition fancy_object errors method method_call operator_call	\
regex assignment method_definition expression_list block block_literal	\
utils file

src_files = $(foreach file, $(files), $(file).cc) $(foreach file, $(bootstrap_files), bootstrap/$(file).cc) $(foreach file, $(parser_files), $(file).c) main.cc
obj_files = $(foreach file, $(files), $(file).o) $(foreach file, $(bootstrap_files), bootstrap/$(file).o) $(foreach file, $(parser_files), $(file).o) main.o

sub_dirs = parser bootstrap

all: subdirs ../bin/fancy

../bin/fancy: $(obj_files)
	@mkdir -p ../bin/
	$(cc) $(cc_flags) $(obj_files) -o ../bin/fancy -lfl -lgc -lgccpp

main.o: $(foreach file, $(src_files), $(file)) parser/fancy.lex parser/fancy.y
	$(cc) $(cc_flags) -c main.cc -o main.o

native_object.o: native_object.cc
	$(cc) $(cc_flags) -c native_object.cc -o native_object.o

true.o: true.cc
	$(cc) $(cc_flags) -c true.cc -o true.o

nil.o: nil.cc
	$(cc) $(cc_flags) -c nil.cc -o nil.o

hash.o: hash.cc
	$(cc) $(cc_flags) -c hash.cc -o hash.o

hash_literal.o: hash_literal.cc
	$(cc) $(cc_flags) -c hash_literal.cc -o hash_literal.o

array.o: array.cc
	$(cc) $(cc_flags) -c array.cc -o array.o

array_literal.o: array_literal.cc
	$(cc) $(cc_flags) -c array_literal.cc -o array_literal.o

regex.o: regex.cc
	$(cc) $(cc_flags) -c regex.cc -o regex.o

identifier.o: identifier.cc
	$(cc) $(cc_flags) -c identifier.cc -o identifier.o

symbol.o: symbol.cc
	$(cc) $(cc_flags) -c symbol.cc -o symbol.o

number.o: number.cc
	$(cc) $(cc_flags) -c number.cc -o number.o

string.o: string.cc
	$(cc) $(cc_flags) -c string.cc -o string.o

native_method.o: native_method.cc
	$(cc) $(cc_flags) -c native_method.cc -o native_method.o

scope.o: scope.cc
	$(cc) $(cc_flags) -c scope.cc -o scope.o

module.o: module.cc
	$(cc) $(cc_flags) -c module.cc -o module.o

class.o: class.cc
	$(cc) $(cc_flags) -c class.cc -o class.o

class_definition.o: class_definition.cc
	$(cc) $(cc_flags) -c class_definition.cc -o class_definition.o

fancy_object.o: fancy_object.cc
	$(cc) $(cc_flags) -c fancy_object.cc -o fancy_object.o

errors.o: errors.cc
	$(cc) $(cc_flags) -c errors.cc -o errors.o

method.o: method.cc
	$(cc) $(cc_flags) -c method.cc -o method.o

method_call.o: method_call.cc
	$(cc) $(cc_flags) -c method_call.cc -o method_call.o

operator_call.o: operator_call.cc
	$(cc) $(cc_flags) -c operator_call.cc -o operator_call.o

assignment.o: assignment.cc
	$(cc) $(cc_flags) -c assignment.cc -o assignment.o

method_definition.o: method_definition.cc
	$(cc) $(cc_flags) -c method_definition.cc -o method_definition.o

expression_list.o: expression_list.cc
	$(cc) $(cc_flags) -c expression_list.cc -o expression_list.o

block.o: block.cc
	$(cc) $(cc_flags) -c block.cc -o block.o

block_literal.o: block_literal.cc
	$(cc) $(cc_flags) -c block_literal.cc -o block_literal.o

utils.o: utils.cc
	$(cc) $(cc_flags) -c utils.cc -o utils.o

file.o: file.cc
	$(cc) $(cc_flags) -c file.cc -o file.o

subdirs:
	$(foreach dir, $(sub_dirs), cd $(dir) && make && cd ..;)

clean:
	cd parser && make clean > /dev/null
	cd bootstrap && make clean > /dev/null
	rm -f *.o > /dev/null
