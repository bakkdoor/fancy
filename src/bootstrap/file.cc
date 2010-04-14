#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_file_class()
    {
      FileClass->def_class_method("open:mode:with:", new NativeMethod("open:mode:with:", class_method_File_open__mode__with, 3));
      FileClass->def_class_method("open:mode:", new NativeMethod("open:mode:", class_method_File_open__mode, 2));
      FileClass->def_method("write:", new NativeMethod("write:", method_File_write, 1));
      FileClass->def_method("newline", new NativeMethod("newline", method_File_newline, 0));
      FileClass->def_method("open?", new NativeMethod("open?", method_File_is_open, 0));
      FileClass->def_method("close", new NativeMethod("close", method_File_close, 0));
      FileClass->def_method("eof?", new NativeMethod("eof?", method_File_eof, 0));
      FileClass->def_method("readln", new NativeMethod("readln", method_File_readln, 0));
    }


    /**
     * File class methods
     */

    FancyObject_p class_method_File_open__mode__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("File##open:mode:with:", 3);
      FancyObject_p arg1 = args.front();
      args.pop_front();
      FancyObject_p arg2 = args.front();
      args.pop_front();
      FancyObject_p arg3 = args.front();

      if(!(IS_STRING(arg1) && IS_STRING(arg2) && IS_BLOCK(arg3))) {
        errorln("File##open:mode:with: expects String, String and Block value");
        return nil;
      }
  
      string filename = dynamic_cast<String_p>(arg1)->value();
      string mode = dynamic_cast<String_p>(arg2)->value();
      Block_p block = dynamic_cast<Block_p>(arg3);  
      // FILE *f = fopen(filename.c_str(), mode.c_str());
      File_p file = new File(filename, fstream::in | fstream::out); 
      file->open();

      // if(!file->good()) {
      //   error("Could not open file: ")
      //     << filename
      //     << " with mode: "
      //     << mode
      //     << endl;
      //   return nil;
      // }
  
      block->call(self, list<FancyObject_p>(1, file), scope);
      file->close();
      return nil;
    }

    FancyObject_p class_method_File_open__mode(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("File##open:mode:", 2);
      FancyObject_p arg1 = args.front();
      args.pop_front();
      FancyObject_p arg2 = args.front();
  
      if(!(IS_STRING(arg1) && IS_STRING(arg2))) {
        errorln("File##open:mode: expects String and String value");
        return nil;
      }

      string filename = dynamic_cast<String_p>(arg1)->value();
      string mode = dynamic_cast<String_p>(arg2)->value();
      // FILE *f = fopen(filename.c_str(), mode.c_str());
      File_p file = new File(filename, fstream::in | fstream::out);
      file->open();

      // if(!file->good()) {
      //   error("Could not open file: ")
      //     << filename
      //     << " with mode: "
      //     << mode
      //     << endl;
      //   return nil;
      // }
  
      return file;
    }


    /**
     * File instance methods
     */

    FancyObject_p method_File_write(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("File#write:", 1);
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        // fprintf(file->file(), "%s", args.front()->to_s().c_str())
        fstream fs = file->file();
        fs << args.front()->to_s();
      }
      return self;
    }

    FancyObject_p method_File_newline(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        // fprintf(file->file(), "\n");
        file->file() << endl;
      }
      return self;
    }

    FancyObject_p method_File_is_open(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        if(file->is_open())
          return t;
        return nil;
      }
      return nil;
    }

    FancyObject_p method_File_close(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file) {
        file->close();
      }
      return nil;
    }

    FancyObject_p method_File_eof(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file && file->eof()) {
          return t;
      }
      return nil;
    }

    FancyObject_p method_File_readln(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      File_p file = dynamic_cast<File_p>(self);
      if(file && file->is_open()) {
        string line;
        getline(file->file(), line);
      }
      return nil;
    }

  }
}
