class Class {
  def define_slot_writer: slotname {
    dynamic_method: ("#{slotname}:" to_sym) with: @{
      total_args: 1
      required_args: 1
      push_local(0)
      set_ivar("@#{slotname}" to_sym)
      ret
    }
  }

  def define_slot_reader: slotname {
    dynamic_method: (":#{slotname}" to_sym) with: @{
      total_args: 0
      required_args: 0
      push_ivar("@#{slotname}" to_sym)
      ret
    }
  }
}
