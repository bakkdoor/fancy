#include "includes.h"
#include "parser/includes.h"

/* prototype of bison-generated parser function */
int yyparse();

#define STDLIB_FILES {"lib/Object.fnc", "lib/Number.fnc", "lib/Array.fnc"}
#define N_STDLIB_FILES 3

void parse_file(string &filename)
{
  if(freopen(filename.c_str(), "r", stdin) == NULL)
  {
    fprintf(stderr, "File %s cannot be opened.\n", filename.c_str());
    exit(1);
  }
  
  yyparse();
}

int main(int argc, char **argv)
{
  GC_INIT();

  int i;
  string files[] = STDLIB_FILES;

  init_core_classes();
  init_global_objects();
  init_global_scope();

  for(i = 0; i < N_STDLIB_FILES; i++) {
    parse_file(files[i]);
  }
  
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
    fprintf(stderr, "%s: File %s cannot be opened.\n", argv[0], argv[1]);
    exit(1);
  }
  
  try {
    yyparse();
  } catch(UnknownIdentifierError &ex) {
    cout << "Error:" << endl;
  }

  // cout << "heap size: " << GC_get_bytes_since_gc() << endl;
  // GC_gcollect();
  // cout << "heap size after collect: " << GC_get_bytes_since_gc() << endl;
  // cout << "Completed " << GC_gc_no << " collections" <<endl;
  // cout << "Heap size is " << GC_get_heap_size() << endl;

  return 0;
}

