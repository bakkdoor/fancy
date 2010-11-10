#include "fancy_parser.h"
#include "ruby.h"
#include "lexer.h"


static VALUE
parse_string(VALUE self, VALUE code) {
  VALUE lineno = rb_funcall(self, rb_intern("lineno"), 0);
  char *str = StringValueCStr(code);
  YY_BUFFER_STATE buffstate = yy_scan_string(str);
  yy_switch_to_buffer(buffstate);
  yylineno = NUM2INT(lineno);
  yyparse(self);
  yy_delete_buffer(buffstate);
  return self;
}

static VALUE
parse_file(VALUE self) {
  VALUE filename = rb_funcall(self, rb_intern("filename"), 0);
  VALUE lineno = rb_funcall(self, rb_intern("lineno"), 0);
  char *str = StringValueCStr(filename);
  FILE *f = fopen(str, "r");
  if(!f) {
    rb_funcall(self, rb_intern("file_error"), 2, rb_str_new2("Could not open file"), rb_str_new2(str));
    return Qnil;
  }
  YY_BUFFER_STATE buffstate = yy_create_buffer(f, YY_BUF_SIZE);
  yy_switch_to_buffer(buffstate);
  yylineno = NUM2INT(lineno);
  yyparse(self);
  yy_delete_buffer(buffstate);
  return self;
}

void
Init_fancy_parser() {
  VALUE m_Fancy = rb_define_module("Fancy");
  VALUE m_Parser = rb_define_module_under(m_Fancy, "Parser");
  rb_define_method(m_Parser, "parse_string", parse_string, 1);
  rb_define_method(m_Parser, "parse_file", parse_file, 0);
}


