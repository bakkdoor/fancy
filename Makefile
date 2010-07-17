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

test: all
	@clear
	@bin/fancy tests/array.fnc
	@echo
	@bin/fancy tests/block.fnc
	@echo
	@bin/fancy tests/boolean.fnc
	@echo
	@bin/fancy tests/class.fnc
	@echo
	@bin/fancy tests/documentation.fnc
	@echo
	@bin/fancy tests/exception.fnc
	@echo
	@mkdir -p tmp
	@bin/fancy tests/file.fnc
	@echo
	@bin/fancy tests/hash.fnc
	@echo
	@bin/fancy tests/method.fnc
	@echo
	@bin/fancy tests/number.fnc
	@echo
	@bin/fancy tests/object.fnc
	@echo
	@bin/fancy tests/set.fnc
	@echo
	@bin/fancy tests/string.fnc
	@echo
	@bin/fancy tests/symbol.fnc

example: all
	@mkdir -p tmp
	@clear
	bin/fancy examples/arithmetic.fnc
	@echo
	bin/fancy examples/armstrong_numbers.fnc
	@echo
	bin/fancy examples/array.fnc
	@echo
	bin/fancy examples/blocks.fnc
	@echo
	bin/fancy examples/boolean.fnc
	@echo
	bin/fancy examples/class.fnc
	@echo
	bin/fancy examples/closures.fnc
	@echo
	bin/fancy examples/echo.fnc examples/echo.fnc
	@echo
	bin/fancy examples/factorial.fnc
	@echo
	bin/fancy examples/fibonacci.fnc
	@echo
	bin/fancy examples/files.fnc
	@echo
	bin/fancy examples/hello_world.fnc
	@echo
	bin/fancy examples/html_generator.fnc
	@echo
	bin/fancy examples/metadata.fnc
	@echo
	bin/fancy examples/methods.fnc
	@echo
	bin/fancy examples/numbers.fnc
	@echo
	bin/fancy examples/person.fnc
	@echo
	bin/fancy examples/require.fnc
	@echo
	bin/fancy examples/scope.fnc
	@echo
