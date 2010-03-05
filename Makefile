all: fancy

fancy:
	cd src && make

clean:
	cd src && make clean > /dev/null
	rm -f bin/*

test: all
	@clear
	bin/fancy examples/hello-world.fnc
	@echo
	bin/fancy examples/class.fnc
	@echo
	bin/fancy examples/arithmetic.fnc
	@echo