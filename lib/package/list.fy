class Fancy Package {
  class List {
    def initialize: @package_list_file {
    }

    def println {
      packages each: |p| {
        name, version, url = p
        "#{name} (#{version})" println
      }
    }

    def packages {
      packages = []
      try {
        File open: @package_list_file modes: ['read] with: |f| {
          f readlines each: |l| {
            l match: {
              case: /name=(.*) version=(.*) url=(.*)/ do: |_, name, version, url| {
                packages << (name, version, url)
              }
            }
          }
        }
      } catch IOError => e {
        # ignore file not found, as no packages might have been installed yet.
      }
      packages
    }

    def has_package?: package {
      packages any?: |p| { (p first, p second) == (package first, package second) } # ignore url for now
    }
  }
}