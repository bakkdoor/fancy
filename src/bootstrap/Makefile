cc = g++
cc_flags = -g -Wall -ansi -pedantic

files = core_classes

src_files = $(foreach file, $(files), $(file).cc)
obj_files = $(foreach file, $(files), $(file).o)

sub_dirs = 

all: subdirs $(obj_files)

core_classes.o: core_classes.cc
	$(cc) $(cc_flags) -c core_classes.cc -o core_classes.o

subdirs:
	$(foreach dir, $(sub_dirs), cd $(dir) && make && cd ..;)

clean:
	rm -f *.o > /dev/null
