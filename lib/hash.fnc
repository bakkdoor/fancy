def class Hash {
  def empty? {
    self size == 0
  }

  def [] key {
    self at: key
  }
}
