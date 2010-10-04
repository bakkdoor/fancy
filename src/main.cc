#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <string>
#include <iostream>

#include<sys/stat.h>
#include<sys/types.h>

#include "array.h"
#include "string.h"
#include "fancy_exception.h"
#include "number.h"
#include "errors.h"
#include "utils.h"
#include "parser/parser.h"
#include "bootstrap/includes.h"
#include "bootstrap/core_classes.h"

using namespace std;
using namespace fancy;

extern int yyparse();
extern void yyrestart(FILE*);

string get_load_path(int argc, char **argv)
{
  for(int i = 1; i < argc; i++) {
    if(strcmp(argv[i], "-I") == 0) {
      return string(argv[i+1]);
    }
  }
  return "."; // current dir
}

bool output_sexp(int argc, char **argv) {
  for(int i = 1; i < argc; i++) {
    if(strcmp(argv[i], "--sexp") == 0) {
      return true;
    }
  }
  return false;
}

int prepare_argv(int argc, char **argv)
{
  int argv_size = 0;
  // set command line arguments in global ARGV variable as Array
  Array* args_arr = new Array();
  for(int i = 1; i < argc; i++) {
    string arg(argv[i]);
    // skip -I + root loadpath arg
    if(arg == "-I") {
      i++;
      continue;
    }
    // skip --sexp option
    if(arg == "--sexp") {
      continue;
    }
    args_arr->insert(FancyString::from_value(arg));
    argv_size++;
  }
  global_scope->define("ARGV", args_arr);
  return argv_size;
}

string filename(int argc, char **argv)
{
  for(int i = 1; i < argc; i++) {
    if(argv[i][0] == '-') {
      i++;
      continue;
    }
    return string(argv[i]);
  }
  return "";
}

int main(int argc, char **argv)
{
  GC_INIT();

  fancy::parser::output_sexp = output_sexp(argc, argv);
  fancy::parser::load_path.push_back(get_load_path(argc, argv));
  fancy::bootstrap::init_core_classes();
  fancy::bootstrap::init_global_objects();
  fancy::bootstrap::init_global_scope();
  fancy::Number::init_cache();

  string boot_file = "boot.fy";
  string stdlib_path = get_load_path(argc, argv) + "/lib";
  fancy::parser::load_path.push_back(stdlib_path);

  int argv_size = prepare_argv(argc, argv);
  // now, load boot.fy
  bool tmp = fancy::parser::output_sexp;
  fancy::parser::output_sexp = false; // just for booting phase
  fancy::parser::parse_file(boot_file);
  fancy::parser::output_sexp = tmp;

  try {
    string file = filename(argc, argv);
    if(file != "") {
      fancy::parser::parse_file(file);
    } else {
      if(argv_size == 0) {
        parser::parse_stdin();
      }
    }
  } catch(UnknownIdentifierError &ex) {
    cout << "Error:" << endl;
  }

  // cout << "heap size: " << GC_get_bytes_since_gc() << endl;
  GC_gcollect();
  // cout << "heap size after collect: " << GC_get_bytes_since_gc() << endl;
  // cout << "Completed " << GC_gc_no << " collections" <<endl;
  // cout << "Heap size is " << GC_get_heap_size() << endl;

  return 0;
}

