GCLIB = vendor/gc/.libs/libgccpp.a

all: fancy

fancy: ${GCLIB}
	cd src && make -j 4; make

gc: ${GCLIB}

${GCLIB}:
	@echo "compiling GC"
	@cd vendor/gc && CFLAGS="${GC_CFLAGS} ${CFLAGS}" ./configure --enable-cplusplus --disable-threads -q && make -s

docs:
	doxygen

clean:
	cd src && make clean > /dev/null
	rm -f bin/fancy
	rm -rf tmp/
	rm -rf docs/
	rm -rf .compiled/

all-clean: clean
	@cd vendor/gc && make clean

TESTFILES = array block true_class nil_class class documentation exception file	\
hash method number object set string symbol argv parsing/sexp

test: all
	@mkdir -p tmp
	@clear
	@bin/fancy -e "ARGV rest rest each: |f| { require: f }" $(foreach file, $(TESTFILES), tests/$(file).fnc)
	@echo


EXAMPLEFILES = arithmetic armstrong_numbers array blocks boolean class	\
closures factorial fibonacci files hello_world html_generator metadata	\
methods numbers person require scope

example: all
	@mkdir -p tmp
	@clear
	bin/fancy examples/echo.fnc examples/echo.fnc
	@echo
	@$(foreach file, $(EXAMPLEFILES),echo "\n\n>> examples/$(file).fnc:\n"; bin/fancy examples/$(file).fnc;)


STDLIB_BOOTSTRAP_FILES = argv boot array block class compiler		\
directory enumerable fancy_spec hash method nil_class number object	\
set string symbol true_class version

bootstrap:
	@mkdir -p .compiled/lib
	$(foreach file, $(STDLIB_BOOTSTRAP_FILES), bin/fancy -c lib/$(file).fnc -o .compiled/lib/$(file).fnc.rb;)
