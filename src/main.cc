#include "includes.h"
#include "parser/includes.h"

extern int yyparse();
extern void yyrestart(FILE*);

string get_load_path(int argc, char **argv)
{
  for(int i = 1; i < argc; i++) {
    if(strcmp(argv[i], "-I") == 0) {
      return string(argv[i+1]);
    }
  }
  return "";
}

void prepare_argv(int argc, char **argv)
{
  // set command line arguments in global ARGV variable as Array
  Array_p args_arr = new Array();
  for(int i = 1; i < argc; i++) {
    string arg(argv[i]);
    // skip -I + root loadpath arg
    if(arg == "-I") {
      i++;
      continue;
    }
    args_arr->insert(String::from_value(arg));
  }
  global_scope->define("ARGV", args_arr);
}

void exec_from_stdin()
{
  yyrestart(stdin);
  try {
    yyparse();
  } catch(FancyException *ex) {
    errorln("GOT UNCAUGHT EXCEPTION, ABORTING.");
    errorln(ex->to_s());
    // keep it running!
    exec_from_stdin();
  }
}

int main(int argc, char **argv)
{
  GC_INIT();

  fancy::parser::load_path.push_back(get_load_path(argc, argv));
  fancy::bootstrap::init_core_classes();
  fancy::bootstrap::init_global_objects();
  fancy::bootstrap::init_global_scope();
  fancy::Number::init_cache();

  string boot_file = "lib/boot.fnc";
  fancy::parser::parse_file(boot_file);

  try {
    if (argc > 1) {
      prepare_argv(argc, argv);
      string filename = string(argv[1]);
      if(filename == "-I") {
        if(argc > 3) {
          filename = string(argv[3]);
          fancy::parser::parse_file(filename);
        } else {
          exec_from_stdin();
        }
      } else {
        fancy::parser::parse_file(filename);
      }
    } else {
      exec_from_stdin();
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

