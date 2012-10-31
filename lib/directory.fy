class Directory {
  """
  Instances of @Directory@ represent directories in the filesystem of
  the operating system, in which Fancy is being run.
  """

  def self exists?: dirname {
    """
    @dirname Path of @Directory@ to check for existance.
    @@return @true, if @Directory@ exists, @false otherwise.

    Indicates, if a Directory exists with a given pathname.
    """

    (File exists?: dirname) && { File directory?: dirname }
  }
}
