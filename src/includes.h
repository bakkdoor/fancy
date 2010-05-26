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
#include <set>
#include <stack>
#include <iostream>
#include <algorithm>
#include <cctype>
#include <fstream>

#include<sys/stat.h>
#include<sys/types.h>


using namespace std;

#include "callable.h"
#include "expression.h"
#include "fancy_object.h"
#include "expression_list.h"
#include "array.h"
#include "nil.h"
#include "true.h"
#include "symbol.h"
#include "method.h"
#include "string.h"
#include "number.h"
#include "hash.h"
#include "regexp.h"
#include "file.h"
#include "directory.h"
#include "native_method.h"
#include "block.h"
#include "class.h"
#include "scope.h"
#include "fancy_exception.h"
#include "bootstrap/core_classes.h"
#include "errors.h"
#include "utils.h"


#endif /* _INCLUDES_H_ */
