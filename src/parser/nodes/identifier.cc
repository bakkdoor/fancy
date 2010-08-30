#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "identifier.h"
#include "../../scope.h"
#include "../../bootstrap/core_classes.h"
#include "../../utils.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      Identifier::Identifier(const string &name) :
        _name(name),
        _nested(false)
      {
      }

      FancyObject* Identifier::eval(Scope *scope)
      {
        if(!_nested) {
          return scope->get(_name);
        } else {
          vector<string> nested_parts = string_split(_name, "::", false);
          Class* outer_class = dynamic_cast<Class*>(scope->get(nested_parts[0]));
          Class* current_class = outer_class;
          if(outer_class) {
            // go over each part identifier and check if its a (nested) class
            for(unsigned int i = 1; i < nested_parts.size(); i++) {
              if(Class* the_class = dynamic_cast<Class*>(current_class->get_nested_class(nested_parts[i]))) {
                current_class = the_class;
              } else {
                return nil;
              }
            }
            return current_class;
          }
          return nil;
        }
      }

      string Identifier::to_sexp() const
      {
        return "['ident, \"" + _name + "\"]";
      }

      map<string, Identifier*> Identifier::ident_cache;
      Identifier* Identifier::from_string(const string &name)
      {
        if(ident_cache.find(name) != ident_cache.end()) {
          return ident_cache[name];
        } else {
          // insert new name into ident_cache & return new number name
          Identifier* new_ident = new Identifier(name);
          ident_cache[name] = new_ident;
          return new_ident;
        }
      }

    }
  }
}
