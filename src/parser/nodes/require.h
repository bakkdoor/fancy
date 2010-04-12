#ifndef _PARSER_NODES_REQUIRE_H_
#define _PARSER_NODES_REQUIRE_H_

class RequireStatement : public Expression
{
public:
  RequireStatement(String_p filename);
  virtual ~RequireStatement();

  virtual OBJ_TYPE type() const;
  virtual FancyObject* eval(Scope *scope);

private:
  string _filename;
};

#endif /* _PARSER_NODES_REQUIRE_H_ */
