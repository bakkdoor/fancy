class Directory {
  def self create: dirname {
    try {
      Dir mkdir(dirname)
    } catch Errno::EEXIST => e {
      IOError new: (e message) . raise!
    }
  }

  def self delete: dirname {
    try {
      Dir delete(dirname)
    } catch Exception => e {
      IOError new: (e message) . raise!
    }
  }
}
