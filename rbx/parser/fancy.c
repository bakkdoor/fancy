#include "fancy.h"
#include "ruby.h"

void
Init_FancyParser() {
  VALUE m_Fancy = rb_define_module("Fancy");
  VaLUE m_Parser = rb_define_class_under(m_Fancy, "Parser");
}
