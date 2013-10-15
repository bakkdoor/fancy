class Fancy {
  class Package {
    class DependencyInstaller {
      def run {
        packfile = Dir glob("*.fancypack") first
        unless: packfile do: {
          *stderr* println: "No .fancypack file found. Quitting."
          return nil
        }

        if: (File eval: packfile) then: |spec| {
          spec dependencies each: |dep| {
            "Installing dependency: #{dep name} (#{dep version})" println
            Fancy Package install: (dep name) version: (dep version)
          }
          spec ruby_dependencies each: |dep| {
            "Installing Ruby dependency: #{dep gem_name} (#{dep version})" println
            dep install
         }
        }
      }
    }
  }
}
