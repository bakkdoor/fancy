class Struct {
  """
  Structs are light-weight classes with predefined read-writable slots.
  """

  def Struct new: slots {
    """
    @slots @Array@ of slotnames the new Struct should contain.

    Creates a new Struct class with the given slots.
    """

    struct = new(*slot)
    struct read_write_slots: slots

    def struct new: values {
      new(*values)
    }

    def struct new {
      new()
    }

    struct
  }
}
