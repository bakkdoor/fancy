class Fancy Package {
  class Uninstaller : Handler {
    """
    @Fancy::Package@ Uninstaller.
    """

    def run {
      load_fancypack: |spec| {
        Specification delete_specification: spec from: $ Fancy Package package_list_file
        delete_package_dir
        delete_lib_file: (spec package_name)
        "Successfully uninstalled package #{spec package_name} with version: #{spec version}." println
      } else: {
        System abort: "No package found for #{@package_name} with version '#{@version}'."
      }
    }

    def delete_package_dir {
      require("fileutils")
      if: (Directory exists?: installed_path) then: {
        "Deleting directory: #{installed_path}" println
        FileUtils rm_rf(installed_path)
      }
    }

    def delete_lib_file: package_name {
      lib_file = "#{lib_path}/#{package_name}"
      "Deleting: #{lib_file}" println
      File delete!: lib_file
    }
  }
}
