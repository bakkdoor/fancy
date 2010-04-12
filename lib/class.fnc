# package: Fancy::Lang

def class Class {
  def define_slot_reader: slotname {
    self define_method: slotname with: {
      self get_slot: slotname
    }
  }

  def define_slot_writer: slotname {
    self define_method: (slotname to_s + ":") with: |val| {
      self set_slot: slotname with: val
    }
  }
  
  def read_slots: slots {
    slots each: |s| {
      self define_slot_reader: s
    }
  }

  def write_slots: slots {
    slots each: |s| {
      self define_slot_writer: s
    }
  }

  def read_write_slots: slots {
    slots each: |s| {
      self define_slot_reader: s;
      self define_slot_writer: s
    }
  }
}
