module Fancy
  class CodeLoader
    def self.load_error(filename)
      raise "LoadError: Can't find file: #{filename}"
    end

    def self.filename_for(filename)
      unless File.exists? filename
        if File.exists?(filename + ".fy")
          return filename + ".fy"
        else
          load_error filename
        end
      else
        return filename
      end
    end

    def self.compiled_filename_for(filename)
      if filename =~ /.fyc$/
        return filename
      end
      if filename =~ /\.fy$/
        return filename + "c"
      else
        return (filename + ".compiled.rbc")
      end
    end

    def self.compile_file(f)
      filename = filename_for(f)
      compiled_file = compiled_filename_for(filename)

      unless File.exists? compiled_file
        system("bin/fancy -c #{filename} > /dev/null")
      end
    end

    def self.load_compiled_file(filename)
      file = compiled_filename_for(filename_for(filename))

      unless File.exists? file
        load_error file
      end

      cl = Rubinius::CodeLoader.new(file)
      cm = cl.load_compiled_file(file, 0)

      script = cm.create_script(false)
      script.file_path = file

      MAIN.__send__ :__script__
    end
  end
end
