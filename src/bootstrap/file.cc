#include "includes.h"

#include "../file.h"
#include "../array.h"
#include "../block.h"
#include "../string.h"
#include "../fancy_exception.h"
#include "../errors.h"

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

      DEF_CLASSMETHOD(FileClass,
                      "delete:",
                      "Deletes a File with a given filename if it exists. \
If given an Array of filenames, deletes all Files with the given filenames. \
Raises an IOError if any File to be deleted does not exist.",
                      delete);

      DEF_CLASSMETHOD(FileClass,
                      "rename:to:",
                      "Renames a file with a given filename to another filename.",
                      rename__to);

      DEF_CLASSMETHOD(FileClass,
                      "directory?:",
                      "Indicates, if the given filename refers to a Directory.",
                      is_directory);

      /**
       * File instance methods
       */

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
      FancyObject* arg1 = args[0];
      FancyObject* arg2 = args[1];
      FancyObject* arg3 = args[2];

      if(!(IS_STRING(arg1) && IS_ARRAY(arg2) && IS_BLOCK(arg3))) {
        errorln("File##open:modes:with: expects String, Array and Block value");
        return nil;
      }
  
      string filename = dynamic_cast<FancyString*>(arg1)->value();
      Array* modes = dynamic_cast<Array*>(arg2);
      Block* block = dynamic_cast<Block*>(arg3);  
      File* file = new File(filename, modes); 
      file->open();

      if(!file->good()) {
        file->close();
        throw new IOError("Could not open file: ", filename, modes);
      }

      // handle exceptions that get raised within the block and make
      // sure, the file gets closed at all times to avoid resource leaks.
      FancyObject* call_args[1] = { file };
      try {
        block->call(self, call_args, 1, scope);
      } catch(FancyException* ex) {
        file->close();
        throw ex;
      }
      file->close();
      return nil;
    }

    CLASSMETHOD(FileClass, open__modes)
    {
      EXPECT_ARGS("File##open:modes:", 2);
      FancyObject* arg1 = args[0];
      FancyObject* arg2 = args[1];
  
      if(!(IS_STRING(arg1) && IS_ARRAY(arg2))) {
        errorln("File##open:modes: expects String and Array value");
        return nil;
      }

      string filename = dynamic_cast<FancyString*>(arg1)->value();
      Array* modes = dynamic_cast<Array*>(arg2);
      // FILE *f = fopen(filename.c_str(), mode.c_str());
      File* file = new File(filename, modes);
      file->open();

      if(!file->good()) {
        file->close();
        throw new IOError("Could not open file: ", filename, modes);
      }
  
      return file;
    }

    CLASSMETHOD(FileClass, delete)
    {
      EXPECT_ARGS("File##delete:", 1);
      FancyObject* arg = args[0];
  
      if(!(IS_STRING(arg) || IS_ARRAY(arg))) {
        errorln("File##delete: expects String or Array value");
        return nil;
      }

      // single filename
      if(FancyString* filename = dynamic_cast<FancyString*>(arg)) {
        if(remove(filename->value().c_str()) == 0) {
          return t;
        } else {
          throw new IOError(string("Could not delete file: "), filename->value());
        }
      } else if(Array* filenames = dynamic_cast<Array*>(arg)) {
        // Array of filenames
        for(unsigned int i = 0; i < filenames->size(); i++) {
          string filename = filenames->at(i)->to_s();
          if(remove(filename.c_str()) == 0) {
            return t;
          } else {
            throw new IOError(string("Could not delete file: "), filename);
          }
        }
      }
      return t;
    }

    CLASSMETHOD(FileClass, rename__to)
    {
      EXPECT_ARGS("File##rename:to:", 2);
      string oldname = args[0]->to_s();
      string newname = args[1]->to_s();
      if(rename(oldname.c_str(), newname.c_str()) == 0) {
        return t;
      } else {
        throw new IOError(string("Could not rename file: "), oldname);
      }
    }

    CLASSMETHOD(FileClass, is_directory)
    {
      EXPECT_ARGS("File##directory?:", 1);
      string filename = args[0]->to_s();
      // check the status of the filename
      struct stat st_buf;
      if(stat(filename.c_str(), &st_buf) == 0) {
        if (S_ISDIR (st_buf.st_mode)) {
          return t;
        }
      }
      return nil;
    }

    /**
     * File instance methods
     */

    METHOD(FileClass, write)
    {
      EXPECT_ARGS("File#write:", 1);
      File* file = dynamic_cast<File*>(self);
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
      File* file = dynamic_cast<File*>(self);
      if(file) {
        // fprintf(file->file(), "\n");
        file->file() << endl;
      }
      return self;
    }

    METHOD(FileClass, is_open)
    {
      File* file = dynamic_cast<File*>(self);
      if(file) {
        if(file->is_open())
          return t;
        return nil;
      }
      return nil;
    }

    METHOD(FileClass, close)
    {
      File* file = dynamic_cast<File*>(self);
      if(file) {
        file->close();
      }
      return nil;
    }

    METHOD(FileClass, is_eof)
    {
      File* file = dynamic_cast<File*>(self);
      if(file && !file->eof()) {
          return nil;
      }
      return t;
    }

    METHOD(FileClass, modes)
    {
      File* file = dynamic_cast<File*>(self);
      if(file) {
        return file->modes();
      }
      return new Array();
    }

    METHOD(FileClass, readln)
    {
      File* file = dynamic_cast<File*>(self);
      if(file && file->is_open()) {
        string line;
        getline(file->file(), line);
        return FancyString::from_value(line);
      }
      return nil;
    }

  }
}
