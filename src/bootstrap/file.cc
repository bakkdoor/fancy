#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_file_class()
    {
      DEF_CLASSMETHOD(FileClass,
                      "open:modes:with:",
                      "Opens a File with a given filename, a modes Array and a block.\n\
E.g. to open a File with read access and read all lines and print them to STDOUT:\n\
File open: \"foo.txt\" modes: [:read] with: |f| {\n\
  { f eof? } while_false: {\n\
    f readln println\n\
  }\n\
}",
                      open__modes__with);

      DEF_CLASSMETHOD(FileClass,
                      "open:modes:",
                      "Opens a File with a given filename and modes Array.",
                      open__modes);

      DEF_METHOD(FileClass,
                 "write:",
                 "Writes an object to the File by calling its to_s method.",
                 write);

      DEF_METHOD(FileClass,
                 "newline",
                 "Writes a newline to the File.",
                 newline);

      DEF_METHOD(FileClass,
                 "open?",
                 "Returns true, if the File is correctly opened and nil otherwise.",
                 is_open);

      DEF_METHOD(FileClass,
                 "close",
                 "Closes the File.",
                 close);

      DEF_METHOD(FileClass,
                 "eof?",
                 "Returns true, if the File is at its end (EOF) and nil otherwise.",
                 is_eof);

      DEF_METHOD(FileClass,
                 "modes",
                 "Returns the modes Array with which the File is opened.",
                 modes);

      DEF_METHOD(FileClass,
                 "readln",
                 "Reads a line from the File and returns it as a String.",
                 readln);
    }


    /**
     * File class methods
     */

    CLASSMETHOD(FileClass, open__modes__with)
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

    CLASSMETHOD(FileClass, open__modes)
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

    METHOD(FileClass, write)
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

    METHOD(FileClass, newline)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        // fprintf(file->file(), "\n");
        file->file() << endl;
      }
      return self;
    }

    METHOD(FileClass, is_open)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        if(file->is_open())
          return t;
        return nil;
      }
      return nil;
    }

    METHOD(FileClass, close)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        file->close();
      }
      return nil;
    }

    METHOD(FileClass, is_eof)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file && !file->eof()) {
          return nil;
      }
      return t;
    }

    METHOD(FileClass, modes)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        return file->modes();
      }
      return new Array();
    }

    METHOD(FileClass, readln)
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
