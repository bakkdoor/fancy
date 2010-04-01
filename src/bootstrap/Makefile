cc = g++
cc_flags = -g -Wall -ansi -pedantic

files = core_classes object class block string number console nil array file

src_files = $(foreach file, $(files), $(file).cc)
obj_files = $(foreach file, $(files), $(file).o)

sub_dirs = 

all: subdirs $(obj_files)

core_classes.o: core_classes.cc
	$(cc) $(cc_flags) -c core_classes.cc -o core_classes.o

object.o: object.cc
	$(cc) $(cc_flags) -c object.cc -o object.o

class.o: class.cc
	$(cc) $(cc_flags) -c class.cc -o class.o

block.o: block.cc
	$(cc) $(cc_flags) -c block.cc -o block.o

string.o: string.cc
	$(cc) $(cc_flags) -c string.cc -o string.o

number.o: number.cc
	$(cc) $(cc_flags) -c number.cc -o number.o

console.o: console.cc
	$(cc) $(cc_flags) -c console.cc -o console.o

nil.o: nil.cc
	$(cc) $(cc_flags) -c nil.cc -o nil.o

array.o: array.cc
	$(cc) $(cc_flags) -c array.cc -o array.o

file.o: file.cc
	$(cc) $(cc_flags) -c file.cc -o file.o

subdirs:
	$(foreach dir, $(sub_dirs), cd $(dir) && make && cd ..;)

clean:
	rm -f *.o > /dev/null
