module Fancy
  class CodeLoader
    @@load_path = []

    def self.load_error(filename)
      raise "LoadError: Can't find file: #{filename}"
    end

    def self.find_file(filename)
      unless File.exists? filename
        if File.exists?(filename + ".fy")
          return filename + ".fy"
        end
      else
        return filename
      end
      return nil
    end

    def self.filename_for(filename)
      if f = find_file(filename)
        return f
      else
        @@load_path.each do |p|
          begin
            if f = find_file(p + "/" + filename)
              return f
            end
          rescue
          end
        end
      end
      load_error filename
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
      else
        @@load_path << File.dirname(filename)
      end

      cl = Rubinius::CodeLoader.new(file)
      cm = cl.load_compiled_file(file, 0)

      script = cm.create_script(false)
      script.file_path = file

      MAIN.__send__ :__script__
    end
  end
end
