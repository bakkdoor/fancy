def class String {
  self include: Enumerable;

  def [] index {
    self at: index
  }
  
  def ++ other {
    self + (other to_s)
  }

  def empty? {
    self size == 0
  }

  def whitespace? {
    self empty? or: (self == " ")
  }

  def blank? {
    self all?: |c| { c whitespace? }
  }
}
