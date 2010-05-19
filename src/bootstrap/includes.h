#ifndef _BOOTSTRAP_INCLUDES_H_
#define _BOOTSTRAP_INCLUDES_H_

#include "../includes.h"

#include "core_classes.h"

#define EXPECT_ARGS(method_name, amount)                                \
  if(argc != amount) {                                                  \
    error(method_name) << " expects " << amount << " arguments." << endl; \
    return nil;                                                         \
  }                                                                     

#define METHOD(method_name)                                             \
  FancyObject_p method_name(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)

#endif /* _BOOTSTRAP_INCLUDES_H_ */
