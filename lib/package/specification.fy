class Fancy Package {
  class Specification {
    @@specs = <[]>

    read_write_slots: ['author, 'email, 'include_files, 'bin_files,
                       'description, 'homepage, 'version, 'gh_user]

    read_slots: ['package_name, 'dependencies, 'rubygem_dependencies]

    def initialize: @package_name with: block {
      @dependencies = []
      @rubygem_dependencies = []
      @include_files = []
      @bin_files = []

      block call_with_receiver: self

      @@specs[@package_name]: self
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

    def to_s {
      "name=#{@package_name} version=#{@version} url=https://github.com/#{@gh_user}/#{@package_name}"
    }

    def self [package_name] {
      @@specs[package_name]
    }

    def self save: spec to: specs_file {
      File open: specs_file modes: ['append] with: |f| {
        f writeln: $ spec to_s
      }
    }

    def self delete: spec_name from: specs_file {
      File open: specs_file modes: ['read, 'write] with: |f| {
        f readlines reject: |l| { l includes?: "name=#{spec_name}" } . each: |l| {
          f writeln: l
        }
      }
    }
  }
}
