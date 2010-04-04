def class String {
  def ++ other {
    self + (other to_s)
  };

  def inspect {
    "'" ++ self ++ "'"
  }
}
