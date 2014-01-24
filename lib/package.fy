require: "package/handler"
require: "package/installer"
require: "package/dependency_installer"
require: "package/uninstaller"
require: "package/dependency"
require: "package/specification"
require: "package/list"

class Fancy Package {
  """

  The Fancy Package System.

  This class is used for installing and uninstalling fancy packages on
  the system.

  Example:

        $ fancy install bakkdoor/mongo.fy

  Will install the mongo.fy package from http://github.com/bakkdoor/mongo.fy
  in the latest released version or get the current HEAD (master
  branch) revision.

  You can then load the package in your source file via
        require: \"mongo.fy\"

  """

  ENV_PACKAGE_DIR_VAR       = "FANCY_PACKAGE_DIR"
  DEFAULT_FANCY_ROOT        = ENV["HOME"] ++ "/.fancy"
  DEFAULT_PACKAGES_PATH     = DEFAULT_FANCY_ROOT ++ "/packages"
  DEFAULT_PACKAGES_LIB_PATH = DEFAULT_PACKAGES_PATH ++ "/lib"
  DEFAULT_PACKAGES_BIN_PATH = DEFAULT_PACKAGES_PATH ++ "/bin"

  def self install: package_name version: version ('latest) {
    """
    @package_name Name of package to install.

    Installs a package with a given name.
    Expects package_name to be a string in the form of:
        user/repo
    Which would get the package code from github.com/user/repo
    """

    Installer new: package_name version: version . run
  }

  def self install_dependencies {
    """
    Installs dependencies found in .fancypack file in the current directory.
    If no .fancypack file is found, fails and quits.
    """

    DependencyInstaller new run
  }

  def self uninstall: package_name {
    """
    @package_name Name of package to uninstall.

    Uninstalls a package with a given name (if installed).
    """

    Uninstaller new: package_name . run
  }

  def self list_packages {
    """
    Lists (prints) all installed packages on this system.
    """

    Fancy Package List new: package_list_file . println
  }

  def self root_dir {
    """
    @return Fancy Package root install dir.
    """

    if: (ENV[ENV_PACKAGE_DIR_VAR]) then: |path| {
      return path
    } else: {
      return DEFAULT_PACKAGES_PATH
    }
  }

  def self package_list_file {
    """
    @return Path to installed_packages.txt @File@ on system.
    """

    "#{self root_dir}/installed_packages.txt"
  }

  def self add_to_loadpath {
    """
    Adds the Fancy Package install dir to the loadpath so you can
    easily @require: packages into your code.
    """

    root = Fancy Package root_dir
    Fancy CodeLoader push_loadpath: root
    Fancy CodeLoader push_loadpath: (root ++ "/lib")
  }
}
