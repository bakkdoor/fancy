package: Fancy::Lang

def class Class {
  def define_slot_reader: slotname {
    define_method: slotname with: {
      get_slot: slotname
    }
  }

  def define_slot_writer: slotname {
    define_method: "#{slotname}:" with: |val| {
      set_slot: slotname with: val
    }
  }
  
  def read_slots: slots {
    slots each: |s| {
      define_slot_reader: s
    }
  }

  def write_slots: slots {
    slots each: |s| {
      define_slot_writer: s
    }
  }

  def read_write_slots: slots {
    slots each: |s| {
      define_slot_reader: s
      define_slot_writer: s
    }
  }
}
