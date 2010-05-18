cc = g++
cc_flags = -g -Wall -ansi -pedantic

files = hash_literal array_literal class_definition message_send	\
operator_send assignment return require method_definition		\
class_method_definition operator_definition class_operator_definition	\
block_literal try_catch_block super

src_files = $(foreach file, $(files), $(file).cc)
obj_files = $(foreach file, $(files), $(file).o)

all: $(obj_files)

hash_literal.o: hash_literal.cc
	$(cc) $(cc_flags) -c hash_literal.cc -o hash_literal.o

array_literal.o: array_literal.cc
	$(cc) $(cc_flags) -c array_literal.cc -o array_literal.o

class_definition.o: class_definition.cc
	$(cc) $(cc_flags) -c class_definition.cc -o class_definition.o

message_send.o: message_send.cc
	$(cc) $(cc_flags) -c message_send.cc -o message_send.o

operator_send.o: operator_send.cc
	$(cc) $(cc_flags) -c operator_send.cc -o operator_send.o

assignment.o: assignment.cc
	$(cc) $(cc_flags) -c assignment.cc -o assignment.o

return.o: return.cc
	$(cc) $(cc_flags) -c return.cc -o return.o

require.o: require.cc
	$(cc) $(cc_flags) -c require.cc -o require.o

method_definition.o: method_definition.cc
	$(cc) $(cc_flags) -c method_definition.cc -o method_definition.o

class_method_definition.o: class_method_definition.cc
	$(cc) $(cc_flags) -c class_method_definition.cc -o class_method_definition.o

operator_definition.o: operator_definition.cc
	$(cc) $(cc_flags) -c operator_definition.cc -o operator_definition.o

class_operator_definition.o: class_operator_definition.cc
	$(cc) $(cc_flags) -c class_operator_definition.cc -o class_operator_definition.o

block_literal.o: block_literal.cc
	$(cc) $(cc_flags) -c block_literal.cc -o block_literal.o

try_catch_block.o: try_catch_block.cc
	$(cc) $(cc_flags) -c try_catch_block.cc -o try_catch_block.o

super.o: super.cc
	$(cc) $(cc_flags) -c super.cc -o super.o

clean:
	rm -f *.o > /dev/null
