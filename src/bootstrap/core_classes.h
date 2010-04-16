#ifndef _CORE_METHODS_H_
#define _CORE_METHODS_H_

namespace fancy {

  extern Class *ClassClass;
  extern Class *ObjectClass;
  extern Class *NilClass;
  extern Class *TrueClass;
  extern Class *StringClass;
  extern Class *SymbolClass;
  extern Class *NumberClass;
  extern Class *RegexClass;
  extern Class *ArrayClass;
  extern Class *HashClass;
  extern Class *MethodClass;
  extern Class *MethodCallClass;
  extern Class *BlockClass;
  extern Class *FileClass;
  extern Class *ConsoleClass;
  extern Class *ScopeClass;

  extern Class *ExceptionClass;
  extern Class *UnknownIdentifierErrorClass;
  extern Class *MethodNotFoundErrorClass;
  extern Class *IOErrorClass;

  extern FancyObject *nil;
  extern FancyObject *t;

  namespace bootstrap {

    void init_core_classes();
    void init_global_objects();

    /**
     * Sets up the global scope with predefined functions etc.
     */
    void init_global_scope();

  }
}

#endif /* _CORE_METHODS_H_ */
