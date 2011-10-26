class Fancy {
  class Package {
    class DependencyInstaller {
      def run {
        packfile = Dir glob("*.fancypack") first
        unless: packfile do: {
          *stderr* println: "No .fancypack file found. Quitting."
          return nil
        }

        require: packfile

        spec_name = packfile split: ".fancypack" . first
        if: (Specification[spec_name]) then: |s| {
          s dependencies each: |dep| {
            "Installing dependency: #{dep name} (#{dep version})" println
            Fancy Package install: (dep name) version: (dep version)
          }
        }
      }
    }
  }
}