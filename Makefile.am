SUBDIRS = src

ACLOCAL_AMFLAGS = -I m4

fancy: bin/fancy

docs:
	doxygen

test_files = array \
	block \
	true_class \
	nil_class \
	class \
	documentation \
	exception \
	file \
	hash \
	method \
	number \
	object \
	set \
	string \
	symbol \
	argv \
	parsing/sexp

test: fancy
	@mkdir -p tmp
	@clear
	@bin/fancy -e "ARGV rest rest each: |f| { require: f }" $(foreach file, $(test_files), tests/$(file).fnc)
	@echo

example_files = arithmetic \
		armstrong_numbers \
		array \
		blocks \
		boolean	\
		class \
		closures \
		factorial \
		fibonacci \
		files \
		hello_world \
		html_generator \
		metadata \
		methods	\
		numbers	\
		person	\
		require

example: fancy
	@mkdir -p tmp
	@clear
	bin/fancy examples/echo.fnc examples/echo.fnc
	@echo
	@$(foreach file, $(example_files),echo "\n\n>> examples/$(file).fnc:\n"; bin/fancy examples/$(file).fnc;)


stdlib_bootstrap_files = argv \
			boot \
			array \
			block \
			class \
			compiler \
			directory \
			enumerable \
			fancy_spec \
			hash \
			method \
			nil_class \
			number \
			object \
			set \
			string \
			symbol \
			true_class \
			version

compiler_bootstrap_files = nodes 
			nodes/array_literal \
			nodes/assignment \
			nodes/block_literal \
			nodes/class_definition \
			nodes/expression_list \
			nodes/hash_literal \
			nodes/identifier \
			nodes/message_send \
			nodes/method_definition \
			nodes/method \
			nodes/node \
			nodes/number_literal \
			nodes/operator_send \
			nodes/require \
			nodes/return \
			nodes/singleton_method_definition \
			nodes/string_literal \
			nodes/symbol_literal \
			nodes/try_catch_block
bootstrap:
	@mkdir -p .compiled/lib/compiler/nodes
	@mkdir -p .compiled/tests/parsing
	$(foreach file, $(stdlib_bootstrap_files), bin/fancy -c lib/$(file).fnc -o .compiled/lib/$(file).fnc.rb;)
	$(foreach file, $(compiler_bootstrap_files), bin/fancy -c lib/compiler/$(file).fnc -o .compiled/lib/compiler/$(file).fnc.rb;)
	$(foreach file, $(test_files), bin/fancy -c tests/$(file).fnc -o .compiled/tests/$(file).fnc.rb;)

all-clean: clean
	@cd vendor/gc && make clean

clean:
	cd src && make clean > /dev/null
	rm -f bin/fancy
	rm -rf tmp/
	rm -rf docs/
	rm -rf .compiled/