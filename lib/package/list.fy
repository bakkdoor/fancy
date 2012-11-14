class Fancy Package {
  class List {
    def initialize: @package_list_file

    def println {
      packages each: |p| {
        name, version, url = p
        "#{name} (#{version}) - #{url}" println
      }
    }

    def packages {
      packages = []
      # ignore file not found, as no packages might have been installed yet.
      ignoring: IOError do: {
        File open: @package_list_file modes: ['read] with: |f| {
          f readlines each: |l| {
            match l {
              case /name=(.*) version=(.*) url=(.*)/ -> |_, name, version, url|
                packages << (name, version, url)
            }
          }
        }
      }
      packages
    }

    def has_package?: package {
      packages any?: |p| { (p first, p second) == (package first, package second) } # ignore url for now
    }
  }
}