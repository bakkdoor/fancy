#include "fancy.h"
#include "ruby.h"

void
Init_fancy_parser() {
  VALUE m_Fancy = rb_define_module("Fancy");
  VALUE m_Parser = rb_define_module_under(m_Fancy, "Parser");
}
