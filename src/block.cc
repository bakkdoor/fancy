#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include "block.h"
#include "symbol.h"
#include "bootstrap/core_classes.h"
#include "errors.h"

namespace fancy {

  Block::Block(ExpressionList* body, Scope *creation_scope) :
    FancyObject(BlockClass),
    _body(body),
    _creation_scope(creation_scope),
    _override_self(false),
    _argcount(0)
  {
    _docstring = "<BLOCK>";
    init_orig_block_arg_values();
  }

  Block::Block(list<parser::nodes::Identifier*> argnames, ExpressionList* body, Scope *creation_scope) :
    FancyObject(BlockClass),
    _argnames(argnames),
    _body(body),
    _creation_scope(creation_scope),
    _override_self(false)
  {
    _docstring = "<BLOCK>";
    _argcount = argnames.size();
    init_orig_block_arg_values();
  }

  Block::~Block()
  {
  }

  string Block::to_s() const
  {
    return "<Block>";
  }

  FancyObject* Block::call(FancyObject* self, FancyObject* *args, int argc, Scope *scope, FancyObject* sender)
  {
    // check if block is empty
    if(_body->size() == 0)
      return nil;

    if(argc > 0) {
      list<parser::nodes::Identifier*>::iterator name_it = _argnames.begin();
      int i = 0;
      while(name_it != _argnames.end() && i < argc) {
        string name = (*name_it)->name();
        // set new value (argument)
        _creation_scope->define(name, args[i]);
        name_it++;
        i++;
      }
    }

    FancyObject* return_value = call(self, scope, sender);

    // reset old values for param names in creation_scope (if any args given)
    if(argc > 0) {
      list<parser::nodes::Identifier*>::iterator name_it = _argnames.begin();
      for(map<string, FancyObject*>::iterator val_it = _block_arg_orig_values.begin();
          val_it != _block_arg_orig_values.end();
          val_it++) {
        _creation_scope->define(val_it->first, val_it->second);
      }
    }

    return return_value;
  }

  FancyObject* Block::call(FancyObject* self, Scope *scope, FancyObject* sender)
  {
    // check if block is empty
    if(_body->size() == 0) {
      return nil;
    }

    FancyObject* old_self = _creation_scope->current_self();
    if(_override_self) {
      _creation_scope->set_current_self(self);
    }

    // finally, eval the blocks body expression
    FancyObject* return_value = _body->eval(_creation_scope);

    // restore old self if _override_self
    if(_override_self) {
      _creation_scope->set_current_self(old_self);
    }

    return return_value;
  }

  vector<FancyObject*> Block::args()
  {
    vector<FancyObject*> args(_argnames.size(), nil);
    int i = 0;
    for(list<parser::nodes::Identifier*>::iterator it = _argnames.begin();
        it != _argnames.end();
        it++) {
      args[i] = Symbol::from_string("'" + (*it)->name());
      i++;
    }
    return args;
  }

  void Block::init_orig_block_arg_values()
  {
    if(_argnames.size() > 0) {
      list<parser::nodes::Identifier*>::iterator name_it = _argnames.begin();
      while(name_it != _argnames.end()) {
        // save old value for name in _block_arg_orig_values;
        try {
          FancyObject* orig_val = _creation_scope->get((*name_it)->name());
          _block_arg_orig_values[(*name_it)->name()] = orig_val;
        } catch(UnknownIdentifierError* e) {
          // value not defined, ignore
        }
        name_it++;
      }
    }
  }
}
