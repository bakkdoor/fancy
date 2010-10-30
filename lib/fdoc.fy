# FDoc is a tool to generate API documentation from Fancy source.
#
# Works as follows:
#
#  1. We setup a handler to be invoked every time an object is set documentation
#  2. We load boot.fy, so we get documentation for all fancy's lib.
#  3. We run FDoc main
#     which can possibly load any file/directory you specify and optionally
#     run specs, effectively associating them with documented objects.
#  4. Generate output file.
#     Currently the plan is to output a json formatted object.
#     To be loaded by an html file and use jquery to build a GUI from it.

class Fancy FDoc {
  # A hash to keep all objects to extract documentation from.
  # Having this hash only for FDoc is fine IMHO. As we dont need
  # to use ObjectSpace or anything like that. Just to produce docs.
  @documented_objects = <[]>
  Fancy Documentation on_documentation_set: |object, documentation| {
    @documented_objects at: object put: documentation
  }
}

# Load all of fancy.
require: "boot"

class Fancy FDoc {

  "FDoc is an API documentation generator for Fancy."

  def self main {
    """
     FDoc will load all .fy files you give to it, and optionally run
     any specified FancySpec, and later produce documentation output.
    """

    # Currently we just load any files given on ARGV.
    ARGV each: |file| { Fancy CodeLoader load_compiled_file(file) }

    # by now simply produce a tools/fdoc/fancy.json file.
    json = JSON new: @documented_objects
    json write: "tools/fdoc/fancy.jsonp"

    ["Open your browser at tools/fdoc/fancy.html.",
     " (" ++ (json classes size) ++ ") classes. ",
     " (" ++ (json methods size) ++ ") methods. ",
     " (" ++ (json objects size) ++ ") other objects. "] println
  }


  class JSON {

    read_slots: ['classes, 'methods, 'objects]

    def initialize: documented {
      @documented_objects = documented

      is_class = |o| { o kind_of?: Module }
      is_method = |o| { o kind_of?: Rubinius::CompiledMethod }
      all_other = |o| {
        [is_class, is_method] all? |b| { b call: [o] == false }
      }

      @classes = @documented_objects keys select: is_class
      @methods = @documented_objects keys select: is_method
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
      str << ["}"]
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

    def generate_map {
      map = <['title => "Fancy Documentation", 'date => Time now() to_s(),
              'classes => <[]>, 'methods => <[]>, 'objects => <[]> ]>

      @classes each: |cls| {
        attr = <[
          'doc => cls documentation,
          'instance_methods => cls instance_methods(false),
          'singleton_methods => cls methods(false)
        ]>

        map['classes] at: (cls name()) put: attr
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
