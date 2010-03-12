cc = g++
cc_flags = -g -Wall -ansi -pedantic

files = core_classes string console

src_files = $(foreach file, $(files), $(file).cc)
obj_files = $(foreach file, $(files), $(file).o)

sub_dirs = 

all: subdirs $(obj_files)

core_classes.o: core_classes.cc
	$(cc) $(cc_flags) -c core_classes.cc -o core_classes.o

string.o: string.cc
	$(cc) $(cc_flags) -c string.cc -o string.o

console.o: console.cc
	$(cc) $(cc_flags) -c console.cc -o console.o

subdirs:
	$(foreach dir, $(sub_dirs), cd $(dir) && make && cd ..;)

clean:
	rm -f *.o > /dev/null
