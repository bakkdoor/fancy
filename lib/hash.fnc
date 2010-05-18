def class Hash {
  "Class for Hashes (HashMaps / Dictionaries). Maps a key to a value.";

  def empty? {
    "Returns true, if the Hash is empty.";

    self size == 0
  }

  def [] key {
    "Returns the value for a given key.";

    self at: key
  }
}
