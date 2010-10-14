#include "fancy.h"
#include "ruby.h"
#include "lexer.h"

VALUE
parse_string(VALUE self, VALUE code) {
  YY_BUFFER_STATE buffstate = yy_scan_string(STR2CSTR(code));
  yy_switch_to_buffer(buffstate);
  yyparse();
  yy_delete_buffer(buffstate);
}

void
Init_fancy_parser() {
  VALUE m_Fancy = rb_define_module("Fancy");
  VALUE m_Parser = rb_define_module_under(m_Fancy, "Parser");
  rb_define_method(m_Parser, "parse_string", parse_string, 1);
}


