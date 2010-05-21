#ifndef _UTILS_H_
#define _UTILS_H_

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

}

#endif /* _UTILS_H_ */
