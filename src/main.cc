#include "includes.h"
#include "parser/includes.h"

/* prototype of bison-generated parser function */
int yyparse();
int yyrestart(FILE*);
extern int yylineno;
extern string current_file;

void parse_file(string &filename)
{
  FILE *file = fopen(filename.c_str(), "r");
  if(file == NULL)
  {
    fprintf(stderr, "File %s cannot be opened.\n", filename.c_str());
    exit(1);
  }
  
  current_file = filename;
  yyrestart(file);
  yyparse();
  yylineno = 1; // reset yylineno for next file to parse
  fclose(file);
}

int main(int argc, char **argv)
{
  GC_INIT();

  string files[] = {
    "lib/object.fnc",
    "lib/true_class.fnc",
    "lib/nil_class.fnc",
    "lib/number.fnc",
    "lib/string.fnc",
    "lib/enumerable.fnc",
    "lib/array.fnc",
    "lib/block.fnc",
    "lib/file.fnc",
    "lib/fancy_spec.fnc",
    "lib/console.fnc",
    "lib/hash.fnc"
  };

  vector<string> files_vector (files, files + sizeof(files) / sizeof(string) );

  init_core_classes();
  init_global_objects();
  init_global_scope();

  for(unsigned int i = 0; i < files_vector.size(); i++) {
    parse_file(files_vector[i]);
  }

  try {  
    if (argc > 1) {
      string filename = string(argv[1]);
      parse_file(filename);
    } else {
      yyrestart(stdin);
      yyparse();
    }
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

