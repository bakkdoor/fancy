require: "package/installer"
require: "package/uninstaller"

class Fancy Package {

  ENV_PACKAGE_DIR_VAR = "FANCY_PACKAGE_DIR"

  def self install: package_name {
    Installer new: package_name . run
  }

  def self uninstall: package_name {
    Uninstaller new: package_name . run
  }

  def self package_root_dir {
    ENV[ENV_PACKAGE_DIR_VAR] if_do: |path| {
      return path
    } else: {
      return Fancy Package Installer DEFAULT_PACKAGES_PATH
    }
  }

  def self add_to_loadpath {
    root = Fancy Package package_root_dir
    Fancy CodeLoader push_loadpath: root
    Fancy CodeLoader push_loadpath: (root ++ "/lib")
  }
}
