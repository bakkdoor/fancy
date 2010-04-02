#include "includes.h"
#include "parser/includes.h"

/* prototype of bison-generated parser function */
int yyparse();
extern int yylineno;
extern string current_file;

void parse_file(string &filename)
{
  if(freopen(filename.c_str(), "r", stdin) == NULL)
  {
    fprintf(stderr, "File %s cannot be opened.\n", filename.c_str());
    exit(1);
  }
  
  current_file = filename;
  
  yyparse();
  yylineno = 1; // reset yylineno for next file to parse
}

int main(int argc, char **argv)
{
  GC_INIT();

  string files[] = {
    "lib/Object.fnc",
    "lib/TrueClass.fnc",
    "lib/NilClass.fnc",
    "lib/Number.fnc",
    "lib/Array.fnc",
    "lib/Block.fnc",
    "lib/File.fnc"
  };

  vector<string> files_vector (files, files + sizeof(files) / sizeof(string) );

  init_core_classes();
  init_global_objects();
  init_global_scope();

  for(unsigned int i = 0; i < files_vector.size(); i++) {
    parse_file(files_vector[i]);
  }
  
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
    fprintf(stderr, "%s: File %s cannot be opened.\n", argv[0], argv[1]);
    exit(1);
  }
  
  try {
    current_file = string(argv[1]);
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

