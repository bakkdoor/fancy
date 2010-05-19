#include "includes.h"

namespace fancy {
  namespace bootstrap {

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

    void init_file_class()
    {
      FileClass->def_class_method("open:modes:with:",
                                  new NativeMethod("open:modes:with:",
                                                   "Opens a File with a given filename, a modes Array and a block.\n\
E.g. to open a File with read access and read all lines and print them to STDOUT:\n\
File open: \"foo.txt\" modes: [:read] with: |f| {\n\
  { f eof? } while_false: {\n\
    f readln println\n\
  }\n\
}",
                                                   class_method_File_open__modes__with));

      FileClass->def_class_method("open:modes:",
                                  new NativeMethod("open:modes:",
                                                   "Opens a File with a given filename and modes Array.",
                                                   class_method_File_open__modes));

      FileClass->def_method("write:",
                            new NativeMethod("write:",
                                             "Writes an object to the File by calling its to_s method.",
                                             method_File_write));

      FileClass->def_method("newline",
                            new NativeMethod("newline",
                                             "Writes a newline to the File.",
                                             method_File_newline));

      FileClass->def_method("open?",
                            new NativeMethod("open?",
                                             "Returns true, if the File is correctly opened and nil otherwise.",
                                             method_File_is_open));

      FileClass->def_method("close",
                            new NativeMethod("close",
                                             "Closes the File.",
                                             method_File_close));

      FileClass->def_method("eof?",
                            new NativeMethod("eof?",
                                             "Returns true, if the File is at its end (EOF) and nil otherwise.",
                                             method_File_eof));

      FileClass->def_method("modes",
                            new NativeMethod("modes",
                                             "Returns the modes Array with which the File is opened.",
                                             method_File_modes));

      FileClass->def_method("readln",
                            new NativeMethod("readln",
                                             "Reads a line from the File and returns it as a String.",
                                             method_File_readln));
    }


    /**
     * File class methods
     */

    FancyObject_p class_method_File_open__modes__with(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("File##open:modes:with:", 3);
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];
      FancyObject_p arg3 = args[2];

      if(!(IS_STRING(arg1) && IS_ARRAY(arg2) && IS_BLOCK(arg3))) {
        errorln("File##open:modes:with: expects String, Array and Block value");
        return nil;
      }
  
      string filename = dynamic_cast<String_p>(arg1)->value();
      Array_p modes = dynamic_cast<Array_p>(arg2);
      Block_p block = dynamic_cast<Block_p>(arg3);  
      File_p file = new File(filename, modes); 
      file->open();

      if(!file->good()) {
        file->close();
        throw new IOError("Could not open file: ", filename, modes);
      }

      // handle exceptions that get raised within the block and make
      // sure, the file gets closed at all times to avoid resource leaks.
      FancyObject_p call_args[1] = { file };
      try {
        block->call(self, call_args, 1, scope);
      } catch(FancyException_p ex) {
        file->close();
        throw ex;
      }
      file->close();
      return nil;
    }

    FancyObject_p class_method_File_open__modes(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("File##open:modes:", 2);
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];
  
      if(!(IS_STRING(arg1) && IS_ARRAY(arg2))) {
        errorln("File##open:modes: expects String and Array value");
        return nil;
      }

      string filename = dynamic_cast<String_p>(arg1)->value();
      Array_p modes = dynamic_cast<Array_p>(arg2);
      // FILE *f = fopen(filename.c_str(), mode.c_str());
      File_p file = new File(filename, modes);
      file->open();

      if(!file->good()) {
        file->close();
        throw new IOError("Could not open file: ", filename, modes);
      }
  
      return file;
    }


    /**
     * File instance methods
     */

    FancyObject_p method_File_write(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("File#write:", 1);
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        // fprintf(file->file(), "%s", args.front()->to_s().c_str())
        // fstream fs = file->file();
        file->file() << args[0]->to_s();
        file->file().flush();
      }
      return self;
    }

    FancyObject_p method_File_newline(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        // fprintf(file->file(), "\n");
        file->file() << endl;
      }
      return self;
    }

    FancyObject_p method_File_is_open(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        if(file->is_open())
          return t;
        return nil;
      }
      return nil;
    }

    FancyObject_p method_File_close(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        file->close();
      }
      return nil;
    }

    FancyObject_p method_File_eof(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file && !file->eof()) {
          return nil;
      }
      return t;
    }

    FancyObject_p method_File_modes(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        return file->modes();
      }
      return new Array();
    }

    FancyObject_p method_File_readln(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file && file->is_open()) {
        string line;
        getline(file->file(), line);
        return new String(line);
      }
      return nil;
    }

  }
}
