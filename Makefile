all: fancy

fancy:
	cd src && make

clean:
	cd src && make clean > /dev/null
	rm -f bin/*
