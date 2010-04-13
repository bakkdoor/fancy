#ifndef _ERRORS_H_
#define _ERRORS_H_

namespace fancy {

  class UnknownIdentifierError
  {
  public:
    UnknownIdentifierError(const string &ident);
    ~UnknownIdentifierError();
  
    string identifier() const;
  
  private:
    string _identifier;
  };

}

#endif /* _ERRORS_H_ */
