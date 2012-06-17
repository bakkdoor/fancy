# Load all of fancy.
require: "boot"
require: "option_parser"

class Fancy FDoc {
  """

  FDoc is a tool to generate API documentation from Fancy source.

  Works as follows:

   1. We setup a handler to be invoked every time an object is set documentation
      See fdoc_hook.fy, its loaded even before all of lib/rbx/*.fy so we can
      Also have documentation for all fancy rubinius.
   2. We load boot.fy, so we get documentation for all fancy's lib.
   3. We run FDoc main
      which can possibly load any file/directory you specify and optionally
      run specs, effectively associating them with documented objects.
   4. Generate output file.
      Currently the plan is to output a json formatted object.
      To be loaded by an html file and use jquery to build a GUI from it.

  """

  OUTPUT_DIR = "doc/api/"
  FANCY_ROOT_DIR = __FILE__ relative_path: "../"

  def self main {
    """
     FDoc will load all .fy files you give to it, and optionally run
     any specified FancySpec, and later produce documentation output.
    """

    output_dir = OUTPUT_DIR
    with_stdlib = false

    OptionParser new: @{
      remove_after_parsed: true
      banner: "Usage: fdoc [options] [source_files]\nOptions:"

      with: "-o [output_dir]" doc: "Sets output directory of generated documentation page, defaults to #{output_dir}" do: |dir| {
        output_dir = dir
      }

      with: "--with-stdlib" doc: "Include Fancy's standard library in generated documentation" do: {
        with_stdlib = true
      }
    } . parse: ARGV

    if: with_stdlib then: {
      @objects_to_remove = <[]>
    } else: {
      @objects_to_remove = @documented_objects dup
    }

    output_dir = File absolute_path: output_dir . + "/"

    require("fileutils")
    FileUtils mkdir_p(output_dir)

    # check if we're in Fancy's root dir
    # if not, copy fdoc related files over to output_dir
    unless: (output_dir relative_path: "../" == FANCY_ROOT_DIR) then: {
      files = Dir list: "#{FANCY_ROOT_DIR}/doc/api/*" . reject: |f| { f =~ /fancy\.jsonp$/ }
      FileUtils cp(files, output_dir)
    }

    # Currently we just load any files given on ARGV.
    ARGV each: |file| { Fancy CodeLoader load_compiled_file(file) }

    @documented_objects = @documented_objects select_keys: |k| { @objects_to_remove includes?: k . not }

    # by now simply produce a apidoc/fancy.jsonp file.
    json = JSON new: @documented_objects
    json write: (File expand_path("fancy.jsonp", output_dir))

    ["Open your browser at " ++ output_dir ++ "index.html ",
     " " ++ (json classes size) ++ " classes. ",
     " " ++ (json methods size) ++ " methods. ",
     " " ++ (json objects size) ++ " other objects. "] println
  }


  class JSON {

    read_slots: ['classes, 'methods, 'blocks, 'objects]

    def initialize: documented {
      @documented_objects = documented

      is_class = |o| { o kind_of?: Module }
      is_method = |o| { o kind_of?: Rubinius CompiledMethod }
      is_block = |o| { o kind_of?: Rubinius BlockEnvironment }
      all_other = |o| {
        [is_class, is_method, is_block] all?() |b| { b call: [o] == false }
      }

      @classes = @documented_objects keys select: is_class
      @methods = @documented_objects keys select: is_method
      @blocks =  @documented_objects keys select: is_block
      @objects = @documented_objects keys select: all_other
    }

    def string_to_json: obj { obj to_s inspect }
    def symbol_to_json: obj { obj to_s }

    def array_to_json: obj {
      str = ["["]
      obj each: |i| { str << $ to_json: i } in_between: { str << ", " }
      str << ["]"]
      str join
    }

    def hash_to_json: obj {
      str = ["{"]
      keys = obj keys
      keys each: |i| {
        str << $ to_json: i
        str << ":"
        str << $ to_json: (obj at: i)
      } in_between: { str << ", " }
      str << "}"
      str join
    }

