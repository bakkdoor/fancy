#ifndef _BOOTSTRAP_FILE_H_
#define _BOOTSTRAP_FILE_H_

namespace fancy {
  namespace bootstrap {

    void init_file_class();

    /**
     * File class methods
     */
    FancyObject_p class_method_File_open__modes__with(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p class_method_File_open__modes(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * File instance methods
     */
    FancyObject_p method_File_write(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_File_newline(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_File_is_open(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_File_close(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_File_eof(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_File_modes(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_File_readln(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_FILE_H_ */
