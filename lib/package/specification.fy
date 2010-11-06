class Fancy Package {
  class Specification {
    read_write_slots: ['author, 'email, 'include_files, 'bin_files,
                       'description, 'homepage, 'version]

    read_slots: ['dependencies, 'rubygem_dependencies]

    def initialize: @package_name with: block {
      @dependencies = []
      @rubygem_dependencies = []
      @include_files = []
      @bin_files = []

      block call_with_receiver: self
    }

    def add_dependency: name version: version = 'latest {
      dep = Dependency new: name version: version
      @dependencies << dep
    }

    def add_ruby_dependency: gem_name version: version = 'latest {
      dep = RubyDependency new: gem_name version: version
      @rubygem_dependencies << dep
    }
  }
}
