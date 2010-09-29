CC             = @CC@
CXX            = @CXX@
CFLAGS         = @CFLAGS@
CPPFLAGS       = @CPPFLAGS@

files = identifier expression_list hash_literal array_literal		\
class_definition nested_class_definition message_send operator_send	\
assignment return require method_definition class_method_definition	\
operator_definition class_operator_definition block_literal		\
try_catch_block retry super ruby_args_literal self

src_files = $(foreach file, $(files), $(file).cc)
obj_files = $(foreach file, $(files), $(file).o)

all: $(obj_files)

identifier.o: identifier.cc
	$(CXX) $(CFLAGS) -c identifier.cc -o identifier.o

expression_list.o: expression_list.cc
	$(CXX) $(CFLAGS) -c expression_list.cc -o expression_list.o

hash_literal.o: hash_literal.cc
	$(CXX) $(CFLAGS) -c hash_literal.cc -o hash_literal.o

array_literal.o: array_literal.cc
	$(CXX) $(CFLAGS) -c array_literal.cc -o array_literal.o

class_definition.o: class_definition.cc
	$(CXX) $(CFLAGS) -c class_definition.cc -o class_definition.o

nested_class_definition.o: nested_class_definition.cc
	$(CXX) $(CFLAGS) -c nested_class_definition.cc -o nested_class_definition.o

message_send.o: message_send.cc
	$(CXX) $(CFLAGS) -c message_send.cc -o message_send.o

operator_send.o: operator_send.cc
	$(CXX) $(CFLAGS) -c operator_send.cc -o operator_send.o

assignment.o: assignment.cc
	$(CXX) $(CFLAGS) -c assignment.cc -o assignment.o

return.o: return.cc
	$(CXX) $(CFLAGS) -c return.cc -o return.o

require.o: require.cc
	$(CXX) $(CFLAGS) -c require.cc -o require.o

method_definition.o: method_definition.cc
	$(CXX) $(CFLAGS) -c method_definition.cc -o method_definition.o

class_method_definition.o: class_method_definition.cc
	$(CXX) $(CFLAGS) -c class_method_definition.cc -o class_method_definition.o

operator_definition.o: operator_definition.cc
	$(CXX) $(CFLAGS) -c operator_definition.cc -o operator_definition.o

class_operator_definition.o: class_operator_definition.cc
	$(CXX) $(CFLAGS) -c class_operator_definition.cc -o class_operator_definition.o

block_literal.o: block_literal.cc
	$(CXX) $(CFLAGS) -c block_literal.cc -o block_literal.o

try_catch_block.o: try_catch_block.cc
	$(CXX) $(CFLAGS) -c try_catch_block.cc -o try_catch_block.o

retry.o: retry.cc
	$(CXX) $(CFLAGS) -c retry.cc -o retry.o

super.o: super.cc
	$(CXX) $(CFLAGS) -c super.cc -o super.o

ruby_args_literal.o: ruby_args_literal.cc
	$(CXX) $(CFLAGS) -c ruby_args_literal.cc -o ruby_args_literal.o

self.o: self.cc
	$(CXX) $(CFLAGS) -c self.cc -o self.o

clean:
	rm -f *.o > /dev/null
