#ifndef _ERRORS_H_
#define _ERRORS_H_

namespace fancy {

  class UnknownIdentifierError : public FancyException
  {
  public:
    UnknownIdentifierError(const string &ident);
    ~UnknownIdentifierError();
  
    string identifier() const;
  
  private:
    string _identifier;
  };

  class MethodNotFoundError : public FancyException
  {
  public:
    MethodNotFoundError(const string &method_name, Class_p klass);
    ~MethodNotFoundError();
  
    string method_name() const;
    Class_p get_class() const;
  
  private:
    string _method_name;
    Class_p _class;
  };

  typedef MethodNotFoundError* MethodNotFoundError_p;

}

#endif /* _ERRORS_H_ */
