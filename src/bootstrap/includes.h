#ifndef _BOOTSTRAP_INCLUDES_H_
#define _BOOTSTRAP_INCLUDES_H_

#include "../includes.h"

#include "object.h"
#include "class.h"
#include "block.h"
#include "string.h"
#include "number.h"
#include "console.h"
#include "nil.h"
#include "array.h"
#include "file.h"
#include "scope.h"

#define EXPECT_ARGS(method_name, amount)                                    \
  if(args.size() != amount) {                                               \
    error(method_name) << " expects " << amount << " arguments." << endl;   \
    return nil;                                                             \
  }                                                                     


#endif /* _BOOTSTRAP_INCLUDES_H_ */
