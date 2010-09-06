#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include <cstdlib>
#include <cstdio>
#include <sys/stat.h>

#include "parser.h"
#include "../fancy_exception.h"
#include "../utils.h"
#include "../bootstrap/core_classes.h"
#include "../scope.h"
#include "../string.h"


/* prototype of bison-generated parser function */
extern int yyparse();
extern void yyrestart(FILE*);
extern yy_buffer_state* yy_create_buffer(FILE*, int);
extern yy_buffer_state* yy_scan_string(const char*);
extern int yy_switch_to_buffer(yy_buffer_state*);
extern int yy_delete_buffer(yy_buffer_state*);

namespace fancy {
  namespace parser {

    string current_file;
    stack<parser_buffer> parse_buffers;
    list<string> load_path;
    FancyObject* last_value = nil;
    bool output_sexp = false;
    ostream *out_stream = &cout;

    void define_predefined_values(const string &filename)
    {
      global_scope->define("__FILE__", FancyString::from_value(filename));
    }

    void try_parse()
    {
      try {
        if(output_sexp)
          (*out_stream) << "['exp_list, [";
        yyparse();
        if(output_sexp)
          (*out_stream) << "]]\n";
      } catch(FancyException* ex) {
        cerr << "\n";
        errorln("GOT UNCAUGHT EXCEPTION, ABORTING.");
        errorln(ex->to_s());
        exit(1);
      }
      pop_buffer();
    }

    void parse_file(string &filename)
    {
      // put the path of the file into the load_path vector
      // this makes requiring files in the same directory easier
      string filepath = dirname_for_path(filename);
      bool has_ending = true;

      // check for file ending
      string filename_with_ending = filename;
      if(filename_for_path(filename) != "fnc") {
        has_ending = false;
        filename_with_ending = filename + ".fnc";
      }

      if(!is_whitespace(filepath)) {
        load_path.push_back(filepath);
        load_path.unique(); // remove double entries
      }

      if(!push_buffer(filename)) {
        // try with file ending, if not given
        if(!has_ending) {
          if(push_buffer(filename_with_ending)) {
            define_predefined_values(filename_with_ending);
            try_parse();
          } else {
            error(filename) << ": No such file or directory\n";
            return;
          }
        } else {
          error(filename) << ": No such file or directory\n";
          return;
        }
      } else {
        define_predefined_values(filename);
        try_parse();
      }
    }

    FancyObject* parse_string(const string &code, Scope* scope)
    {
      parser_buffer buf;
      buf.buffstate = yy_scan_string(code.c_str());
      buf.lineno = yylineno;
      buf.file = NULL;
      buf.filename = "";

      yylineno = 1;
      yy_switch_to_buffer(buf.buffstate);

      // save global_scope since we want to evaluate the string within
      // the given scope
      Scope* old_global_scope = global_scope;
      global_scope = scope;

      if(output_sexp)
        (*out_stream) << "['exp_list, [";
      yyparse();
      if(output_sexp)
        (*out_stream) << "]]";

      global_scope = old_global_scope;

      // delete string buffer
      yy_delete_buffer(buf.buffstate);

      // reset to what we had before
      if(!parse_buffers.empty()) {
        parser_buffer prev = parse_buffers.top();
        yy_switch_to_buffer(prev.buffstate);
        yylineno = prev.lineno;
        current_file = prev.filename;
      }

      // finally, return the last evaluated value
      return last_value;
    }

    void parse_stdin()
    {
      parser_buffer buf;
      buf.buffstate = yy_create_buffer(stdin, YY_BUF_SIZE);
      buf.file = stdin;
      buf.filename = "STDIN";
      buf.lineno = yylineno;
      parse_buffers.push(buf);
      current_file = "STDIN";
      yylineno = 1;
      yy_switch_to_buffer(buf.buffstate);
      // keep it running!
      while(true) {
        try {
          yyparse();
        } catch(FancyException* ex) {
          errorln("GOT UNCAUGHT EXCEPTION, ABORTING.");
          errorln(ex->to_s());
        }
      }
    }

    bool push_buffer(const string &filename)
    {
      parser_buffer buf;
      FILE *f = find_open_file(filename);
      if(!f) {
        // error("");
        // perror(filename.c_str());
        return false;
      }
      buf.buffstate = yy_create_buffer(f, YY_BUF_SIZE);
      buf.file = f;
      buf.filename = filename;
      buf.lineno = yylineno;
      parse_buffers.push(buf);

      current_file = filename;
      yylineno = 1;

      yy_switch_to_buffer(buf.buffstate);
      return true;
    }

    void pop_buffer()
    {
      if(!parse_buffers.empty()) {
        parser_buffer buf = parse_buffers.top();
        parse_buffers.pop();

        fclose(buf.file);
        yy_delete_buffer(buf.buffstate);

        if(!parse_buffers.empty()) {
          parser_buffer prev = parse_buffers.top();
          yy_switch_to_buffer(prev.buffstate);
          yylineno = prev.lineno;
          current_file = prev.filename;
        }
      }
    }

    FILE* find_open_file(const string &filename)
    {
      FILE *f = 0;
      int status;
      struct stat st_buf;
      status = stat(filename.c_str(), &st_buf);

      // try direct filename first
      f = fopen(filename.c_str(), "r");

      // if that failed or the file actually is a directory, try with
      // each path in load_path prepended to the filename until we
      // succeed
      if(f && !(S_ISDIR(st_buf.st_mode))) {
        return f;
      } else {
        for(list<string>::iterator it = load_path.begin();
            it != load_path.end();
            it++) {
          string new_filename = ((*it) + "/" + filename).c_str();
          f = fopen(new_filename.c_str(), "r");
          status = stat(new_filename.c_str(), &st_buf);
          if(f && !(S_ISDIR(st_buf.st_mode))) {
            return f;
          }
        }
      }

      // at this point we failed and f = 0
      return  NULL;
    }

    string dirname_for_path(const string &path)
    {
      size_t found = path.find_last_of("/\\");
      return path.substr(0,found);
    }

    string filename_for_path(const string &path)
    {
      size_t found = path.find_last_of(".");
      return path.substr(found + 1);
    }

    bool is_whitespace(const string &str)
    {
      size_t found = str.find_first_not_of(" \t\r\n");
      return str.substr(found) == "";
    }

  }
}

