class Struct {
  def Struct new: fields {
    struct = new(*fields)
    struct read_write_slots: fields

    def struct new: values {
      new(*values)
    }

    def struct new {
      new()
    }

    struct
  }
}
