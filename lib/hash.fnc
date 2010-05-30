def class Hash {
  "Class for Hashes (HashMaps / Dictionaries). Maps a key to a value.";

  self include: Enumerable;

  def [] key {
    "Returns the value for a given key.";

    self at: key
  }

  def each: block {
    "Calls a given Block with each key and value.";

    self keys each: |key| {
      block call: [key, self at: key]
    }
  }

  def each_key: block {
    "Calls a given Block with each key.";

    self keys each: |key| {
      block call: key
    }
  }

  def each_value: block {
    "Calls a given Block with each value.";

    self values each: |val| {
      block call: val
    }
  }
}
