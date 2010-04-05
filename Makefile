all: fancy

fancy:
	cd src && make

clean:
	cd src && make clean > /dev/null
	rm -f bin/*
	rm -rf tmp/

test: all
	@clear
	bin/fancy tests/array.fnc
	@echo
	bin/fancy tests/string.fnc
	@echo
	bin/fancy tests/block.fnc
	@echo
	bin/fancy tests/number.fnc

example: all
	@mkdir -p tmp
	@clear
	bin/fancy examples/arithmetic.fnc
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
	bin/fancy examples/files.fnc
	@echo
	bin/fancy examples/hello-world.fnc
	@echo
	bin/fancy examples/methods.fnc
	@echo
	bin/fancy examples/numbers.fnc
	@echo