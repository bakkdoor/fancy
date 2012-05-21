#include "ext.h"
#include "ruby.h"
#include "lexer.h"

static VALUE
fancy_parse_string(VALUE self, VALUE code) {
  VALUE filename = rb_funcall(self, rb_intern(":filename"), 0);
  VALUE lineno = rb_funcall(self, rb_intern(":line"), 0);
  char *str = StringValueCStr(code);
  YY_BUFFER_STATE buffstate = yy_scan_string(str);
  yy_switch_to_buffer(buffstate);
  yylineno = NUM2INT(lineno);
  yyparse(self);
  yy_delete_buffer(buffstate);
  return self;
}

static VALUE
fancy_parse_file(VALUE self) {
  VALUE filename = rb_funcall(self, rb_intern(":filename"), 0);
  VALUE lineno = rb_funcall(self, rb_intern(":line"), 0);
  char *str = StringValueCStr(filename);
  FILE *f = fopen(str, "r");
  if(!f) {
    rb_funcall(self, rb_intern("ast:file_error:"), 2, INT2NUM(0), rb_str_new2("Could not open file"));
    return Qnil;
  }
  YY_BUFFER_STATE buffstate = yy_create_buffer(f, YY_BUF_SIZE);
  yy_switch_to_buffer(buffstate);
  yyparse(self);
  yy_delete_buffer(buffstate);
  fclose(f);
  return self;
}

void
Init_fancy_parser() {
  VALUE fancy = rb_const_get(rb_cObject, rb_intern("Fancy"));
  VALUE parser = rb_const_get(fancy, rb_intern("Parser"));
  rb_define_method(parser, "parse_string:", fancy_parse_string, 1);
  rb_define_method(parser, ":parse_file", fancy_parse_file, 0);
}
