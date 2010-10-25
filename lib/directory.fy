class Directory {
  """
  Instances of Directory represent Directories in the Filesystem of
  the Operating System, in which Fancy is being run.
  """

  def self exists?: dirname {
    "Indicates, if a Directory exists with a given pathname."
    (File exists?: dirname) and: (File directory?: dirname)
  }

  # def self delete: dirname {
  #   "Deletes a directory with a given name, if it's empty."
  #   File directory?: dirname . if_true: {
  #     File delete: dirname
  #   } else: {
  #     IOError message: "Pathname does not point to a Directory: " ++ dirname . raise!
  #   }
  # }

}
