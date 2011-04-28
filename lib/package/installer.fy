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
      @user, @repository = splitted

      # check for version, e.g. when passing in:
      # $ fancy install bakkdoor/fyzmq=1.0.1
      splitted = @repository split: "="
      if: (splitted size > 1) then: {
        @repository, @version = splitted
        @package_name = @user + "/" + @repository
      }

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
      if: (@version == "latest") then: {
        if: latest_tag then: |tag| {
          @version = tag
        } else: {
          @version = "master"
        }
      }

      plist = List new: (Fancy Package package_list_file)
      if: (plist has_package?: (@repository, @version)) then: {
        STDERR println: "Package #{@package_name} with version: #{@version} already installed. Aborting."
        return nil
      }

      filename = download_tgz: @version
      if: filename then: {
        # now unpack & check for dependencies
        unpack_dir = unpack_file: filename
        rename_dir: unpack_dir
        load_fancypack
      } else: {
        STDERR println: "Installation aborted."
        STDERR println: "Got error while trying to install #{@package_name} with version: #{@version}"
      }
    }

    def latest_tag {
      "Returns the latest tag (sorted alphabetically)."

      tags = self tags
      if: (tags size > 0) then: {
        tags keys sort last
      }
    }

    def tags {
      "Returns a list of tags the repository has on Github."

      url = "http://github.com/api/v2/yaml/repos/show/" ++ @package_name ++ "/tags/"
      YAML load_stream(open(url)) documents() first at: "tags"
    }

    def has_version?: version {
      "Indicates, if a given version is available on Github."

      match version {
        case "master" -> true
        case _ -> tags includes?: version
      }
    }

    def download_url: version {
      """
      Returns the download url for a given version of the package
      to be installed.
      """

      { "https://github.com/" ++ @package_name ++ "/tarball/" ++ version } if: $ has_version?: version
    }

    def download_tgz: version {
      """
      Downloads the .tar.gz file from Github with the given version
      (tag or branch name) and saves it to the specified @install_path.


      The Default install_path is ~/.fancy/packages/.
      If an environment variable @FANCY_PACKAGE_DIR is defined, it
      will get used.
      """

      if: (download_url: version) then: |download_url| {
        ["Downloading ", @package_name, " version ", version, " from: ", download_url] join println

        filename = [@user, "_", @repository, "-", version, ".tar.gz"] join

        # run curl to get the .tar.gz file
        cmd = ["curl -o ", @download_path, "/", filename, " -L -O ", download_url] join
        System do: cmd

        filename
      }
    }

    def unpack_file: filename {
      "Unpacking " ++ filename println
      System do: $ ["tar xf ", @download_path, "/", filename, " -C ", @install_path, "/"] join
      output = System pipe: $ ["tar tf ", @download_path, "/", filename] join
      dirname = output readlines first chomp
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

      System do: $ ["mv ", @install_path, "/", dirname, " ", installed_path] join
    }

    def load_fancypack {
      """
      Loads the @.fancypack file within the downloaded package directory.
      If no @.fancypack file is found, raise an error.
      """

      Dir glob(installed_path ++ "/*.fancypack") first if_true: |fpackfile| {
        require: fpackfile
      }

      if: (Specification[@repository]) then: |spec| {
        fulfill_spec: spec
        spec gh_user: @user
        Specification save: spec to: $ Fancy Package package_list_file
      } else: {
        "Something wen't wrong. Did not find a fancypack specification for package: " ++ @repository . raise!
      }
    }

    def fulfill_spec: spec {
      unless: (spec include_files empty?) do: {
        File open: (lib_path + "/" + (spec package_name)) modes: ['write] with: |f| {
          spec include_files each: |if| {
            f write: "require: \""
            f write: installed_path
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
        if: (dep version == 'latest) then: {
          System do: $ "rbx gem install " ++ (dep gem_name)
        } else: {
          System do: $ "rbx gem install -v=" ++ (dep version) ++ " " ++ (dep gem_name)
        }
      }
    }
  }
}
