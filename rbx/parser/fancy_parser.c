#include "fancy_parser.h"
#include "ruby.h"
#include "lexer.h"

VALUE m_Parser;

VALUE
parse_string(VALUE self, VALUE code) {
  char *str = StringValueCStr(code);
  YY_BUFFER_STATE buffstate = yy_scan_string(str);
  yy_switch_to_buffer(buffstate);
  yyparse();
  yy_delete_buffer(buffstate);
  return self;
}

void
Init_fancy_parser() {
  VALUE m_Fancy = rb_define_module("Fancy");
  m_Parser = rb_define_module_under(m_Fancy, "Parser");
  rb_define_method(m_Parser, "parse_string", parse_string, 1);
}


