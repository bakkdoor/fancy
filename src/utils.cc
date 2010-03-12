#include "includes.h"

ostream& warn(string message)
{
  cout << "[WARNING] " << message;
  return cout;
}

ostream& warnln(string message)
{
  cout << "[WARNING] " << message << endl;
  return cout;
}

ostream& error(string message)
{
  cout << "[ERROR] " << message;
  return cout;
}

ostream& errorln(string message)
{
  cout << "[ERROR] " << message << endl;
  return cout;
}
