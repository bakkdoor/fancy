class Hash {
  """
  Class for Hashes (HashMaps / Dictionaries).
  Maps a key to a value.
  """

  include: FancyEnumerable

  def [] key {
    "Returns the value for a given key."

    at: key
  }

  def each: block {
    "Calls a given Block with each key and value."

    if: (block argcount == 1) then: {
      keys each: |key| {
        block call: [[key, at: key]]
      }
    } else: {
      keys each: |key| {
        block call: [key, at: key]
      }
    }
  }

  def each_key: block {
    "Calls a given Block with each key."

    keys each: |key| {
      block call: [key]
    }
  }

  def each_value: block {
    "Calls a given Block with each value."

    values each: |val| {
      block call: [val]
    }
  }

  def to_a {
    "Returns an Array of the key-value pairs in a Hash."

    map: |pair| { pair }
  }

  def to_s {
    "Returns a string representation of a Hash."

    to_a to_s
  }
}
