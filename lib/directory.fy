class Directory {
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
