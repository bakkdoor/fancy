cc = g++
cc_flags = -g -Wall -ansi -pedantic

parser_node_files = array_literal assignment return block_literal	\
class_definition hash_literal method_call operator_call			\
method_definition class_method_definition
parser_files = parser/lex parser/bison
bootstrap_files = core_classes object class block string number	\
console nil array file

files = fancy_object true nil hash array identifier symbol number	\
string native_method scope module class errors method regex		\
expression_list block utils file

src_files = $(foreach file, $(files), $(file).cc) 			\
$(foreach file, $(bootstrap_files), bootstrap/$(file).cc) 		\
$(foreach file, $(parser_files), $(file).c) 				\
$(foreach file, $(parser_node_files), parser/nodes/$(file).cc) main.cc

obj_files = $(foreach file, $(files), $(file).o) 			\
$(foreach file, $(bootstrap_files), bootstrap/$(file).o) 		\
$(foreach file, $(parser_files), $(file).o) 				\
$(foreach file, $(parser_node_files), parser/nodes/$(file).o) main.o

sub_dirs = parser bootstrap

all: subdirs ../bin/fancy

../bin/fancy: $(obj_files)
	@mkdir -p ../bin/
	$(cc) $(cc_flags) $(obj_files) -o ../bin/fancy -lfl -lgc -lgccpp

main.o: $(foreach file, $(src_files), $(file)) parser/fancy.lex parser/fancy.y
	$(cc) $(cc_flags) -c main.cc -o main.o

fancy_object.o: fancy_object.cc
	$(cc) $(cc_flags) -c fancy_object.cc -o fancy_object.o

true.o: true.cc
	$(cc) $(cc_flags) -c true.cc -o true.o

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

errors.o: errors.cc
	$(cc) $(cc_flags) -c errors.cc -o errors.o

method.o: method.cc
	$(cc) $(cc_flags) -c method.cc -o method.o

expression_list.o: expression_list.cc
	$(cc) $(cc_flags) -c expression_list.cc -o expression_list.o

block.o: block.cc
	$(cc) $(cc_flags) -c block.cc -o block.o

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
