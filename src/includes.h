#ifndef _INCLUDES_H_
#define _INCLUDES_H_

#include <gc/gc.h>
#include <gc/gc_cpp.h>
#include <gc/gc_allocator.h>


#define PRINT_DEBUG 0

#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <cassert>
#include <string>
#include <sstream>
#include <map>
#include <list>
#include <vector>
#include <iostream>

using namespace std;

#include "expression.h"
#include "object.h"
#include "array.h"
#include "nil.h"
#include "t.h"
#include "identifier.h"
#include "method.h"
#include "string.h"
#include "number.h"
#include "hash.h"
#include "regex.h"
#include "expression_list.h"

#include "scope.h"
#include "method_call.h"
#include "assignment.h"
#include "method_definition.h"
#include "core_methods.h"
#include "errors.h"


#endif /* _INCLUDES_H_ */
