class Fancy Package {
  class List {
    def initialize: @package_list_file {
    }

    def println {
      File open: @package_list_file modes: ['read] with: |f| {
        f readlines each: |l| {
          match l -> {
            case /(.*) : version=(.*) url=(.*)/ -> |_, name, version, url|
              "#{name} (#{version})" println
          }
        }
      }
    }
  }
}