    def to_json: obj {
      # Reimplement now we have pattern matching dispatch.
      match obj {
        case Hash -> hash_to_json: obj
        case Array -> array_to_json: obj
        case Symbol -> symbol_to_json: obj
        case String -> string_to_json: obj
        case Numeric -> obj
        case nil -> "null"
        case _ -> "Dont know how to convert " ++ (obj inspect) ++ " to JSON" raise!
      }
    }

    def popuplate_methods: cls on: attr type: type known: methods {
      cls send(type ++ "s", false) each: |n| {
        mattr = <[]>
        exec = cls send(type, n) executable()
        methods delete(exec)
        mdoc = Fancy Documentation for: exec
        { next } unless: mdoc # skip methods with no documentation
        if: mdoc then: {
          mattr['doc]: $ mdoc format: 'fdoc
          if: (mdoc meta) then: {
            mattr['arg]: $ mdoc meta at: 'argnames
          }
        }
        if: (exec class() == Rubinius CompiledMethod) then: {
          relative_file = exec file()
          # HACK: We simply delete everything before lib/
          # TODO: Fix, either use a -r (root) option or use __FILE__
          relative_file = relative_file to_s gsub(/.*lib/, "lib")
          lines = exec lines() to_a()
          mattr['file]: $ relative_file
          # TODO calculate line numbers from compiled method
          # right now we only use the first line of code in the body.
          mattr['lines]: $ [exec definition_line, exec last_line]
        }
        attr[(type ++ "s") intern()] [n]: mattr
      }
    }

    def generate_map {
      map = <['title => "Fancy Documentation", 'date => Time now() to_s(),
              'classes => <[]>, 'methods => <[]>, 'objects => <[]> ]>

      methods = @methods dup()

      @classes each: |cls| {
        name = cls name gsub("::", " ")
        doc = Fancy Documentation for: cls
        attr = <[
          'doc => doc format: 'fdoc,
          'instance_methods => <[]>,
          'methods => <[]>,
          'ancestors => cls ancestors() map: |c| { c name() gsub("::", " ") }
        ]>
        popuplate_methods: cls on: attr type: 'instance_method known: methods
        popuplate_methods: cls on: attr type: 'method known: methods
        map['classes][name]: attr
      }

      methods each: |cm| {
        cls = cm scope() module()
        cls_name = cls name() gsub("::", " ")
        cls_attr = map['classes] at: cls_name

        full_name = cls_name ++ "#" ++ (cm name())

        doc = Fancy Documentation for: cm
        attr = <[
          'args => doc meta at: 'argnames,
          'doc => doc format: 'fdoc
        ]>

        map['methods][full_name]: attr
      }

      map
    }


    def write: filename call: name ("fancy.fdoc") {
      map = generate_map
      json = to_json: map
      js = "(function() { " ++ name ++ "(" ++ json ++ "); })();"
      File open: filename modes: ['write] with: |out| { out print: js }
    }

  }


  class Formatter {
    """
    A documentation formater intended to be used by @FDoc@.

    This formatter makes some transformations on a docstring
    and then converts it to html using markdown.
    """

    Fancy Documentation formatter: 'fdoc is: |d| { format: d }


    def self format: doc {
      str = doc to_s
      tags = <[ ]>
      str = str skip_leading_indentation
      str = remove_tags: str into: tags
      str = create_tags: str with: tags
      str = create_class_references: str
      str = create_method_references: str
      str = htmlize: str
      str = create_code: str
      str
    }

    def self create_class_references: str {
      """
      Creates class references for Fancy class names.
      A docstring may contain class names sorounded by @
      without space between the @.

      Nested classes can be indicated by using :: like
            Foo::Bar
      This will create references for both, @Foo and @Bar

      Instance methods should be written:
            Foo::Bar#baz

      Class methods should be written:
            Foo::Bar.baz

      Some examples:
      A simple class reference:
      @Fancy@

      Nested class reference:
      @Fancy::FDoc@

      A fancy method without arguments:
      @Fancy::FDoc::JSON#:generate_map@

      A ruby method reference (will link to ruby docs if available)
      @String#split@

      A fancy method with many arguments:
      @Fancy::Package::Installer#initialize:version:install_path:@

      A singleton method:
      @Fancy::FDoc::Formatter~format:@
      """
      str gsub(/@[A-Z][^\r\n\s]+?@/) |cstr| {
       names = cstr slice(1, cstr size() - 2) split("::")
       refs = []
       names each_with_index() |name, idx| {
         n = name split(/[\#\~]/)
         clas = names take(idx) + [n[0]] . join(" ")
         html = "<code data-lang=\"fancy\" data-class-ref=\"" ++ .
              clas ++ "\" class=\"class-ref selectable\">" ++ (n[0]) ++ "</code>"
         refs << html

         # Generate a reference for last method if availble.
         if: (n[1]) then: {
           method = n[1]
           if: (method start_with?(":")) then: {
             method = method sub(/^:/, "")
           }
           sigil = ""
           name =~ (Regexp.new("^#")) . if_true: { sigil = "<small>#</small>" }
           type = n[1] include?(":") . if_true: {
             if: (sigil == "") then: {
               "singleton-method-ref"
             } else: {
               "instance-method-ref"
             }
           } else: {
             if: (sigil == "") then: {
               "ruby-singleton-method-ref"
             } else: {
               "ruby-instance-method-ref"
             }
           }

           html = sigil ++ "<code data-lang=\"fancy\" data-" ++ type ++ "=\"" ++ .
              (n[1]) ++ "\" " ++ " data-owner-class=\"" ++ clas ++ "\" " ++ .
              "class=\"" ++ type ++ " selectable\">" ++ method ++ "</code>"
           refs << html
         }
       }
       refs join(" ")
      }
    }

    def self remove_tags: str into: map {
      ary = str split(/\r?\n/) map: |line| {
        m = /^@([a-z@]\S+?)\s+(.*)/ match(line)
        if: m then: {
          map[m[1]]: (m[2])
          nil
        } else: {
          line
        }
      }
      ary compact join("\n")
    }

    def self create_tags: str with: map {
      max_width = map map: @{ first size } . max
      tags = map map: |pair| {
        name = pair[0]
        value = pair[1]
        # make argument names all align nicely:
        name = name + ("&nbsp;" * (max_width - (name size)))
        "<div class=\"doctag\"><label> @#{name} </label><div>#{value}</div></div>"
      }
      str ++ "\n<div class=\"doctags\">" ++ (tags join()) ++ "</div>"
    }

    def self create_code: str {
      md = /<pre>/ match: str
      if: (md) then: {
        md = /<pre>/ match: str
        pre_code = md pre_match
        md = /</pre>/ match: $ md post_match
        code, post_code = md pre_match, md post_match

        pre_code = pre_code gsub(/@([^\s,@\]\)\{\}\.]+)/,
                                 "<code data-lang=\"fancy\">\\1</code>")
        post_code = post_code gsub(/@([^\s,@\]\)\{\}\.]+)/,
                                  "<code data-lang=\"fancy\">\\1</code>")

        "#{pre_code}<pre>#{code}</pre>#{post_code}"
      } else: {
        str gsub(/@([^\s,@\]\)\{\}\.]+)/,
                 "<code data-lang=\"fancy\">\\1</code>")
      }
    }

    def self htmlize: str {
      require("rubygems")
      require("rdiscount")
      RDiscount new(str) to_html()
    }

    def self create_method_references: str {
      # First methods ending with :
      str gsub(/@([a-z_:]+:)@/,
               "<code data-lang=\"fancy\" data-method=\"\\1\" class=\"selectable\">\\1</code>") .
      # fancy methods starting with : (argless fancy methods)
      gsub(/@:([a-z_]+)@/,
           "<code data-lang=\"fancy\" data-method=\":\\1\" class=\"selectable\">\\1</code>")
    }

  }

}

Fancy FDoc main
