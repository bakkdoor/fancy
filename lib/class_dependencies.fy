class Class {
  class MissingClassDependenciesError : StandardError {
    read_slots: ('class_dependencies, 'depending_class)
    def initialize: @class_dependencies on: @depending_class {
      dependency_names = @class_dependencies values map: @{ name } inspect
      initialize: $ "Missing class dependencies: #{dependency_names} for class: #{@depending_class name}"
    }
  }

  read_write_slots: ('class_dependencies, 'missing_class_dependencies)

  def class_dependencies: dependencies {
    @class_dependencies = Set new: dependencies
    @missing_class_dependencies = @class_dependencies dup
  }

  def missing_dependencies? {
    @missing_class_dependencies empty? not
  }

  def setup_class_dependencies: dependency_mappings {
    @class_dependencies each: |dep_name| {
      if: (dependency_mappings[dep_name]) then: |class| {
        const_set(dep_name, class)
        @missing_class_dependencies remove: dep_name
      }
    }

    if: missing_dependencies? then: {
      MissingClassDependenciesError new: dependency_mappings on: self . raise!
    }
  }
}
