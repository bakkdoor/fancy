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
  VALUE ext = rb_funcall(rb_cModule, rb_intern("new"), 0);
  rb_define_method(ext, "parse_string", parse_string, 1);
  rb_define_method(ext, "parse_file", parse_file, 0);
  VALUE fancy = rb_const_get(rb_cObject, rb_intern("Fancy"));
  VALUE parser = rb_const_get(fancy, rb_intern("Parser"));
  rb_funcall(parser, rb_intern("include"), 1, ext);
}


