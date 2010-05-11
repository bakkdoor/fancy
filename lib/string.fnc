def class String {
  self include: Enumerable;

  def [] index {
    self at: index
  }
  
  def ++ other {
    self + (other to_s)
  }
}
