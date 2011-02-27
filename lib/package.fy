require: "package/installer"
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

  ENV_PACKAGE_DIR_VAR = "FANCY_PACKAGE_DIR"

  def self install: package_name {
    """
    Installs a package with a given name.
    Expects package_name to be a string in the form of:
        user/repo
    Which would get the package code from github.com/user/repo
    """

    Installer new: package_name . run
  }

  def self uninstall: package_name {
    Uninstaller new: package_name . run
  }

  def self list_packages {
    Fancy Package List new: package_list_file . println
  }

  def self root_dir {
    if: (ENV[ENV_PACKAGE_DIR_VAR]) then: |path| {
      return path
    } else: {
      return Fancy Package Installer DEFAULT_PACKAGES_PATH
    }
  }

  def self package_list_file {
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
