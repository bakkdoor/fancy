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

all-clean: clean
	@cd vendor/gc && make clean

TESTFILES = array block boolean class documentation exception file	\
hash method number object set string symbol

test: all
	@mkdir -p tmp
	@clear
	@bin/fancy bin/fspec $(foreach file, $(TESTFILES), tests/$(file).fnc)
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
