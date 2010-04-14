#include "includes.h"
#include "parser/includes.h"

extern int yyparse();
extern void yyrestart(FILE*);

int main(int argc, char **argv)
{
  GC_INIT();

  string files[] = {
    "lib/object.fnc",
    "lib/class.fnc",
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

  fancy::bootstrap::init_core_classes();
  fancy::bootstrap::init_global_objects();
  fancy::bootstrap::init_global_scope();

  for(unsigned int i = 0; i < files_vector.size(); i++) {
    fancy::parser::parse_file(files_vector[i]);
  }

  try {  
    if (argc > 1) {
      string filename = string(argv[1]);

      // set command line arguments in global ARGV variable as Array
      Array_p args_arr = new Array();
      for(int i = 1; i < argc; i++) {
        string arg(argv[i]);
        args_arr->insert(String::from_value(arg));
      }
      global_scope->define("ARGV", args_arr);

      fancy::parser::parse_file(filename);
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

