CC             = @CC@
CXX             = @CXX@
CFLAGS         = @CFLAGS@
CPPFLAGS       = @CPPFLAGS@

files = core_classes \
 	object \
	class \
	block \
	string \
	number \
	console \
	array \
	file \
	directory \
	scope \
	hash \
	error \
	method \
	system

src_files = $(foreach file, $(files), $(file).cc)
obj_files = $(foreach file, $(files), $(file).o)

all: $(obj_files)

core_classes.o: core_classes.cc
	$(CXX) $(CFLAGS) -c core_classes.cc -o core_classes.o

object.o: object.cc
	$(CXX) $(CFLAGS) -c object.cc -o object.o

class.o: class.cc
	$(CXX) $(CFLAGS) -c class.cc -o class.o

block.o: block.cc
	$(CXX) $(CFLAGS) -c block.cc -o block.o

string.o: string.cc
	$(CXX) $(CFLAGS) -c string.cc -o string.o

number.o: number.cc
	$(CXX) $(CFLAGS) -c number.cc -o number.o

console.o: console.cc
	$(CXX) $(CFLAGS) -c console.cc -o console.o

array.o: array.cc
	$(CXX) $(CFLAGS) -c array.cc -o array.o

file.o: file.cc
	$(CXX) $(CFLAGS) -c file.cc -o file.o

directory.o: directory.cc
	$(CXX) $(CFLAGS) -c directory.cc -o directory.o

scope.o: scope.cc
	$(CXX) $(CFLAGS) -c scope.cc -o scope.o

hash.o: hash.cc
	$(CXX) $(CFLAGS) -c hash.cc -o hash.o

error.o: error.cc
	$(CXX) $(CFLAGS) -c error.cc -o error.o

method.o: method.cc
	$(CXX) $(CFLAGS) -c method.cc -o method.o

system.o: system.cc
	$(CXX) $(CFLAGS) -c system.cc -o system.o

clean:
	rm -f *.o > /dev/null
