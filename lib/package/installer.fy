require("yaml")
require("open-uri")

class Fancy Package {
  class Installer {
    """

    @Fancy::Package@ installer.

    Downloads packages from Github (usually the latest tagged version,
    if no version is specified, or the latest HEAD revision in the
    master branch) and install it to the @FANCY_PACKAGE_DIR.

    """

    DEFAULT_FANCY_ROOT = ENV["HOME"] ++ "/.fancy"
    DEFAULT_PACKAGES_PATH = DEFAULT_FANCY_ROOT ++ "/packages"
    DEFAULT_PACKAGES_LIB_PATH = DEFAULT_PACKAGES_PATH ++ "/lib"

    def initialize: @package_name version: @version ("latest") install_path: @install_path (ENV["FANCY_PACKAGE_DIR"]) {
      """
      Creates a new @Package Installer@ for a given package name, an
      optional version (default is 'latest') and an optional
      installation path (default is the standard installation path for
      Fancy packages).
      """

      splitted = @package_name split: "/"
      @user = splitted first
      @repository = splitted second

      @install_path if_nil: {
        @install_path = DEFAULT_PACKAGES_PATH
        Directory create!: DEFAULT_FANCY_ROOT
        Directory create!: DEFAULT_PACKAGES_PATH
        Directory create!: DEFAULT_PACKAGES_LIB_PATH
        Directory create!: $ DEFAULT_PACKAGES_PATH ++ "/downloads"
      }

      @download_path = @install_path ++ "/downloads"
    }

    def run {
      """
      Runs the installer & installs the package into
      @$FANCY_PACKAGE_DIR.
      """

      filename = nil
      @version == "latest" if_true: {
        self latest_tag if_do: |tag| {
          @version = tag
        } else: {
          @version = "master"
        }
        filename = self download_tgz: @version
      }

      # now unpack & check for dependencies
      unpack_dir = unpack_file: filename
      rename_dir: unpack_dir
      self load_fancypack
    }

    def latest_tag {
      "Returns the latest tag (sorted alphabetically)."

      tags = self tags
      tags size > 0 if_true: {
        tags keys sort last
      }
    }

    def tags {
      "Returns a list of tags the repository has on Github."

      url = "http://github.com/api/v2/yaml/repos/show/" ++ @package_name ++ "/tags/"
      YAML load_stream(open(url)) documents() first at: "tags"
    }

    def download_url: version {
      """
      Returns the download url for a given version of the package
      to be installed.
      """

      "https://github.com/" ++ @package_name ++ "/tarball/" ++ version
    }

    def download_tgz: version {
      """
      Downloads the .tar.gz file from Github with the given version
      (tag or branch name) and saves it to the specified @install_path.


      The Default install_path is ~/.fancy/packages/.
      If an environment variable @FANCY_PACKAGE_DIR is defined, it
      will get used.
      """

      download_url = download_url: version
      ["Downloading ", @package_name, " version ", version, " from: ", download_url] join println

      filename = [@user, "_", @repository, "-", version, ".tar.gz"] join

      # run wget to get the .tar.gz file
      cmd = ["wget --quiet --no-check-certificate ", download_url, " -O ", @download_path, "/", filename] join
      System do: cmd

      filename
    }

    def unpack_file: filename {
      "Unpacking " ++ filename println
      output = System pipe: $ ["tar xvf ", @download_path, "/", filename, " -C ", @install_path, "/"] join
      dirname = output readline chomp
    }

    def installed_path {
      @install_path + "/" + @user + "_" + @repository + "-" + @version
    }

    def lib_path {
      @install_path + "/lib"
    }

    def rename_dir: dirname {
      """
      Renames a given directory to a common way within the install path.
      => It will rename the given dirname to $user/$repo-$version.
      """

      System do: $ ["mv ", @install_path, "/", dirname, " ", self installed_path] join
    }

    def load_fancypack {
      """
      Loads the @.fancypack file within the downloaded package directory.
      If no @.fancypack file is found, raise an error.
      """

      Dir glob(self installed_path ++ "/*.fancypack") first if_do: |fpackfile| {
        require: fpackfile
      }

      Specification[@repository] if_do: |spec| {
        fulfill_spec: spec
      } else: {
        "Something wen't wrong. Did not find a fancypack specification for package: " ++ @repository . raise!
      }
    }

    def fulfill_spec: spec {
      spec include_files empty? if_false: {
        File open: (self lib_path + "/" + (spec package_name)) modes: ['write] with: |f| {
          spec include_files each: |if| {
            f write: "require: \""
            f write: (self installed_path)
            f write: "/"
            f write: if
            f writeln: "\""
          }
        }
      }

      spec dependencies each: |dep| {
        Package install: dep
      }

      spec rubygem_dependencies each: |dep| {
        dep version == 'latest if_true: {
          System do: $ "gem install " ++ (dep gem_name)
        } else: {
          System do: $ "gem install -v=" ++ (dep version) ++ " " ++ (dep gem_name)
        }
      }
    }
  }
}
