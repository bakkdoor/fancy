#ifndef _MODULE_H_
#define _MODULE_H_

class Module : public FancyObject
{
public:
  Module();
  Module(Class *klass);
  virtual ~Module();
  
  map<Identifier_p, Method_p> methods() const;
  map<Identifier_p, Method_p> class_methods() const;

  void define_method(Identifier_p name, Method_p method);
  void define_class_method(Identifier_p name, Method_p method);

  virtual OBJ_TYPE type() const;

protected:
  map<Identifier_p, Method_p> _methods;
  map<Identifier_p, Method_p> _class_methods;
};

typedef Module* Module_p;

#endif /* _MODULE_H_ */
