def class Class {
  def define_slot_reader: slotname {
    "Defines a slot reader method with a given name.";

    self define_method: slotname with: {
      self get_slot: slotname
    }
  }

  def define_slot_writer: slotname {
    "Defines a slot writer method with a given name.";

    self define_method: (slotname to_s + ":") with: |val| {
      self set_slot: slotname value: val
    }
  }

  def read_slots: slots {
    "Defines slot reader methods for all given slotnames.";

    slots each: |s| {
      self define_slot_reader: s
    }
  }

  def write_slots: slots {
    "Defines slot writer methods for all given slotnames.";

    slots each: |s| {
      self define_slot_writer: s
    }
  }

  def read_write_slots: slots {
    "Defines slot reader & writer methods for all given slotnames.";

    slots each: |s| {
      self define_slot_reader: s;
      self define_slot_writer: s
    }
  }

  def subclass?: class_obj {
    "Indicates, if a Class is a subclass of another Class.";

    (self == class_obj) if_true: {
      true
    } else: {
      # take care of Object class, as Object is its own superclass
      (self superclass != self) if_true: {
        self superclass subclass?: class_obj
      }
    }
  }
}
