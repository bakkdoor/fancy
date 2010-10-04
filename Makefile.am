SUBDIRS = src
ACLOCAL_AMFLAGS = -I m4
GCLIB = vendor/gc/.libs/libgccpp.a

fancy: bin/fancy gc

gc: ${GCLIB}

${GCLIB}:
	@echo "Compiling GC"
	@cd vendor/gc && CFLAGS="${GC_CFLAGS} ${CFLAGS}" ./configure --enable-cplusplus --disable-threads -q && make -s

docs:
	doxygen

test_files = array	\
	block		\
	true_class	\
	nil_class	\
	class		\
	documentation	\
	exception	\
	file		\
	hash		\
	method		\
	number		\
	object		\
	set		\
	string		\
	symbol		\
	argv		\
	parsing/sexp

test: fancy
	@mkdir -p tmp
	@clear
	@bin/fancy -e "ARGV rest rest each: |f| { require: f }" $(foreach file, $(test_files), tests/$(file).fy)
	@echo

example_files = arithmetic 	    \
		armstrong_numbers   \
		array 		    \
		blocks 		    \
		boolean		    \
		class 		    \
		closures 	    \
		factorial 	    \
		fibonacci	    \
		files		    \
		hello_world	    \
		html_generator	    \
		metadata	    \
		methods		    \
		numbers		    \
		person		    \
		require

example: fancy
	@mkdir -p tmp
	@clear
	bin/fancy examples/echo.fy examples/echo.fy
	@echo
	@$(foreach file, $(example_files),echo "\n\n>> examples/$(file).fy:\n"; bin/fancy examples/$(file).fy;)


stdlib_bootstrap_files = argv 	    \
			boot 	    \
			array 	    \
			block 	    \
			class 	    \
			compiler    \
			directory   \
			enumerable  \
			fancy_spec  \
			hash 	    \
			method 	    \
			nil_class   \
			number 	    \
			object 	    \
			set 	    \
			string 	    \
			symbol 	    \
			true_class  \
			version

compiler_bootstrap_files = nodes 			    \
			nodes/array_literal 		    \
			nodes/assignment 		    \
			nodes/block_literal 		    \
			nodes/class_definition 		    \
			nodes/expression_list 		    \
			nodes/hash_literal 		    \
			nodes/identifier 		    \
			nodes/message_send 		    \
			nodes/method_definition 	    \
			nodes/method 			    \
			nodes/node 			    \
			nodes/number_literal 		    \
			nodes/operator_send 		    \
			nodes/require 			    \
			nodes/return 			    \
			nodes/singleton_method_definition   \
			nodes/string_literal 		    \
			nodes/symbol_literal 		    \
			nodes/try_catch_block

all-clean: clean
	@cd vendor/gc && make clean
	@rm -f Makefile src/Makefile src/bootstrap/Makefile src/parser/Makefile src/parser/nodes/Makefile config.h config.status config.log stamp-h1

clean:
	cd src && make clean > /dev/null
	rm -f bin/fancy
	rm -rf tmp/
	rm -rf docs/
	rm -rf .compiled/
