class Fancy Package {
  class Dependency {
    read_slots: ['name, 'version]

    def initialize: @name version: @version ('latest) {
    }
  }

  class RubyDependency {
    read_slots: ['gem_name, 'version]

    def initialize: @gem_name version: @version ('latest) {
    }
  }
}
