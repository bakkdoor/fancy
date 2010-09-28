SUBDIRS = bootstrap parser

CC             = @CC@
CXX             = @CXX@
CFLAGS         = @CFLAGS@
CPPFLAGS       = @CPPFLAGS@

parser_node_files = identifier \
		expression_list \
		array_literal \
		assignment \
		return \
		require \
		block_literal  \
		class_definition \
		nested_class_definition  \
		hash_literal \
		message_send  \
		operator_send \
		method_definition \
		class_method_definition \
		operator_definition \
		class_operator_definition \
		try_catch_block \
		super \
		ruby_args_literal \
		self

parser_files = parser/lex \
		parser/bison

bootstrap_files = core_classes \
		object \
		class \
		block  \
		string  \
		number	\
		console  \
		array  \
		file  \
		directory \
		scope \
		hash \
		error \
		method \
		system

files = fancy_object \
	true \
	nil \
	hash \
	array \
	symbol \
	number \
	string \
	native_method \
	scope \
	lexical_scope \
	class_scope \
	class \
	errors \
	method \
	regexp \
	block \
	utils \
	file \
	directory \
	fancy_exception \
	callable

src_files = $(foreach file, $(files), $(file).cc) \
	$(foreach file, $(bootstrap_files), bootstrap/$(file).cc) \
	$(foreach file, $(parser_files), $(file).c) parser/parser.cc \
	$(foreach file, $(parser_node_files), parser/nodes/$(file).cc) main.cc

obj_files = $(foreach file, $(files), $(file).o) \
	$(foreach file, $(bootstrap_files), bootstrap/$(file).o) \
	$(foreach file, $(parser_files), $(file).o) parser/parser.o \
	$(foreach file, $(parser_node_files), parser/nodes/$(file).o) main.o

all: ../bin/fancy

../bin/fancy: $(obj_files)
	@mkdir -p ../bin/
	$(CXX) $(CFLAGS) $(obj_files) ../vendor/gc/.libs/libgccpp.a ../vendor/gc/.libs/libgc.a -o ../bin/fancy -lfl

main.o: $(foreach file, $(src_files), $(file)) parser/fancy.lex parser/fancy.y
	$(CXX) $(CFLAGS) -c main.cc -o main.o

fancy_object.o: fancy_object.cc
	$(CXX) $(CFLAGS) -c fancy_object.cc -o fancy_object.o

true.o: true.cc
	$(CXX) $(CFLAGS) -c true.cc -o true.o

nil.o: nil.cc
	$(CXX) $(CFLAGS) -c nil.cc -o nil.o

hash.o: hash.cc
	$(CXX) $(CFLAGS) -c hash.cc -o hash.o

array.o: array.cc
	$(CXX) $(CFLAGS) -c array.cc -o array.o

regexp.o: regexp.cc
	$(CXX) $(CFLAGS) -c regexp.cc -o regexp.o

symbol.o: symbol.cc
	$(CXX) $(CFLAGS) -c symbol.cc -o symbol.o

number.o: number.cc
	$(CXX) $(CFLAGS) -c number.cc -o number.o

string.o: string.cc
	$(CXX) $(CFLAGS) -c string.cc -o string.o

native_method.o: native_method.cc
	$(CXX) $(CFLAGS) -c native_method.cc -o native_method.o

scope.o: scope.cc
	$(CXX) $(CFLAGS) -c scope.cc -o scope.o

lexical_scope.o: lexical_scope.cc
	$(CXX) $(CFLAGS) -c lexical_scope.cc -o lexical_scope.o

class_scope.o: class_scope.cc
	$(CXX) $(CFLAGS) -c class_scope.cc -o class_scope.o

class.o: class.cc
	$(CXX) $(CFLAGS) -c class.cc -o class.o

errors.o: errors.cc
	$(CXX) $(CFLAGS) -c errors.cc -o errors.o

method.o: method.cc
	$(CXX) $(CFLAGS) -c method.cc -o method.o

block.o: block.cc
	$(CXX) $(CFLAGS) -c block.cc -o block.o

utils.o: utils.cc
	$(CXX) $(CFLAGS) -c utils.cc -o utils.o

file.o: file.cc
	$(CXX) $(CFLAGS) -c file.cc -o file.o

directory.o: directory.cc
	$(CXX) $(CFLAGS) -c directory.cc -o directory.o

fancy_exception.o: fancy_exception.cc
	$(CXX) $(CFLAGS) -c fancy_exception.cc -o fancy_exception.o

callable.o: callable.cc
	$(CXX) $(CFLAGS) -c callable.cc -o callable.o
