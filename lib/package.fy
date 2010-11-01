require: "package/installer"
require: "package/uninstaller"

class Fancy Package {
  def self install: package_name {
    Installer new: package_name . run
  }

  def self uninstall: package_name {
    Uninstaller new: package_name . run
  }
}
