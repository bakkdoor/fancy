#ifndef _PARSER_PARSER_H_
#define _PARSER_PARSER_H_

struct yy_buffer_state;
extern int yylineno;
extern string current_file;

/* Size of default input buffer. */
#define YY_BUF_SIZE 16384

namespace fancy {
  namespace parser {

    struct parser_buffer {
      yy_buffer_state* buffstate;
      int lineno;
      string filename;
      FILE *file;
    };

    extern stack<parser_buffer> parse_buffers;

    void parse_file(string &filename);
    void push_buffer(string &filename);
    void pop_buffer();

  }
}

#endif /* _PARSER_PARSER_H_ */
