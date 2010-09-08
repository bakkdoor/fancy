#ifndef _UTILS_H_
#define _UTILS_H_

#include <iostream>
#include <vector>

using namespace std;

namespace fancy {

  /**
   * Prints a warning message to STDOUT.
   * @param message The warning message to output on STDOUT.
   * @return cout std::ostream reference for further usage, if needed.
   */
  ostream& warn(string message);

  /**
   * Prints a warning message to STDOUT, followed by a newline.
   * @param message The warning message to output on STDOUT.
   * @return cout std::ostream reference for further usage, if needed.
   */
  ostream& warnln(string message);

  /**
   * Prints an error message to STDERR.
   * @param message The warning message to output on STDERR.
   * @return cerr std::ostream reference for further usage, if needed.
   */
  ostream& error(string message);

  /**
   * Prints an error message to STDERR, followed by a newline.
   * @param message The warning message to output on STDERR.
   * @return cerr std::ostream reference for further usage, if needed.
   */
  ostream& errorln(string message);

  /**
   * Splits a string by a given seperator string and saves results in
   * results vector.
   * @param str The string to be splitted.
   * @param separator The seperator string to split by.
   * @param keep_empty Boolean indicating if empty strings are to be kept in the return vector.
   * @return Vector of substrings that are the result of splitting the input string.
   */
  vector<string> string_split(const string& str, const string& seperator, const bool keep_empty = true);

  /**
   * Replaces all occurences of what in the string with with.
   * @param what String to replace in.
   * @param what String to find and replace.
   * @param with String to replace all occurrances of what with.
   * @return String that hast the replacements done.
   */
  string string_replace(string& str, string& what, string& with);
}

#endif /* _UTILS_H_ */
