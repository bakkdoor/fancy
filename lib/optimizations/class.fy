class Class {
  def define_slot_writer: slotname {
    class_eval: $ "def " << slotname << ": val { @" << slotname << " = val }"
  }

  def define_slot_reader: slotname {
    class_eval: $ "def " << slotname << "{ @" << slotname << " }"
  }
}
