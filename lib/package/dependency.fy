class Fancy Package {
  class Dependency {
    """
    Package Dependency.
    Represents a Dependency to another Package with a given version.
    """

    read_slots: ['name, 'version]

    def initialize: @name version: @version ('latest) {
    }
  }

  class RubyDependency {
    """
    Same as @Fancy::Package::Dependency@, just for rubygem packages.
    """

    read_slots: ['gem_name, 'version]

    def initialize: @gem_name version: @version ('latest) {
    }
  }
}
