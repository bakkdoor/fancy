all: fancy

fancy:
	cd src && make

clean:
	cd src && make clean > /dev/null
	rm -f bin/*

test: all
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
	bin/fancy examples/hello-world.fnc
	@echo
	bin/fancy examples/methods.fnc
	@echo
	bin/fancy examples/numbers.fnc
	@echo