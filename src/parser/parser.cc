#include "includes.h"

/* prototype of bison-generated parser function */
extern int yyparse();
extern void yyrestart(FILE*);
extern yy_buffer_state* yy_create_buffer(FILE*, int);
extern int yy_switch_to_buffer(yy_buffer_state*);
extern int yy_delete_buffer(yy_buffer_state*);

namespace fancy {
  namespace parser {

    stack<parser_buffer> parse_buffers;

    void parse_file(string &filename)
    {
      if(push_buffer(filename)) {
        yyparse();
        pop_buffer();
      }
    }

    bool push_buffer(string &filename)
    {
      parser_buffer buf;
      FILE *f = fopen(filename.c_str(), "r");
      if(!f) {
        error("");
        perror(filename.c_str());
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

  }
}

