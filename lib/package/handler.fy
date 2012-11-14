class Fancy Package {
  class Handler {
    read_write_slots: ('user, 'repository, 'version)

    def initialize: @package_name install_path: @install_path (ENV["FANCY_PACKAGE_DIR"]) {
      splitted = @package_name split: "/"
      @user, @repository = splitted

      # check for version, e.g. when passing in:
      # $ fancy install bakkdoor/fyzmq=1.0.1
      splitted = @repository split: "="
      if: (splitted size > 1) then: {
        @repository, @version = splitted
        @package_name = @user + "/" + @repository
      } else: {
        @version = 'latest
      }

      @install_path if_nil: {
        @install_path = Fancy Package DEFAULT_PACKAGES_PATH
        Directory create!: $ Fancy Package DEFAULT_FANCY_ROOT
        Directory create!: $ Fancy Package DEFAULT_PACKAGES_PATH
        Directory create!: $ Fancy Package DEFAULT_PACKAGES_LIB_PATH
        Directory create!: $ Fancy Package DEFAULT_PACKAGES_BIN_PATH
        Directory create!: $ Fancy Package DEFAULT_PACKAGES_PATH ++ "/downloads"
      }

      @download_path = @install_path ++ "/downloads"
    }

    def load_fancypack: success_block else: else_block ({}) {
      """
      Loads the @.fancypack file within the downloaded package directory.
      If no @.fancypack file is found, raise an error.
      """

      spec = nil
      if: (Dir glob(installed_path ++ "/*.fancypack") first) then: |fpackfile| {
        spec = File eval: fpackfile
      }
      if: spec then: success_block else: else_block
    }

    def installed_path {
      "#{@install_path}/#{@user}_#{@repository}-#{@version}"
    }

    def lib_path {
      @install_path + "/lib"
    }

    def bin_path {
      @install_path + "/bin"
    }

    def installed_bin_symlinks: spec {
      spec bin_files map: |bf| {
        "#{bin_path}/#{File basename(bf)}"
      }
    }
  }
}