#ifndef _BOOTSTRAP_FILE_H_
#define _BOOTSTRAP_FILE_H_

namespace fancy {
  namespace bootstrap {

    void init_file_class();

    /**
     * File class methods
     */
    FancyObject_p class_method_File_open__mode__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p class_method_File_open__mode(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

    /**
     * File instance methods
     */
    FancyObject_p method_File_write(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_File_newline(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_File_is_open(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_File_close(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_FILE_H_ */
