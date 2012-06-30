class Fancy Package {
  class Specification {
    @@specs = <[]>

    read_write_slots: ['author, 'email, 'include_files, 'bin_files,
                       'description, 'homepage, 'version, 'gh_user, 'package_name]

    read_slots: ['dependencies, 'ruby_dependencies]

    def initialize: @package_name with: block {
      @dependencies = []
      @ruby_dependencies = []
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
        @ruby_dependencies << dep
      }
    }

    def add_dependency: name version: version ('latest) {
      dep = Dependency new: name version: version
      @dependencies << dep
    }

    def add_ruby_dependency: gem_name version: version ('latest) {
      dep = RubyDependency new: gem_name version: version
      @ruby_dependencies << dep
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

    def self delete_specs_from: specs_file if: filter_block {
      lines = File read: specs_file . lines reject: filter_block
      File write: specs_file with: |f| {
        lines each: |l| { f writeln: l }
      }
    }

    def self delete: spec_name from: specs_file {
      delete_specs_from: specs_file if: @{ includes?: "name=#{spec_name}" }
    }

    def self delete_specification: spec from: specs_file {
      delete_specs_from: specs_file if: @{ includes?: "name=#{spec package_name} version=#{spec version}" }
    }
  }
}
