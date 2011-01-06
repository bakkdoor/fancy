class Fancy Package {
  class Specification {
    @@specs = <[]>

    read_write_slots: ['author, 'email, 'include_files, 'bin_files,
                       'description, 'homepage, 'version]

    read_slots: ['package_name, 'dependencies, 'rubygem_dependencies]

    def initialize: @package_name with: block {
      @dependencies = []
      @rubygem_dependencies = []
      @include_files = []
      @bin_files = []

      block call_with_receiver: self

      @@specs at: @package_name put: self
    }

    def dependencies: dependencies {
      dependencies each: |d| {
        name = d first
        version = d second
        { version = 'latest } unless: version
        dep = Dependency new: name version: version
        @dependencies << dep
      }
    }

    def ruby_dependencies: dependencies {
      dependencies each: |d| {
        gem_name = d first
        version = d second
        { version = 'latest } unless: version
        dep = RubyDependency new: gem_name version: version
        @rubygem_dependencies << dep
      }
    }

    def add_dependency: name version: version ('latest) {
      dep = Dependency new: name version: version
      @dependencies << dep
    }

    def add_ruby_dependency: gem_name version: version ('latest) {
      dep = RubyDependency new: gem_name version: version
      @rubygem_dependencies << dep
    }

    def self [] package_name {
      @@specs[package_name]
    }
  }
}
