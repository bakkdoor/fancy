# Load all of fancy.
require: "boot"

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

  def self main {
    """
     FDoc will load all .fy files you give to it, and optionally run
     any specified FancySpec, and later produce documentation output.
    """

    output_dir = OUTPUT_DIR
    ARGV for_option: "-o" do: |d| { output_dir = d }
    require("fileutils")
    FileUtils mkdir_p(output_dir)

    # Currently we just load any files given on ARGV.
    ARGV each: |file| { Fancy CodeLoader load_compiled_file(file) }

    # by now simply produce a apidoc/fancy.jsonp file.
    json = JSON new: @documented_objects
    json write: (File expand_path("fancy.jsonp", output_dir))

    ["Open your browser at " ++ output_dir ++ "index.html.",
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
        [is_class, is_method, is_block] all? |b| { b call: [o] == false }
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
      match obj -> {
        case Hash -> self hash_to_json: obj
        case Array -> self array_to_json: obj
        case Symbol -> self symbol_to_json: obj
        case String -> self string_to_json: obj
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
        mdoc if_do: {
          mattr at: 'doc put: $ mdoc format: 'markdown
          mdoc meta if_do: {
            mattr at: 'arg put: $ mdoc meta at: 'argnames
          }
        }
        exec class() == Rubinius CompiledMethod . if_true: {
          relative_file = exec file()
          # HACK: We simply delete everything before lib/
          # TODO: Fix, either use a -r (root) option or use __FILE__
          relative_file = relative_file to_s gsub(r{.*lib}, "lib")
          lines = exec lines() to_a()
          mattr at: 'file put: $ relative_file
          # TODO calculate line numbers from compiled method
          # right now we export all line numbers to json
          mattr at: 'lines put: $ lines
        }
        attr[(type ++ "s") intern()] at: n put: mattr
      }
    }

    def generate_map {
      map = <['title => "Fancy Documentation", 'date => Time now() to_s(),
              'classes => <[]>, 'methods => <[]>, 'objects => <[]> ]>

      methods = @methods dup()

      @classes each: |cls| {
        name = cls name() gsub("::", " ")
        doc = Fancy Documentation for: cls
        attr = <[
          'doc => doc format: 'markdown,
          'instance_methods => <[]>,
          'methods => <[]>,
          'ancestors => cls ancestors() map: |c| { c name() gsub("::", " ") }
        ]>
        popuplate_methods: cls on: attr type: 'instance_method known: methods
        popuplate_methods: cls on: attr type: 'method known: methods
        map['classes] at: name put: attr
      }

      methods each: |cm| {
        cls = cm scope() module()
        cls_name = cls name() gsub("::", " ")
        cls_attr = map['classes] at: cls_name

        full_name = cls_name ++ "#" ++ (cm name())

        doc = Fancy Documentation for: cm
        attr = <[
          'args => doc meta at: 'argnames,
          'doc => doc format: 'markdown
        ]>

        map['methods] at: full_name put: attr
      }

      map
    }


    def write: filename call: name = "fancy.fdoc" {
      map = self generate_map
      json = self to_json: map
      js = "(function() { " ++ name ++ "(" ++ json ++ "); })();"
      File open: filename modes: ['write] with: |out| { out print: js }
    }

  }

}

Fancy FDoc main
