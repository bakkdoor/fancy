def class Hash {
  "Class for Hashes (HashMaps / Dictionaries). Maps a key to a value.";

  self include: Enumerable;

  def [] key {
    "Returns the value for a given key.";

    self at: key
  }

  def each: block {
    "Calls a given Block with each key and value.";

    (block argcount == 1) if_true: {
      self keys each: |key| {
        block call: [[key, self at: key]]
      }
    } else: {
      self keys each: |key| {
        block call: [key, self at: key]
      }
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

  def to_a {
    self map: |pair| { pair }
  }

  def to_s {
    self to_a to_s
  }
}
